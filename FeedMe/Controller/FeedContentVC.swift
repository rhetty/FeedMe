//
//  FeedContentVC.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/5/23.
//  Copyright © 2017年 rhett. All rights reserved.
//

import UIKit
import MWFeedParser

class FeedContentVC: BaseViewController {
  @IBOutlet weak var contentWebView: UIWebView!
  
  var feedItem: MWFeedItem!

    override func viewDidLoad() {
        super.viewDidLoad()

      if let urlStr = self.feedItem.identifier {
        self.contentWebView.loadRequest(URLRequest(url: URL(string: urlStr)!))
      }
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

}
