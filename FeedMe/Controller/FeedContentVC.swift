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
  var feedItem: MWFeedItem!
  var vcDict: Dictionary<Int, UIViewController> = Dictionary()
  var currentController: UIViewController!
  
  static let controllerIdentifiers = ["FeedSummaryVC", "FeedWebsiteVC"]

    override func viewDidLoad() {
        super.viewDidLoad()

      self.currentController = self.controller(atIndex: 0)
      self.view.addSubview(self.currentController.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func controller(atIndex index: Int) -> UIViewController {
    var controller = self.vcDict[index]
    if controller == nil {
      controller = self.storyboard!.instantiateViewController(withIdentifier: FeedContentVC.controllerIdentifiers[index])
      controller?.setValue(self.feedItem, forKey: "feedItem")
      self.vcDict[index] = controller
      self.addChildViewController(controller!)
    }
    
    return controller!
  }
  
  func transition(toIndex index: Int) {
    let dest = self.controller(atIndex: index)
    self.transition(from: self.currentController, to: dest, duration: 1, options: UIViewAnimationOptions.transitionCrossDissolve, animations: nil) { (finished) in
        if finished {
          self.currentController = dest
        }
    }
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

  @IBAction func browseTypeChanged(_ sender: UISegmentedControl) {
    self.transition(toIndex: sender.selectedSegmentIndex)
  }
  
}
