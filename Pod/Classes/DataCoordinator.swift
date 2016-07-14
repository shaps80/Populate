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

extension DataCoordinator where V: UICollectionView {
  
  public convenience init(dataView: V, cellAndSupplementaryViewProvider provider: CellAndSupplementaryViewProviding, dataProvider: DataProviderInitializationBlock<D>) {
    self.init(dataView: dataView, cellProvider: provider, supplementaryViewProvider: provider, dataProvider: dataProvider)
  }
  
}

public typealias DataProviderInitializationBlock<D> = () -> D

/// The Data Coordinator is the central interface for working with the library. The coordinator is responsible for coordinating events between its associated Data View and Data Provider
public final class DataCoordinator<V: DataView, D: DataProvider>
{
  
  /// A variable used internally to determine whether or not we should simply reload the dataView
  var shouldReload = false
  
  /// A dataView-dataSource wrapper for proxying calls
  private var dataViewDataSource: DataViewDataSource // we need to keep a ref since we are the only owner
  
  /// The cell provider is responsible for returning cell configurations
  unowned var cellProvider: CellProviding
  
  /// The supplementary view provider is responsible for returning a reusable view
  weak var supplementaryViewProvider: CellAndSupplementaryViewProviding?
  
  /// A delegate that can respond to dataView delegate calls
  public weak var delegate: DataCoordinatorDelegate?
  
  /// The dataView associated with this coordinator
  public let dataView: V
  
  /// The dataProvider associated with this coordinator
  public let dataProvider: D
  
  /**
   Initialises a new coordinator
   
   - parameter dataView:     The dataView to associate with this coordinator
   - parameter cellProvider: The cellProvider to associate with this coordinator
   - parameter dataProvider: The dataProvider to associate with this coordinator
   
   - returns: A newly configured coordinator
   */
  public convenience init(dataView: V, cellProvider: CellProviding, dataProvider: DataProviderInitializationBlock<D>) {
    self.init(dataView: dataView, cellProvider: cellProvider, supplementaryViewProvider: nil, dataProvider: dataProvider)
  }
  
  init(dataView: V, cellProvider: CellProviding, supplementaryViewProvider: CellAndSupplementaryViewProviding?, dataProvider: DataProviderInitializationBlock<D>) {
    self.dataView = dataView
    self.dataProvider = dataProvider()
    self.cellProvider = cellProvider
    self.supplementaryViewProvider = supplementaryViewProvider
    
    dataViewDataSource = DataViewDataSource()
    
    guard let dataSource = self.dataViewDataSource as? V.DataSourceType else {
      fatalError("Your MUST extend DataViewDataSource to support your custom dataSource -- see DataViewDataSource+TableView.swift for an example")
    }
    
    self.dataView.dataSource = dataSource
    self.dataViewDataSource.delegate = self
    
    self.dataProvider.reloadHandler = reloadHandler
    self.dataProvider.sectionChangeHandler = dataProviderSectionChangeHandler
    self.dataProvider.itemChangeHandler = dataProviderItemChangeHandler
  }
  
  private func reloadHandler() {
    dataView.reloadData()
  }
  
  private func dataProviderSectionChangeHandler(_ changeType: DataProviderChangeType, sectionIndex: Int) {
    switch changeType {
    case .insert: dataView.insertSections(IndexSet(integer: sectionIndex))
    case .delete: dataView.deleteSections(IndexSet(integer: sectionIndex))
    default: break
    }
  }
  
  private func dataProviderItemChangeHandler(_ changeType: DataProviderChangeType, source: IndexPath?, destination: IndexPath?) {
    guard source != nil || destination != nil else {
      dataView.reloadData()
      return
    }
    
    switch changeType {
    case .insert:
      dataView.insertItemsAtIndexPaths([destination!])
    case .delete:
      dataView.deleteItemsAtIndexPaths([source!])
    case .move:
      dataView.deleteItemsAtIndexPaths([source!])
      dataView.insertItemsAtIndexPaths([destination!])
    case .update:
      dataView.reloadItemsAtIndexPaths([source!])
    }
  }
  
}
