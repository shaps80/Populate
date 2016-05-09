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


// MARK: - This extension proxy's calls to the appropriate instances
extension DataCoordinator: DataViewDataSourceDelegate {
  
  // MARK: DataViewDataSourceDelegate Methods
  
  func cellForItemAtIndexPath(indexPath: NSIndexPath) -> DataCell {
    return cellProvider.dataCoordinator(dataView, cellConfigurationForIndexPath: indexPath).cell
  }
  
  func numberOfSections() -> Int {
    return dataProvider.numberOfSections()
  }

  func numberOfRows(inSection section: Int) -> Int {
    return dataProvider.numberOfItemsInSection(section)
  }
  
  func canEditCell(atIndexPath indexPath: NSIndexPath) -> Bool {
    return delegate?.dataCoordinator?(canEditIndexPath: indexPath) ?? false
  }
  
  func commit(editingType: DataViewEditType, atIndexPath indexPath: NSIndexPath) {
    delegate?.dataCoordinator?(commitEditing: editingType, atIndexPath: indexPath)
  }
  
  func canMoveCell(atIndexPath indexPath: NSIndexPath) -> Bool {
    return delegate?.dataCoordinator?(canMoveAtIndexPath: indexPath) ?? false
  }
  
  func move(sourceIndexPath: NSIndexPath, _ destinationIndexPath: NSIndexPath) {
    delegate?.dataCoordinator?(moveItemFromIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
  }
  
  func titleForHeader(inSection section: Int) -> String? {
    if let title = delegate?.dataCoordinator?(titleForHeaderInSection: section) {
      return title
    }
    
    return dataProvider.titleForSection(section)
  }
  
  func titleForFooter(inSection section: Int) -> String? {
    return delegate?.dataCoordinator?(titleForFooterInSection: section)
  }
  
}