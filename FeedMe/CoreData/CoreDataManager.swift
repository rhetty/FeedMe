//
//  CoreDataManager.swift
//  FeedMe
//
//  Created by 黄嘉伟 on 2017/6/1.
//  Copyright © 2017年 rhett. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
  static var app: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
  
  static var context: NSManagedObjectContext {
    return CoreDataManager.app.persistentContainer.viewContext
  }
}
