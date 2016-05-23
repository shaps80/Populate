//
//  UITableView+DataViewDataSource.swift
//  Populate
//
//  Created by Shaps Mohsenin on 09/05/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

@objc class DataViewDataSource: NSObject {
  weak var delegate: DataViewDataSourceDelegate?
}

// MARK: - This extension proxies the a UITableViewDataSource's calls back to the dataCoordinator's delegate
extension DataViewDataSource: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return delegate?.numberOfSections() ?? 0
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return delegate?.numberOfRows(inSection: section) ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = delegate?.cellForItemAtIndexPath(indexPath) as? UITableViewCell else {
      fatalError("Invalid cell type found")
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return delegate?.canEditCell(atIndexPath: indexPath) ?? false
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    delegate?.commit(DataViewEditType.fromEditingStyle(editingStyle), atIndexPath: indexPath)
  }
  
  func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return delegate?.canMoveCell(atIndexPath: indexPath) ?? false
  }
  
  func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    delegate?.move(sourceIndexPath, destinationIndexPath)
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return delegate?.titleForHeader(inSection: section)
  }
  
  func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return delegate?.titleForFooter(inSection: section)
  }
  
}

// MARK: - This extension proxies the a UICollectionViewDataSource's calls back to the dataCoordinator's delegate
extension DataViewDataSource: UICollectionViewDataSource {
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return delegate?.numberOfSections() ?? 0
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return delegate?.numberOfRows(inSection: section) ?? 0
  }
  
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    return delegate?.supplementaryView(forElementKind: kind, atIndexPath: indexPath) ?? UICollectionReusableView()
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    guard let cell = delegate?.cellForItemAtIndexPath(indexPath) as? UICollectionViewCell else {
      fatalError("Invalid cell type found")
    }
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return delegate?.canMoveCell(atIndexPath: indexPath) ?? false
  }
  
  func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    delegate?.move(sourceIndexPath, destinationIndexPath)
  }

}
