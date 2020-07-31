//
//  ChecklistItem.swift
//  Checklists
//
//  Created by shuo zhang on 2020/7/22.
//  Copyright © 2020 MKFLA. All rights reserved.
//

class ChecklistItem {
  var text = ""
  var checked = false
  
  func toggleChecked() {
    checked.toggle()
  }
}
