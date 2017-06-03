//
//  FeedTableViewCell.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/6/3.
//  Copyright © 2017年 rhett. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

  @IBOutlet weak var coverImgView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  var feedItem: FeedItem! {
    didSet {
      self.titleLabel.text = feedItem.title
      self.infoLabel.text = feedItem.feedInfo?.title
      self.timeLabel.text = feedItem.timeIntervalString
    }
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
