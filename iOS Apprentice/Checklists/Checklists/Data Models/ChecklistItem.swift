//
//  ChecklistItem.swift
//  Checklists
//
//  Created by shuo zhang on 2020/7/22.
//  Copyright © 2020 MKFLA. All rights reserved.
//
import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
  var text = ""
  var checked = false
  var dueDate = Date()
  var shouldRemind = false
  var itemID = -1
  
  init(text: String, checked: Bool = false) {
    self.text = text
    self.checked = checked
    itemID = DataModel.nextChecklistItemID()
    super.init()
  }
  
  deinit {
    removeNotification()
  }
  
  func toggleChecked() {
    checked.toggle()
  }
}

// MARK: - User Nofitification
extension ChecklistItem {
  func scheduleNotification() {
    removeNotification()
    guard shouldRemind && dueDate > Date() else { return }
    
    // 1 配置通知内容
    let content = UNMutableNotificationContent()
    content.title = "Reminder:"
    content.body = text
    content.sound = .default
    
    // 2 选定通知日期及时间
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents(
      [.year, .month, .day, .hour, .minute],
      from: dueDate)
    
    // 3 按照日期来触发
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    
    // 4 创建request
    let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
    
    // 5 添加request
    let center = UNUserNotificationCenter.current()
    center.add(request)
  }
  
  func removeNotification() {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
  }
}
