//
//  FeedInfo+Util.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/6/1.
//  Copyright © 2017年 rhett. All rights reserved.
//

import Foundation
import CoreData
import MWFeedParser

extension FeedInfo {
  
  class func fetch(url: String) -> FeedInfo? {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FeedInfo")
    
    let predicate = NSPredicate(format: "url = %@", url)
    request.predicate = predicate
    
    do {
      let result = try CoreDataManager.context.fetch(request) as! [FeedInfo]
      return result.first
    } catch {
      print(error)
      return nil
    }
  }
  
  class func insert(_ info: MWFeedInfo) -> FeedInfo {
    let feedInfo = NSEntityDescription.insertNewObject(forEntityName: "FeedInfo", into: CoreDataManager.context) as! FeedInfo
    feedInfo.title = info.title
    feedInfo.link = info.link
    feedInfo.url = info.url.absoluteString
    feedInfo.summary = info.summary
    feedInfo.created = NSDate()
    CoreDataManager.app.saveContext()
    return feedInfo
  }
  
  func insert(item: MWFeedItem) -> FeedItem {
    let feedItem = NSEntityDescription.insertNewObject(forEntityName: "FeedItem", into: CoreDataManager.context) as! FeedItem
    feedItem.title = item.title
    feedItem.link = item.link
    feedItem.summary = item.summary
    feedItem.date = item.date as NSDate
    feedItem.created = NSDate()
    feedItem.author = item.author
    feedItem.feedInfo = self
    feedItem.identifier = item.identifier
    feedItem.update = item.updated as NSDate?
    feedItem.content = item.content
    CoreDataManager.app.saveContext()
    return feedItem
  }
  
  func lastItem() -> FeedItem? {
    let result = self.fetch(offset: 0, count: 1)
    return result.first
  }
  
  func fetch(offset: Int, count: Int) -> [FeedItem] {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FeedItem")
    request.fetchLimit = count
    request.fetchOffset = offset
    
    let predicate = NSPredicate(format: "feedInfo = %@", self)
    request.predicate = predicate
    
    let sort = NSSortDescriptor(key: "date", ascending: false)
    request.sortDescriptors = [sort]
    
    do {
      let result = try CoreDataManager.context.fetch(request) as! [FeedItem]
      return result
    } catch {
      print(error)
      return []
    }
  }
  
  func delete() {
    CoreDataManager.context.delete(self)
    CoreDataManager.app.saveContext()
  }
}