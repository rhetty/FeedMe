//
//  UIView+Toast.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/6/3.
//  Copyright © 2017年 rhett. All rights reserved.
//

import UIKit
import Toast_Swift

extension UIView {
  func fm_showActivityIndicator() {
    self.makeToastActivity(.center)
  }
  
  func fm_hideActivityIndicator() {
    self.hideToastActivity()
  }
  
  func fm_showToast(_ message: String) {
    self.makeToast(message, duration: 1.0, position: .center)
  }
  
  func fm_showToast(_ message: String, duration: Double, completion: @escaping () -> Void) {
    self.makeToast(message, duration: duration, position: .center, title: nil, image: nil, style: nil) { (didTap) in
      completion()
    }
  }
}
