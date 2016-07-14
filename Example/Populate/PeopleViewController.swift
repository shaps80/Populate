/*
  Copyright © 09/05/2016 Shaps

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
 */

import UIKit
import Populate

class PeopleViewController: UIViewController, CellProviding, DataCoordinatorDelegate {

  @IBOutlet var tableView: UITableView!
  private var dataCoordinator: DataCoordinator<UITableView, ArrayDataProvider<Person>>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataCoordinator = DataCoordinator(dataView: tableView, cellProvider: self) {
      let provider = ArrayDataProvider(items: [
        Person(name: "Shaps", address: Address(postcode: "W5")),
        Person(name: "Anne", address: Address(postcode: "W5")),
        Person(name: "Neil", address: Address(postcode: "N1")),
        Person(name: "Neil", address: Address(postcode: "A1")),
        Person(name: "Daniela", address: Address(postcode: "SS1")),
        Person(name: "Luciano", address: Address(postcode: "SW4")),
      ])
      
      provider.sectionNameKeyPath = "address.postcode"
      
      return provider
        .filter { $0.address?.postcode != "SW4" }
        .sort { $0.address?.postcode < $1.address?.postcode }
        .sort { $0.name < $1.name }
    }
    
    dataCoordinator?.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    DispatchQueue.main.after(when: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
      self.update()
    }
  }
  
  @IBAction func reload() {
    tableView.reloadData()
  }
  
  func update() {
    let indexPath = IndexPath(item: 1, section: 2)
    
    if var person = dataCoordinator?.dataProvider.itemAtIndexPath(indexPath) {
      person.name = "Mohsenin"
      dataCoordinator?.dataProvider.updateItem(atIndexPath: indexPath, withItem: person)
    }
    
    let person = Person(name: "Anne Benkau", address: Address(postcode: "W34"))
    dataCoordinator?.dataProvider.add(person)
    
    dataCoordinator?.dataProvider.delete(atIndexPath: IndexPath(item: 0, section: 0))
  }
  
  func dataCoordinator<V : DataView>(_ dataView: V, cellConfigurationForIndexPath indexPath: IndexPath) -> DataCellConfiguration {
    return DataCellConfiguration(dataView: dataView, reuseIdentifier: "Cell", indexPath: indexPath, configuration: { (cell: UITableViewCell) in
      let person = self.dataCoordinator?.dataProvider.itemAtIndexPath(indexPath)
      cell.textLabel?.text = person?.name
    })
  }
  
}

class Address: NSObject {
  
  var postcode: String
  
  init(postcode: String) {
    self.postcode = postcode
  }
  
}

struct Person: DataProviderSupported {
  
  var name: String
  var address: Address?
  
  init(name: String, address: Address? = nil) {
    self.name = name
    self.address = address
  }
  
  var hashValue: Int {
    return name.hashValue
  }
  
}

func ==(lhs: Person, rhs: Person) -> Bool {
  return lhs.name == rhs.name
}
