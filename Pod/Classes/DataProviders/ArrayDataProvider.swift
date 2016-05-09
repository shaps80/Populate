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

import Foundation

/// An array data provider provides array backed data to a DataCoordinator. Including sectioning, filtering and sorting options. It basically provides similar functionality to an NSFetchedResultsController
public final class ArrayDataProvider<T: DataProviderSupported>: DataProvider {
  
  /// The underlying data type
  public typealias DataType = T
  
  /// Defines the sort function signature
  public typealias ArrayDataProviderItemSortFunction = (DataType, DataType) -> Bool
  
  /// Get/set the sections associated with this provider
  public private(set) var sections: [DataProviderSectionInfo<T>]
  
  /// Get/set the unsorted, unfiltered, ungrouped items associated with this provider
  public private(set) var items: [T]?
  
  /// Get/set the sort functions associated with this provider
  private(set) var itemSort = [ArrayDataProviderItemSortFunction]() {
    didSet { reload() }
  }
  
  /// Get/set the filter function associated with this provider
  private(set) var filter: ((T) -> Bool)? {
    didSet { reload() }
  }
  
  /// Get/set the sectionName keyPath associated with this provider
  public var sectionNameKeyPath: String? {
    didSet { reload() }
  }
  
  /// Get/set the section change handler function associated with this provider
  public var sectionChangeHandler: DataProviderSectionChangeHandlerBlock?
  
  /// Get/set the item change handler function associated with this provider
  public var itemChangeHandler: DataProviderItemChangeHandlerBlock?
  
  /// Get/set the reload handler function associated with this provider
  public var reloadHandler: (Void -> Void)? {
    didSet { reload() }
  }
  
  /**
   Initialises this provider with the association items (optional)
   
   - parameter items: The items to seed this provider with
   
   - returns: The configured provider
   */
  public init(items: [DataType]? = nil) {
    self.items = items
    self.sections = []
  }
  
  /**
   Appends the specified sort function. This will be applied for all changes and reloads
   
   - parameter isOrderedBefore: Return true if the left hand item is ordered before the right hand item
   
   - returns: Self -- can be used for chaining
   */
  public func sort(isOrderedBefore: (T, T) -> Bool) -> Self {
    itemSort.append(isOrderedBefore)
    return self
  }
  
  /**
   Sets the filter function. This will be applied for all changes and reloads
   
   - parameter includeElement: Returns true if the item should be included
   
   - returns: Self -- can be used for chaining
   */
  public func filter(includeElement: (T) -> Bool) -> Self {
    filter = includeElement
    return self
  }
  
  /**
   Returns the item at the specified indexPath if it exists, nil otherwise
   
   - parameter indexPath: The indexPath to query
   
   - returns: The associated item if it exists, nil otherwise
   */
  public func itemAtIndexPath(indexPath: NSIndexPath) -> T? {
    guard sections.indices.contains(indexPath.section) else {
      return nil
    }
    
    let section = sections[indexPath.section]
    
    guard section.items.indices.contains(indexPath.item) else {
      return nil
    }
    
    return section.items[indexPath.item]
  }
  
  /**
   Returns the indexPath of the associated item
   
   - parameter item: The item to query
   
   - returns: The associated indexPath if it exists, nil otherwise
   */
  public func indexPathForItem(item: DataType) -> NSIndexPath? {
    for (sectionIndex, section) in sections.enumerate() {
      if let itemIndex = section.items.indexOf(item) {
        return NSIndexPath(forItem: itemIndex, inSection: sectionIndex)
      }
    }
    
    return nil
  }
  
  /**
   Returns the number of sections this dataProvider contains
   
   - returns: The number of sections
   */
  public func numberOfSections() -> Int {
    return sections.count ?? 0
  }
  
  /**
   Returns the number of items in the specified section
   
   - parameter section: The section to query
   
   - returns: The number of items
   */
  public func numberOfItemsInSection(section: Int) -> Int {
    guard section < sections.count else {
      return 0
    }

    return sections[section].items.count ?? 0
  }
  
  /**
   Adds the specified item to the provider
   
   - parameter item: The item to add
   */
  public func add(item: T) {
    let section = sectionInfoForItem(item)
    section.items.append(item)
    items?.append(item)
    
    if let index = sections.indexOf(section) {
      sections.insert(section, atIndex: index)
      sections.removeAtIndex(index)
    }
    
    guard let sectionIndex = sections.indexOf(section), itemIndex = section.items.indexOf(item) else {
      reload() // something went wrong -- reload to be safe
      return
    }
    
    let indexPath = NSIndexPath(forItem: itemIndex, inSection: sectionIndex)
    itemChangeHandler?(changeType: .Insert, source: nil, destination: indexPath)
  }
  
