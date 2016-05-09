# Populate

[![CI Status](http://img.shields.io/travis/shaps80/Populate.svg?style=flat)](https://travis-ci.org/Shaps Mohsenin/Populate)
[![Version](https://img.shields.io/cocoapods/v/Populate.svg?style=flat)](http://cocoapods.org/pods/Populate)
[![License](https://img.shields.io/cocoapods/l/Populate.svg?style=flat)](http://cocoapods.org/pods/Populate)
[![Platform](https://img.shields.io/cocoapods/p/Populate.svg?style=flat)](http://cocoapods.org/pods/Populate)

## What is Populate?

Often in our iOS apps, we need to populate a `UITableView` or `UICollectionView` with some data.

When using CoreData, this is a fairly trivial task since `NSFetchedResultsController` does most of the heavy lifting for us. 

## Introducing Populate

Here's a few reason you should start using Populate in your projects now:

- 100% Swift 
- Protocol-Oriented architecture
- Type-safety (Views, Cells and Data)
- Supports both **value** and/or **reference** types
- Multiple **type-safe** cells
- ArrayDataProvider -- a **type-safe** provider similar to `NSFetchedResultsController`
    - Filtering
    - Sectioning
    - Sorting
    - Add, remove, update (with type-safety)    

So lets take a look and see what this looks like in code.

## Example

To get started, Populate only requires 2 things:

```swift
// Sets up the coordinator
init(dataView: V, cellProvider: DataCoordinatorCellProviding, @noescape dataProvider: () -> D)

// Configure your cells
func dataCoordinator<V: DataView>(dataView: V, cellConfigurationForIndexPath indexPath: NSIndexPath) -> DataCellConfiguration
```

Lets start by settings up the `DataCoordinator`:

```swift
@import Populate

final class PeopleViewController: UITableViewController, DataCoordinatorCellProviding {
    
  // Popoulate uses a coordinator to manage your view, its cells and the associated data
  private var dataCoordinator: DataCoordinator<UITableView, ArrayDataProvider<Person>>?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // We initialize the coordinator with a dataView, cellProvider and a dataProvider configuration
    dataCoordinator = DataCoordinator(dataView: tableView, cellProvider: self) {
    
      // So lets seed our dataProvider for convenience
      let provider = ArrayDataProvider(items: [
        Person(name: "Shaps", address: Address(postcode: "W5")),
        Person(name: "Anne", address: Address(postcode: "W5")),
        Person(name: "Neil", address: Address(postcode: "N1")),
        Person(name: "Neil", address: Address(postcode: "A1")),
        Person(name: "Daniela", address: Address(postcode: "N1")),
        Person(name: "Luciano", address: Address(postcode: "SW4")),
      ])
      
      // We can specify a sectionNameKeyPath 
      provider.sectionNameKeyPath = "address.postcode"
     
      // Finally, lets return our provider along with some additional filtering and sort functions 
      return provider
        .filter { $0.address?.postcode != "SW4" }
        .sort { $0.address?.postcode < $1.address?.postcode }
        .sort { $0.name < $1.name }
    }
  }  

}
```

Ok, so that's a very verbose implementation, yours would probably be a lot cleaner.

Notice the we enforce the type just once on the `var`. This is great, because it means we can get type-safe compiler warnings when things go wrong.

So, what about the cell for our dataView? Populate provides a type-safe method for configuring your cells:

```swift
func dataCoordinator<V : DataView>(dataView: V, cellConfigurationForIndexPath indexPath: NSIndexPath) -> DataCellConfiguration {
  return DataCellConfiguration(dataView: dataView, reuseIdentifier: "Cell", registerCell: true, indexPath: indexPath, configuration: { (cell: UITableViewCell) in
    let person = dataCoordinator?.dataProvider.itemAtIndexPath(indexPath)
    cell.textLabel?.text = person?.name
  })
}
```

Ok, so setting up the cell looks complicated, but in actual fact, you're basically just passing the params through to the `DataCellConfiguration`. 

This is a special class that allows multiple, type-safe cells to be configured from a single function.

You might also notice `registerCell`. This is on by default and basically tells Populate to automatically register the cell (using its type) for you. This means you don't need to register your cell beforehand ;)

Note: This will not work for cells loaded from storyboards or nibs. If you are using one of those, pass false here.

## ArrayDataProvider

A `DataProvider` is simply a protocol, however Populate includes an array-based provider by default. 

This allows you to pass a flat array, and get all the benefits you traditionally get via `NSFetchedResultsController`.

Features like, sectioning, sorting, filtering and even mutation are all available. PLUS you get automatic updates reflected in your `DataView`.

```swift
func add(item: T)
func delete(item: T)
func delete(atIndexPath indexPath: NSIndexPath)
func updateItem(atIndexPath indexPath: NSIndexPath, withItem newItem: T)
```

Note: All mutating functions are type-safe.

## Platforms

Populate is supported on the following platforms & versions:

- iOS 8.0+

## Installation

Populate is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Populate"
```

## Author

Shaps [@shaps](http://twiter.com/shaps)

## License

Populate is available under the MIT license. See the LICENSE file for more info.
