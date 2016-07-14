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
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return delegate?.numberOfSections() ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return delegate?.numberOfRows(inSection: section) ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = delegate?.cellForItemAtIndexPath(indexPath) as? UITableViewCell else {
      fatalError("Invalid cell type found")
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return delegate?.canEditCell(atIndexPath: indexPath) ?? false
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    delegate?.commit(DataViewEditType.fromEditingStyle(editingStyle), atIndexPath: indexPath)
  }
  
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return delegate?.canMoveCell(atIndexPath: indexPath) ?? false
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    delegate?.move(sourceIndexPath, destinationIndexPath)
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return delegate?.titleForHeader(inSection: section)
  }
  
  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return delegate?.titleForFooter(inSection: section)
  }
  
}

// MARK: - This extension proxies the a UICollectionViewDataSource's calls back to the dataCoordinator's delegate
extension DataViewDataSource: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return delegate?.numberOfSections() ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return delegate?.numberOfRows(inSection: section) ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    return delegate?.supplementaryView(forElementKind: kind, atIndexPath: indexPath) ?? UICollectionReusableView()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = delegate?.cellForItemAtIndexPath(indexPath) as? UICollectionViewCell else {
      fatalError("Invalid cell type found")
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    return delegate?.canMoveCell(atIndexPath: indexPath) ?? false
  }
  
  func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    delegate?.move(sourceIndexPath, destinationIndexPath)
  }

}
