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

enum FilterType: Int{
  case All = 0
  case Unread
  case Starred
}

extension FeedItem {
  
  var fetchedAllController: NSFetchedResultsController<FeedItem> {
    let request = NSFetchRequest<FeedItem>(entityName: "FeedItem")
    let sort = NSSortDescriptor(key: "date", ascending: false)
    request.sortDescriptors = [sort]
    request.fetchBatchSize = 20
    
    return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
  }
  
  class func fetch(offset: Int, count: Int, filter: FilterType) -> [FeedItem] {
    let request = NSFetchRequest<FeedItem>(entityName: "FeedItem")
    request.fetchLimit = count
    request.fetchOffset = offset
    
    let sort = NSSortDescriptor(key: "date", ascending: false)
    request.sortDescriptors = [sort]
    
    if filter != .All {
      let predicate = NSPredicate(format: filter == .Unread ? "read = false" : "starred = true")
      request.predicate = predicate
    }
    
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
    formatter.timeStyle = DateFormatter.Style.short
    return formatter
  }
  
  var monthWeekDay: String {
    return FeedItem.dateFormatter.string(from: self.date! as Date)
  }
  
  var timeIntervalString: String {
    let timeInterval = Date().timeIntervalSince(self.date! as Date)
    
    let mins = Int(timeInterval) / 60
    if mins <= 1 {
      return NSLocalizedString("Just now", comment: "")
    } else if mins < 60 {
      return "\(mins) \(NSLocalizedString("minutes", comment: ""))\(NSLocalizedString(" ago", comment: ""))"
    }
    
    let hours = mins / 60
    if hours == 1 {
      return "\(hours) \(NSLocalizedString("hour", comment: ""))\(NSLocalizedString(" ago", comment: ""))"
    } else if hours < 24 {
      return "\(hours) \(NSLocalizedString("hours", comment: ""))\(NSLocalizedString(" ago", comment: ""))"
    }
    
    let days = hours / 24
    if days == 1 {
      return "\(days) \(NSLocalizedString("day", comment: ""))\(NSLocalizedString(" ago", comment: ""))"
    } else if days < 30 {
      return "\(days) \(NSLocalizedString("days", comment: ""))\(NSLocalizedString(" ago", comment: ""))"
    }
    
    let months = days / 30
    if months == 1 {
      return "\(months) \(NSLocalizedString("month", comment: ""))\(NSLocalizedString(" ago", comment: ""))"
    } else if months < 12 {
      return "\(months) \(NSLocalizedString("months", comment: ""))\(NSLocalizedString(" ago", comment: ""))"
    }
    
    let years = months / 12
    if years == 1 {
      return "\(years) \(NSLocalizedString("year", comment: ""))\(NSLocalizedString(" ago", comment: ""))"
    }
    return "\(years) \(NSLocalizedString("years", comment: ""))\(NSLocalizedString(" ago", comment: ""))"
  }
  
  var article: String {
    var arti = "<h2 style=\"text-align:center\">\(self.title ?? "")</h2><p style=\"font-size:small;color:#BBBBBB;text-align:center\"><span>\(self.monthWeekDay)</span> via <span>\(self.author ?? (self.feedInfo?.title)!)</span></p>"
    
    arti.append("<style>img{width:100% !important;}</style>")
    arti.append(self.summary!)
    
    return arti
  }
  
  func star(_ s: Bool) {
    self.starred = s
    do {
      try CoreDataManager.context.save()
    } catch {
      print(error)
    }
  }
  
  func read(_ r: Bool) {
    self.read = r
    do {
      try CoreDataManager.context.save()
    } catch {
      print(error)
    }
  }
}
