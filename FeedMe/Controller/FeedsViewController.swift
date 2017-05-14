//
//  FeedsViewController.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/5/11.
//  Copyright © 2017年 rhett. All rights reserved.
//

import UIKit
import MWFeedParser

class FeedsViewController: BaseTableViewController, MWFeedParserDelegate {
  private var dataSource: ArrayDataSource! = nil
  private var feedItems: [MWFeedItem] = []
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.dataSource = ArrayDataSource(cellIdentifier: "FeedCell", configureCell: { (cell, item) in
      cell.textLabel?.text = (item as! MWFeedItem).title
    })
    self.tableView.dataSource = self.dataSource
    self.tableView.delegate = self
    
    let rssURL = URL(string: "https://www.zhihu.com/rss")
    let parser = MWFeedParser(feedURL: rssURL)
    parser?.delegate = self
//    parser?.feedParseType = ParseTypeFull
//    parser?.connectionType = ConnectionTypeAsynchronously
    
    parser?.parse()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
// MARK: - MWFeedParserDelegate
  
  func feedParserDidStart(_ parser: MWFeedParser!) {
    
  }
  
  func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
    print(info)
//    print("link:\(info.link) summary:\(info.summary) url:\(info.url)")
  }
  
  func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
    print(item)
    self.feedItems.append(item)
  }
  
  func feedParserDidFinish(_ parser: MWFeedParser!) {
    self.dataSource.items = self.feedItems
    self.tableView.reloadData()
  }
  
  func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
    print(error)
  }
  
}
