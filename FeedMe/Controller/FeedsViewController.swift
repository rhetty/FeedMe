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
  private var parser: MWFeedParser?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // configure tableview
    self.dataSource = ArrayDataSource(cellIdentifier: "FeedCell", configureCell: { (cell, item) in
      cell.textLabel?.text = (item as! MWFeedItem).title
    })
    self.tableView.dataSource = self.dataSource
    self.tableView.delegate = self
    
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
  
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "ShowContent" {
       let dest = segue.destination as! FeedContentVC
       dest.feedItem = sender as! MWFeedItem
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
//    print("link:\(info.link) summary:\(info.summary) url:\(info.url)")
  }
  
  func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
    print(item)
    
//    print(item.identifier)
//    print(item.updated)
    print(item.summary)
//    print(item.content)
//    print(item.author)
//    print(item.enclosures)
//    print();
    self.feedItems.append(item)
  }
  
  func feedParserDidFinish(_ parser: MWFeedParser!) {
    self.dataSource.items = self.feedItems
    self.tableView.reloadData()
    self.refreshControl?.endRefreshing()
  }
  
  func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
    self.refreshControl?.endRefreshing()
    print(error)
  }
  
}
