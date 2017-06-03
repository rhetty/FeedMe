//
//  SubscriptionTableViewCell.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/6/3.
//  Copyright © 2017年 rhett. All rights reserved.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var urlLabel: UILabel!
  @IBOutlet weak var enableSwitch: UISwitch!
  
  var feedInfo: FeedInfo! {
    didSet {
      self.titleLabel.text = feedInfo.title
      self.summaryLabel.text = feedInfo.summary
      self.urlLabel.text = feedInfo.url
      self.enableSwitch.isOn = feedInfo.enable
    }
  }
  
  
  @IBAction func switchChanged(_ sender: UISwitch) {
    self.feedInfo.enable(sender.isOn)
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
