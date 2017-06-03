//
//  FeedsViewController.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/5/11.
//  Copyright © 2017年 rhett. All rights reserved.
//

import UIKit
import MWFeedParser
import CoreData

class FeedsViewController: BaseTableViewController, MWFeedParserDelegate, JWComboBoxDataSource, JWComboBoxDelegate {
  private var dataSource: ArrayDataSource<FeedItem>! = nil
  private var parser: MWFeedParser!
  private var selectedInfo: FeedInfo?
  private var lastItemDate: NSDate?
  private var parsingInfo: FeedInfo?
  private var subscriptionFetch: NSFetchedResultsController<FeedInfo>!
  private var subscriptionComboBox: JWComboBox = JWComboBox(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
  private var hasMore = true
  
  static let feedBatchSize = 20
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // configure tableview
    self.dataSource = ArrayDataSource(cellIdentifier: "FeedCell", configureCell: { (cell, item) in
      (cell as! FeedTableViewCell).feedItem = item
    })
    self.tableView.dataSource = self.dataSource
    self.tableView.tableFooterView = UIView()

    // fetched results controller
    self.subscriptionFetch = FeedInfo.fetchedEnableController
    
    // subscription combobox
    self.navigationItem.titleView = self.subscriptionComboBox
    self.subscriptionComboBox.dataSource = self
    self.subscriptionComboBox.delegate = self
    
    
    self.displayFeeds()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    do {
      try self.subscriptionFetch.performFetch()
    } catch {
      print(error)
    }
    self.subscriptionComboBox.reloadData()
    self.tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func refresh(_ sender: UIRefreshControl) {
    if let info = self.selectedInfo {
      self.parser = MWFeedParser(feedURL: URL(string: (info.url)!))
      self.parser.connectionType = ConnectionTypeAsynchronously
      self.parser.feedParseType = ParseTypeFull
      self.parser.delegate = self
      self.parser.parse()
    } else {
      DispatchQueue.global().async {
        for subscription in self.subscriptionFetch.fetchedObjects! {
          self.parser = MWFeedParser(feedURL: URL(string: (subscription.url)!))
          self.parser.connectionType = ConnectionTypeSynchronously
          self.parser.feedParseType = ParseTypeFull
          self.parser.delegate = self
          self.parser.parse()
        }
        self.displayFeeds()
        self.refreshControl?.endRefreshing()
      }
    }
  }
  
  private func displayFeeds() {
    if self.selectedInfo == nil {
      self.dataSource.items = FeedItem.fetch(offset: 0, count: FeedsViewController.feedBatchSize)
    } else {
      self.dataSource.items = self.selectedInfo!.fetch(offset: 0, count: FeedsViewController.feedBatchSize)
    }
    self.tableView.reloadData()
    self.hasMore = true
    self.tableView.setContentOffset(CGPoint.zero, animated: false)
  }
  
  private func loadMoreFeeds() {
    var newData: [FeedItem]!
    
    if self.selectedInfo == nil {
      newData = FeedItem.fetch(offset: self.dataSource.items?.count ?? 0, count: FeedsViewController.feedBatchSize)
    } else {
      newData = self.selectedInfo!.fetch(offset: self.dataSource.items?.count ?? 0, count: FeedsViewController.feedBatchSize)
    }
    if newData.count < FeedsViewController.feedBatchSize {
      hasMore = false
    }
    self.dataSource.items! += newData
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
    self.parsingInfo = nil
  }
  
  func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
    print(info)
    let savedInfo = FeedInfo.fetch(url: info.url.absoluteString)
    if savedInfo != nil {
      self.parsingInfo = savedInfo
      self.lastItemDate = self.parsingInfo?.lastItem()?.date
    } else {
      self.parser.stopParsing()
    }

//    print("link:\(info.link) summary:\(info.summary) url:\(info.url)")
  }
  
  func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
    print(item.summary)
    if self.lastItemDate == nil || item.date.compare(self.lastItemDate! as Date) == ComparisonResult.orderedDescending {
      _ = self.parsingInfo?.insert(item: item)
    } else {
      self.parser?.stopParsing()
    }

  }
  
  func feedParserDidFinish(_ parser: MWFeedParser!) {
    if self.selectedInfo != nil {
      self.displayFeeds()
      self.refreshControl?.endRefreshing()
    }
    print(self.dataSource.items?.count ?? 0)
    print(self.selectedInfo?.items?.count ?? 0)
  }
  
  func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
    if self.selectedInfo != nil {
      self.refreshControl?.endRefreshing()
    }
    
    print(error)
  }
  
  // MARK: - ComboBoxDataSource
  
  func numberOfOptions(in comboBox: JWComboBox!) -> UInt {
    return UInt(self.subscriptionFetch.sections?.first?.numberOfObjects ?? 0) + 1
  }
  
  func comboBox(_ comboBox: JWComboBox!, contentAt index: UInt) -> String! {
    if index == 0 {
      return NSLocalizedString("All", comment: "")
    } else {
      let info = self.subscriptionFetch.object(at: IndexPath(row: Int(index - 1), section: 0)) 
      return info.title!
    }
  }
  
  // MARK: - ComboBoxDelegate
  
  func comboBox(_ comboBox: JWComboBox!, didSelectAt index: UInt) {
    if index == 0 {
      self.selectedInfo = nil
    } else {
      self.selectedInfo = (self.subscriptionFetch.object(at: IndexPath(row: Int(index - 1), section: 0)) )
    }
    self.displayFeeds()
  }
  
  // MARK: - UIScrollViewDelegate

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if hasMore && scrollView.contentOffset.y + 64 > scrollView.contentSize.height - UIScreen.main.bounds.height * 1.5  {
      self.loadMoreFeeds()
    }
  }
  
}
