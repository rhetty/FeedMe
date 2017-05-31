//
//  FeedWebView.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/5/31.
//  Copyright © 2017年 rhett. All rights reserved.
//

import UIKit
import Kingfisher

class FeedWebView: UIWebView, UIWebViewDelegate {

  static let imageForwardPrefix = "myweb:imageClick:"
  static let animationInterval = 0.3
  
  var bgView: UIScrollView = UIScrollView()
  var imgView: UIImageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.initialize()
  }
  
  private func initialize() {
    self.delegate = self
    
    self.bgView.frame = UIScreen.main.bounds
    self.bgView.backgroundColor = UIColor.black
    self.bgView.alpha = 0
    self.bgView.delegate = self
    self.bgView.maximumZoomScale = 2.0
    self.bgView.minimumZoomScale = 1.0
    
    self.imgView.frame = self.bgView.bounds
    self.imgView.contentMode = UIViewContentMode.scaleAspectFit
    self.bgView.addSubview(self.imgView)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(bgViewTapped))
    self.bgView.addGestureRecognizer(tap)
  }
  
  @objc private func bgViewTapped() {
    UIView.animate(withDuration: FeedWebView.animationInterval, animations: { 
      self.bgView.alpha = 0
    }) { (finished) in
      self.bgView.removeFromSuperview()
      self.bgView.zoomScale = 1.0
    }
  }
  
  private func displayBigImage(imageURLString: String) {
    self.imgView.kf.setImage(with: URL(string: imageURLString))
    UIApplication.shared.keyWindow?.addSubview(self.bgView)
    
    UIView.animate(withDuration: FeedWebView.animationInterval) {
      self.bgView.alpha = 1
    }
  }
  
  // MARK: - UIWebViewDelegate
  
  func webViewDidFinishLoad(_ webView: UIWebView) {
    let jsGetImages = "function getImages(){var objs = document.getElementsByTagName(\"img\");for(var i = 0; i < objs.length; i++){objs[i].onclick = function(){document.location = \"\(FeedWebView.imageForwardPrefix)\" + this.src;};};return objs.length;}"
    webView.stringByEvaluatingJavaScript(from: jsGetImages)
    webView.stringByEvaluatingJavaScript(from: "getImages()")
  }
  
  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    let requestString = request.url!.absoluteString
    
    if requestString.hasPrefix(FeedWebView.imageForwardPrefix) {
      let imageURL = requestString.substring(from: requestString.index(requestString.startIndex, offsetBy: FeedWebView.imageForwardPrefix.characters.count))
      
      displayBigImage(imageURLString: imageURL)
      
      return false
    } else {
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
  
  // MARK: - UIScrollViewDelegate
  
  override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return scrollView == self.bgView ? self.imgView : super.viewForZooming(in: scrollView)
  }
}
