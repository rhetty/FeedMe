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
  static var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.full
    formatter.timeStyle = DateFormatter.Style.none
    return formatter
  }
  
  var article: String {
    var arti = "<h2 style=\"text-align:center\">\(self.title!)</h2><p style=\"font-size:small;color:#BBBBBB;text-align:center\"><span>\(FeedItem.dateFormatter.string(from: self.date! as Date))</span> via <span>\(self.author!)</span></p>"
    
    arti.append("<style>img{width:100% !important;}</style>")
    arti.append(self.summary!)
    
    return arti
  }
}
