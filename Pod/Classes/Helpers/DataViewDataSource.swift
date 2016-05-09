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

/**
 Defines an editing type
 
 - None:   No editing
 - Insert: An insertion
 - Delete: A delete
 */
@objc public enum DataViewEditType: Int {
  case None
  case Insert
  case Delete
  
  /**
   Converts a UITableViewCellEditingStyle to a DataViewEditType
   
   - parameter style: The style to evaluate
   
   - returns: A UITableViewCellEditingStyle
   */
  static func fromEditingStyle(style: UITableViewCellEditingStyle) -> DataViewEditType {
    switch style {
    case .None: return .None
    case .Insert: return .Insert
    case .Delete: return .Delete
    }
  }
}

/// A class conforming to this protocol is used to proxy DataView.dataSource calls
protocol DataViewDataSourceDelegate: class {
  
  /**
   The number of sections in the dataSource
   
   - returns: The number of sections
   */
  func numberOfSections() -> Int
  
  /**
   The number of items in the specified section in the dataSource
   
   - parameter section: The section to query
   
   - returns: The number of items
   */
  func numberOfRows(inSection section: Int) -> Int

  /**
   Return true if editing is allowed, false otherwise
   
   - parameter indexPath: The indexPath to query
   
   - returns: True if editing is allowed, false otherwise
   */
  func canEditCell(atIndexPath indexPath: NSIndexPath) -> Bool
  
  /**
   Commits the specified changes
   
   - parameter editingType: The editType that was attempted
   - parameter indexPath:   The indexPath that is impacted by this change
   */
  func commit(editingType: DataViewEditType, atIndexPath indexPath: NSIndexPath)
  
  /**
   Return true if moving is allowed, false otherwise
   
   - parameter indexPath: The indexPath to query
   
   - returns: True if moving is allowed, false otherwise
   */
  func canMoveCell(atIndexPath indexPath: NSIndexPath) -> Bool
  
  /**
   Moves the item from sourceIndexPath to destinationIndexPath
   
   - parameter sourceIndexPath:      The old indexPath
   - parameter destinationIndexPath: The new indexPath
   */
  func move(sourceIndexPath: NSIndexPath, _ destinationIndexPath: NSIndexPath)

  /**
   Return the header title for the specified section
   
   - parameter section: The section to query
   
   - returns: The title for this header
   */
  func titleForHeader(inSection section: Int) -> String?
  
  /**
   Return the footer title for the specified section
   
   - parameter section: The section to query
   
   - returns: The title for this footer
   */
  func titleForFooter(inSection section: Int) -> String?
  
  /**
   Return the cell for the specified indexPath
   
   - parameter indexPath: The indexPath to query
   
   - returns: The cell for the specified indexPath
   */
  func cellForItemAtIndexPath(indexPath: NSIndexPath) -> DataCell
  
}