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

/// A class conforming to this protocol, can provide cells to a DataCoordinator's DataView
public protocol DataCell: class {
  
  static var reuseIdentifier: String { get }
  
  /// The reuse identifier associated with this cell
  var reuseIdentifier: String? { get }
  
  /**
   Returns the class type representing this object
   
   - returns: The class type
   */
  static func classForCoder() -> AnyClass
  
}

extension DataCell {
  
  public static var reuseIdentifier: String {
    return NSStringFromClass(self).components(separatedBy: ".").last!
  }
  
}

extension UICollectionReusableView {
  
  public static var kind: String {
    return NSStringFromClass(self).components(separatedBy: ".").last!
  }
  
}

extension UICollectionViewCell: DataCell { }
extension UITableViewCell: DataCell { }

/// A class conforming to this protocol, can provide a DataView to a DataCoordinator
public protocol DataView: class {

  /// The dataSource property type -- this is to wrap and proxy calls from UITableView, UICollectionView, etc...
  associatedtype DataSourceType
  
  /// The dataSource associated with this view
  var dataSource: DataSourceType? { get set }

  /**
   Reloads the view's data
   */
  func reloadData()
  
  /**
   Allows you to perform batch updates on the view
   
   - parameter updates:    The updates to perform
   - parameter completion: This will be executed when all updates have completed
   */
  func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?)
  
  /**
   Registers the specified class with the view
   
   - parameter cellClass:  The cell class to register
   - parameter identifier: The identifier to use for this registration
   */
  func registerClass(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String)
  
  /**
   Registers the specified class with the view
   
   - parameter viewClass:   The cell class to register
   - parameter elementKind: The kind of element to register
   - parameter identifier:  The identifier to use for this registration
   */
  func registerClass(_ viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String)
  
  /**
   Dequeues a cell with the specified reuse identifier
   
   - parameter identifier: The reuse identifier associated with this cell
   - parameter indexPath:  The indexPath the cell will be inserted into
   */
  func dequeueCellWithReuseIdentifier(_ identifier: String, forIndexPath indexPath: IndexPath) -> DataCell
  
  /**
   Dequeues a supplementary view with the specified reuse identifier
   
   - parameter elementKind: The kind of element to dequeue
   - parameter identifier:  the reuse identifier associated with this view
   - parameter indexPath:   The indexPath the view will be inserted into
   */
  func dequeueReusableSupplementaryViewOfKind(_ elementKind: String, withReuseIdentifier identifier: String, forIndexPath indexPath: IndexPath) -> UICollectionReusableView
  
  /**
   Inserts the specified sections
   
   - parameter sections: The sections to insert
   */
  func insertSections(_ sections: IndexSet)
  
  /**
   Deletes the specified sections
   
   - parameter sections: The sections to delete
   */
  func deleteSections(_ sections: IndexSet)
  
  /**
   Reloads the specified sections
   
   - parameter sections: The sections to reload
   */
  func reloadSections(_ sections: IndexSet)
  
  /**
   Moves the specified section
   
   - parameter section:    The old section index
   - parameter newSection: The new section index
   */
  func moveSection(_ section: Int, toSection newSection: Int)
  
  /**
   Inserts the items at the specified indexPaths
   
   - parameter indexPaths: The indexPaths to insert
   */
  func insertItemsAtIndexPaths(_ indexPaths: [IndexPath])
  
  /**
   Delete the items at the specified indexPaths
   
   - parameter indexPaths: The indexPaths to delete
   */
  func deleteItemsAtIndexPaths(_ indexPaths: [IndexPath])
  
  /**
   Reloads the items at the specified indexPaths
   
   - parameter indexPaths: The indexPaths to reload
   */
  func reloadItemsAtIndexPaths(_ indexPaths: [IndexPath])
  
  /**
   Moves the item at the specified indexPath
   
   - parameter indexPath:    The old indexPath
   - parameter newIndexPath: The new indexPath
   */
  func moveItemAtIndexPath(_ indexPath: IndexPath, toIndexPath newIndexPath: IndexPath)

}
