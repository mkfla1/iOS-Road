//
//  Checklist.swift
//  Checklists
//
//  Created by shuo zhang on 2020/8/2.
//  Copyright © 2020 MKFLA. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
  var name = ""
  var items = [ChecklistItem]()
  
  init(name: String) {
    self.name = name
    super.init()
  }
}
