//
//  FeedSummaryVC.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/5/23.
//  Copyright © 2017年 rhett. All rights reserved.
//

import UIKit
import MWFeedParser

class FeedSummaryVC: BaseViewController, UIWebViewDelegate {
  var feedItem: MWFeedItem!

  @IBOutlet weak var contentWebView: UIWebView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      self.contentWebView.backgroundColor = UIColor.white
    
      self.contentWebView.loadHTMLString(self.feedItem.article, baseURL: nil)
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

  // MARK: - UIWebViewDelegate
  
  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    if navigationType == UIWebViewNavigationType.linkClicked {
      if UIApplication.shared.canOpenURL(request.url!) {
        UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
      }
      return false
    } else {
      return true
    }
  }
}
