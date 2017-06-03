//
//  FeedItem+Util.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/6/1.
//  Copyright © 2017年 rhett. All rights reserved.
//

import Foundation
import CoreData
import MWFeedParser

extension FeedItem {
  
  var fetchedAllController: NSFetchedResultsController<FeedItem> {
    let request = NSFetchRequest<FeedItem>(entityName: "FeedItem")
    let sort = NSSortDescriptor(key: "date", ascending: false)
    request.sortDescriptors = [sort]
    request.fetchBatchSize = 20
    
    return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
  }
  
  class func fetch(offset: Int, count: Int) -> [FeedItem] {
    let request = NSFetchRequest<FeedItem>(entityName: "FeedItem")
    request.fetchLimit = count
    request.fetchOffset = offset
    
    let sort = NSSortDescriptor(key: "date", ascending: false)
    request.sortDescriptors = [sort]
    
    do {
      let result = try CoreDataManager.context.fetch(request)
      return result
    } catch {
      print(error)
      return []
    }
  }
  
  static var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.full
    formatter.timeStyle = DateFormatter.Style.none
    return formatter
  }
  
  var article: String {
    var arti = "<h2 style=\"text-align:center\">\(self.title ?? "")</h2><p style=\"font-size:small;color:#BBBBBB;text-align:center\"><span>\(FeedItem.dateFormatter.string(from: self.date! as Date))</span> via <span>\(self.author ?? (self.feedInfo?.title)!)</span></p>"
    
    arti.append("<style>img{width:100% !important;}</style>")
    arti.append(self.summary!)
    
    return arti
  }
}
