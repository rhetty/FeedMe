//
//  ArrayDataSource.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/5/14.
//  Copyright © 2017年 rhett. All rights reserved.
//

import UIKit
import CoreData

class ArrayDataSource<Element: AnyObject>: NSObject, UITableViewDataSource {
  var items: [Element]?
  
  private var cellIdentifier: String
  private var configureCell: (UITableViewCell, Element) -> Void
  
  init(cellIdentifier: String, configureCell: @escaping (UITableViewCell, Element) -> Void) {
    self.cellIdentifier = cellIdentifier
    self.configureCell = configureCell
    
    super.init()
  }
  
  func item(at indexPath: IndexPath) -> Element? {
    return items?[indexPath.row]
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.items != nil {
      return self.items!.count
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
    let item = self.item(at: indexPath)
    self.configureCell(cell, item!)
    return cell
  }
}
