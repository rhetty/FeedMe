//
//  AddSubscriptionVC.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/6/3.
//  Copyright © 2017年 rhett. All rights reserved.
//

import UIKit
import MWFeedParser
import Toast_Swift

class AddSubscriptionVC: BaseTableViewController, MWFeedParserDelegate {

  @IBOutlet weak var addressTextField: UITextField!
  
  private var parser: MWFeedParser!
  private var feedInfo: MWFeedInfo!
  
    override func viewDidLoad() {
      super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func done(_ sender: UIBarButtonItem) {
    if let addr = self.addressTextField.text {
      self.validate(addr)
    }
  }
  
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func validate(_ address: String) {
    self.navigationController?.view.fm_showActivityIndicator()

    self.parser = MWFeedParser(feedURL: URL(string: address))
    self.parser.delegate = self
    self.parser.connectionType = ConnectionTypeAsynchronously
    self.parser.feedParseType = ParseTypeInfoOnly
    self.parser.parse()
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
  
  func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
    print(info)
    self.feedInfo = info
  }
  
  func feedParserDidFinish(_ parser: MWFeedParser!) {
    self.navigationController?.view.fm_hideActivityIndicator()
    
    if let saved = FeedInfo.fetch(url: self.feedInfo.url.absoluteString) {
      self.navigationController?.view.fm_showToast("\(NSLocalizedString("Already subscribed", comment: "")) [\(saved.title!)]")
    } else {
      self.view.endEditing(true)
      _ = FeedInfo.insert(self.feedInfo)
      self.navigationController?.view.fm_showToast("\(NSLocalizedString("Subscribe", comment: "")) [\(self.feedInfo.title!)] \(NSLocalizedString("successfully", comment: ""))", duration: 2.0, completion: {
        self.dismiss(animated: true, completion: nil)
      })
    }
  }
  
  func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
    print(error)
    self.navigationController?.view.fm_hideActivityIndicator()
    self.navigationController?.view.fm_showToast(NSLocalizedString("Subscription failed", comment: ""))
  }

}
