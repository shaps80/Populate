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

/// An class conforming to this protocol can provide DataCell's to a DataCoordinator
public protocol DataCoordinatorCellProviding: class {
  func dataCoordinator<V: DataView>(dataView: V, cellConfigurationForIndexPath indexPath: NSIndexPath) -> DataCellConfiguration
}

/// A class conforming to this protocol can delegate dataView calls
@objc public protocol DataCoordinatorDelegate: class {
  optional func dataCoordinator(titleForHeaderInSection section: Int) -> String?
  optional func dataCoordinator(titleForFooterInSection section: Int) -> String?
  optional func dataCoordinator(canEditIndexPath indexPath: NSIndexPath) -> Bool
  optional func dataCoordinator(canMoveAtIndexPath indexPath: NSIndexPath) -> Bool
  optional func dataCoordinator(commitEditing type: DataViewEditType, atIndexPath indexPath: NSIndexPath)
  optional func dataCoordinator(moveItemFromIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
}