//
//  MenuViewController.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/6/2.
//  Copyright © 2017年 rhett. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
  
  var delegate: SideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func menuSelected(_ sender: UIButton) {
    self.delegate?.didSelectMenu(at: sender.tag)
  }

}
