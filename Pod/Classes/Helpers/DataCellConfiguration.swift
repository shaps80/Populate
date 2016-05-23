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
 *  Provides a type safe struct for providing cell configurations to a DataCoordinator
 */
public struct DataCellConfiguration {

  /// Provides access to the cell this configuration constructed -- this is NOT retained!
  public unowned let cell: DataCell

  /**
   Initializes a new cell configuration
   
   - parameter dataView:        The dataView this cell will be added to
   - parameter reuseIdentifier: The reuseIdentifier to use for registeration and dequeuing
   - parameter indexPath:       The indexPath this cell will be inserted at
   - parameter registerCell:    If true, the cell will be automatically registered by its class. Pass false to prevent this. Defaults to true
   - parameter configuration:   The cell configuration - will execute whenever this cell is presented on the screen
   */
  public init<C: DataCell, V: DataView>(dataView: V, reuseIdentifier: String, indexPath: NSIndexPath, registerCell: Bool = true, @noescape configuration: (C) -> Void) {
    if registerCell {
      dataView.registerClass(C.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    guard let cell = dataView.dequeueCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? C else {
      fatalError("Invalid cell type returned!")
    }
    
    configuration(cell)
    self.cell = cell
  }
    
}

public struct SupplementaryViewConfiguration {
  
  public unowned let view: UICollectionReusableView
  
  public init<C: UICollectionReusableView, V: DataView>(dataView: V, elementKind: String, reuseIdentifier: String, indexPath: NSIndexPath, registerView: Bool = true, @noescape configuration: (C) -> Void) {
    if registerView {
      dataView.registerClass(C.classForCoder(), forSupplementaryViewOfKind: elementKind, withReuseIdentifier: reuseIdentifier)
    }
    
    guard let view = dataView.dequeueReusableSupplementaryViewOfKind(elementKind, withReuseIdentifier: reuseIdentifier, forIndexPath: indexPath) as? C else {
      fatalError("Invalid cell type returned!")
    }
    
    configuration(view)
    self.view = view
  }
  
}