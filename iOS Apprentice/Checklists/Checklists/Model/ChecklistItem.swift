//
//  ChecklistItem.swift
//  Checklists
//
//  Created by shuo zhang on 2020/7/22.
//  Copyright © 2020 MKFLA. All rights reserved.
//
import Foundation

class ChecklistItem: NSObject, Codable {
  var text = ""
  var checked = false
  
  func toggleChecked() {
    checked.toggle()
  }
}
