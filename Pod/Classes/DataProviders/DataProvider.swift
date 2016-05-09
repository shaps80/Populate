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
import ObjectiveC

/// Defines a change handler for section events
public typealias DataProviderSectionChangeHandlerBlock = (changeType: DataProviderChangeType, sectionIndex: Int) -> Void


/// Defines a change handler for item events
public typealias DataProviderItemChangeHandlerBlock = (changeType: DataProviderChangeType, source: NSIndexPath?, destination: NSIndexPath?) -> Void


/**
 *  Defines the type of change that occured on a dataProvider
 */
public enum DataProviderChangeType {
  /**
   *  An item was inserted into the model
   */
  case Insert
  /**
   *  An item was deleted from the model
   */
  case Delete
  /**
   *  An item was moved inside the model
   */
  case Move
  /**
   *  An item was changed inside the model
   */
  case Update
}


/// A class conforming to this protocol, can provide data to a DataCoordinator
public protocol DataProvider: class {
  
  /// The underlying data type this provider represents
  associatedtype DataType: DataProviderSupported
  
  /// The function will be executed when a section changes
  var sectionChangeHandler: DataProviderSectionChangeHandlerBlock? { get set }
  
  /// The function will be executed when an item changes
  var itemChangeHandler: DataProviderItemChangeHandlerBlock? { get set }
  
  /// This function will be executed when a reload is required
  var reloadHandler: (Void -> Void)? { get set }
  
  /// Defines the section-name keyPath to use for grouping results
  var sectionNameKeyPath: String? { get set }
  
  /// Returns the current sections associated with this dataProvider
  var sections: [DataProviderSectionInfo<DataType>] { get }
  
  /**
   Returns the number of sections this dataProvider contains
   
   - returns: The number of sections
   */
  func numberOfSections() -> Int
  
  /**
   Returns the number of items in the specified section
   
   - parameter section: The section to query
   
   - returns: The number of items
   */
  func numberOfItemsInSection(section: Int) -> Int
  
  /**
   Returns the item at the specified indexPath if it exists, nil otherwise
   
   - parameter indexPath: The indexPath to query
   
   - returns: The associated item if it exists, nil otherwise
   */
  func itemAtIndexPath(indexPath: NSIndexPath) -> DataType?
  
  /**
   Returns the indexPath of the associated item
   
   - parameter item: The item to query
   
   - returns: The associated indexPath if it exists, nil otherwise
   */
  func indexPathForItem(item: DataType) -> NSIndexPath?
  
  /**
   Returns the title for the specified section
   
   - parameter section: The section to query
   
   - returns: The section title
   */
  func titleForSection(section: Int) -> String?
  
}