  /**
   Deletes the specified item from the provider (if it exists)
   
   - parameter item: The item to delete
   */
  public func delete(item: T) {
    guard let index = items?.indexOf(item), indexPath = indexPathForItem(item) else {
      return
    }
    
    items?.removeAtIndex(index)
    
    let section = sections[indexPath.section]
    section.items.removeAtIndex(indexPath.item)
    
    if section.items.count == 0 {
      sections.removeAtIndex(indexPath.section)
      sectionChangeHandler?(changeType: .Delete, sectionIndex: indexPath.section)
      return
    }
    
    itemChangeHandler?(changeType: .Delete, source: indexPath, destination: nil)
  }
  
  /**
   Deletes the item at the specified indexPath
   
   - parameter indexPath: The indexPath to delete
   */
  public func delete(atIndexPath indexPath: NSIndexPath) {
    guard let item = itemAtIndexPath(indexPath) else {
      fatalError("No item to delete at \(indexPath)")
    }
    
    delete(item)
  }
  
  /**
   Updates the item at the specified indexPath
   
   - parameter indexPath: The indexPath to replace
   - parameter newItem:   The new item
   */
  public func updateItem(atIndexPath indexPath: NSIndexPath, withItem newItem: T) {
    guard let _ = itemAtIndexPath(indexPath) else {
      fatalError("No item to replace at \(indexPath)")
    }
    
    let section = sections[indexPath.section]
    
    section.items.removeAtIndex(indexPath.item)
    section.items.insert(newItem, atIndex: indexPath.item)
    
    itemChangeHandler?(changeType: .Update, source: indexPath, destination: nil)
  }
  
  /**
   Returns the title for the specified section
   
   - parameter section: The section to query
   
   - returns: The section title
   */
  public func titleForSection(section: Int) -> String? {
    if sections.indices.contains(section) {
      return sections[section].name
    }
    
    return nil
  }
  
  /**
   Reloads the dataProvider -- Section and Item Change Handlers will be temporarily disabled
   
   - Filters items
   - Groups by sectionNameKeyPath
   - Sorts the results
   */
  private func reload() {
    let itemHandler = itemChangeHandler
    let sectionHandler = sectionChangeHandler
    
    itemChangeHandler = nil
    sectionChangeHandler = nil
    
    // --- The code above temporarily disables updates from being sent while we construct the sections
    
    if reloadHandler == nil {
      return
    }
    
    guard var items = self.items else {
      sections.removeAll()
      reloadHandler?()
      return
    }

    if let sort = self.itemSort.first {
      items.sortInPlace(sort)
    }
    
    let itemSort = Array(self.itemSort.dropFirst())
    
    if let filter = self.filter {
      items = items.filter(filter)
    }
    
    for item in items {
      let section = sectionInfoForItem(item)
      section.items.append(item)
    }
    
    if itemSort.count > 0 {
      for section in sections {
        for sort in itemSort {
          section.items = section.items.sort(sort)
        }
      }
    }
    
    reloadHandler?()
    
    // --- Now we can re-wire the update handlers
    
    itemChangeHandler = itemHandler
    sectionChangeHandler = sectionHandler
  }
  
  /**
   Returns the sectionInfo associated with this item. This function will insert a new section if neccessary
   
   - parameter item: The item to query
   
   - returns: The new or existing section
   */
  private func sectionInfoForItem(item: T) -> DataProviderSectionInfo<T> {
    let sectionNameKeyPath = self.sectionNameKeyPath ?? ""
    
    var value = ""
    if let sectionValue = item.valueForKeyPath(sectionNameKeyPath) {
      value = "\(sectionValue)"
    }
    
    for section in self.sections {
      if section.name == value {
        return section
      }
    }
    
    let section = DataProviderSectionInfo<T>(name: value)
    
    guard let sort = itemSort.first where sectionChangeHandler != nil else {
      sections.append(section)
      sectionChangeHandler?(changeType: .Insert, sectionIndex: sections.count)
      return section
    }
    
    let index = self.items?.sort(sort).insertionIndexOf(item, isOrderedBefore: sort)
    var count = 0
    var sectionIndex = 0
    
    for section in sections {
      count += section.numberOfItems
      
      if index < count {
        break
      } else {
        sectionIndex += 1
      }
    }
    
    sections.insert(section, atIndex: sectionIndex)
    sectionChangeHandler?(changeType: .Insert, sectionIndex: sectionIndex)
    
    return section
  }
  
}