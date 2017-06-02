//
//  FMSideMenuController.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/6/2.
//  Copyright © 2017年 rhett. All rights reserved.
//

import UIKit
import RESideMenu

protocol SideMenuDelegate {
  func didSelectMenu(at index: Int)
}

class FMSideMenuController: RESideMenu, SideMenuDelegate {
  
  static var controllerIDs = ["", "Content", "Subscription"]
  var controllerDict: [Int: UIViewController] = [:]

  override func awakeFromNib() {
    let menu = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
    menu.delegate = self
    self.leftMenuViewController = menu
    
    self.contentViewController = self.controller(at: 1)
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  func controller(at index: Int) -> UIViewController {
    var controller = self.controllerDict[index]
    if controller == nil {
      controller = self.storyboard?.instantiateViewController(withIdentifier: FMSideMenuController.controllerIDs[index])
      self.controllerDict[index] = controller
      
      if controller is UINavigationController {
        let menuItem = UIBarButtonItem(title: NSLocalizedString("Menu", comment: ""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuPressed))
        (controller as! UINavigationController).topViewController?.navigationItem.leftBarButtonItem = menuItem
      }
    }
    return controller!
  }
  
  func menuPressed() {
    self.presentLeftMenuViewController()
  }
  
// MARK: - SideMenuDelegate
  
  func didSelectMenu(at index: Int) {
    self.setContentViewController(self.controller(at: index), animated: true)
    self.hideViewController()
  }
  
}
