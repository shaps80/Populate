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
  
  public func registerClass(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
    register(cellClass, forCellReuseIdentifier: identifier)
  }
  
  public func registerClass(_ viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String) {
    // not supported
  }
  
  public func dequeueReusableSupplementaryViewOfKind(_ elementKind: String, withReuseIdentifier identifier: String, forIndexPath indexPath: IndexPath) -> UICollectionReusableView {
    return UICollectionReusableView()
  }
  
  public func dequeueCellWithReuseIdentifier(_ identifier: String, forIndexPath indexPath: IndexPath) -> DataCell {
    return dequeueReusableCell(withIdentifier: identifier, for: indexPath)
  }
  
  public func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
    beginUpdates()
    updates?()
    endUpdates()
    completion?(true)
  }
  
  public func insertSections(_ sections: IndexSet) {
    insertSections(sections, with: .fade)
  }
  
  public func deleteSections(_ sections: IndexSet) {
    deleteSections(sections, with: .fade)
  }
  
  public func reloadSections(_ sections: IndexSet) {
    reloadSections(sections, with: .fade)
  }
  
  public func insertItemsAtIndexPaths(_ indexPaths: [IndexPath]) {
    insertRows(at: indexPaths, with: .fade)
  }
  
  public func deleteItemsAtIndexPaths(_ indexPaths: [IndexPath]) {
    deleteRows(at: indexPaths, with: .fade)
  }
  
  public func reloadItemsAtIndexPaths(_ indexPaths: [IndexPath]) {
    reloadRows(at: indexPaths, with: .automatic)
  }
  
  public func moveItemAtIndexPath(_ indexPath: IndexPath, toIndexPath newIndexPath: IndexPath) {
    moveRow(at: indexPath, to: newIndexPath)
  }
  
}
