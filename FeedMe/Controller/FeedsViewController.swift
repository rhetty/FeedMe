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
  private var feedItems: [FeedItem] = []
  private var parser: MWFeedParser?
  private var feedInfo: FeedInfo?
  private var lastItemDate: NSDate?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // configure tableview
    self.dataSource = ArrayDataSource(cellIdentifier: "FeedCell", configureCell: { (cell, item) in
      cell.textLabel?.text = (item as! FeedItem).title
    })
    self.tableView.dataSource = self.dataSource
    self.tableView.delegate = self
    
    // display feeds
    self.feedInfo = FeedInfo.fetch(url: "https://www.zhihu.com/rss")
    self.displayFeeds()
    
    // configure parser
    let rssURL = URL(string: "https://www.zhihu.com/rss")
    parser = MWFeedParser(feedURL: rssURL)
    parser?.delegate = self
    parser?.feedParseType = ParseTypeFull
    parser?.connectionType = ConnectionTypeAsynchronously

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func refresh(_ sender: UIRefreshControl) {
    parser?.parse()
  }
  
  private func displayFeeds() {
    self.dataSource.items = self.feedInfo?.fetch(offset: 0, count: 20)
    self.tableView.reloadData()
  }
  
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "ShowContent" {
       let dest = segue.destination as! FeedContentVC
       dest.feedItem = sender as! FeedItem
     }
   }
  
  // MARK: - UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = self.dataSource.item(at: indexPath)
    self.performSegue(withIdentifier: "ShowContent", sender: item)
  }
  
  // MARK: - MWFeedParserDelegate
  
  func feedParserDidStart(_ parser: MWFeedParser!) {
    
  }
  
  func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
    print(info)
    let savedInfo = FeedInfo.fetch(url: info.url.absoluteString)
    self.feedInfo = savedInfo ?? FeedInfo.insert(info)
    self.lastItemDate = self.feedInfo?.lastItem()?.date

//    print("link:\(info.link) summary:\(info.summary) url:\(info.url)")
  }
  
  func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
    if self.lastItemDate == nil || item.date.compare(self.lastItemDate! as Date) == ComparisonResult.orderedDescending {
      _ = self.feedInfo?.insert(item: item)
    } else {
      self.parser?.stopParsing()
    }
//    print(item)
//    self.feedInfo?.insert(item: item)
//    print(item.identifier)
//    print(item.updated)
//    print(item.summary)
//    print(item.content)
//    print(item.author)
//    print(item.enclosures)
//    print();
//    self.feedItems.append(item)
  }
  
  func feedParserDidFinish(_ parser: MWFeedParser!) {
    self.displayFeeds()
    self.refreshControl?.endRefreshing()

    print(self.dataSource.items?.count ?? 0)
    print(self.feedInfo?.items?.count ?? 0)
  }
  
  func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
    self.refreshControl?.endRefreshing()
    print(error)
  }
  
}
