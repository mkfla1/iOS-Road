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
  var iconName = "No Icon"
  var items = [ChecklistItem]()
  
  init(name: String, iconName: String = "No Icon") {
    self.name = name
    self.iconName = iconName
    super.init()
  }
  
  // MARK: - Utilities
  func countUncheckedItems() -> Int {
    return items.reduce(0) { $0 + ($1.checked ? 0 : 1) }
  }
}
