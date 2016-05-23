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

extension UITableView: DataView {
  
  public typealias DataSourceType = UITableViewDataSource
  
  public func registerClass(cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
    registerClass(cellClass, forCellReuseIdentifier: identifier)
  }
  
  public func registerClass(viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String) {
    // not supported
  }
  
  public func dequeueReusableSupplementaryViewOfKind(elementKind: String, withReuseIdentifier identifier: String, forIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    return UICollectionReusableView()
  }
  
  public func dequeueCellWithReuseIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> DataCell {
    return dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
  }
  
  public func performBatchUpdates(updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
    beginUpdates()
    updates?()
    endUpdates()
    completion?(true)
  }
  
  public func insertSections(sections: NSIndexSet) {
    insertSections(sections, withRowAnimation: .Fade)
  }
  
  public func deleteSections(sections: NSIndexSet) {
    deleteSections(sections, withRowAnimation: .Fade)
  }
  
  public func reloadSections(sections: NSIndexSet) {
    reloadSections(sections, withRowAnimation: .Fade)
  }
  
  public func insertItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
    insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
  }
  
  public func deleteItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
    deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
  }
  
  public func reloadItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
    reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }
  
  public func moveItemAtIndexPath(indexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath) {
    moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
  }
  
}