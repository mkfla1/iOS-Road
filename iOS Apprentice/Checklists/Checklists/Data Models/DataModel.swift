//
//  DataModel.swift
//  Checklists
//
//  Created by shuo zhang on 2020/8/3.
//  Copyright © 2020 MKFLA. All rights reserved.
//

import Foundation

class DataModel {
  var lists = [Checklist]()
  
  init() {
    loadChecklists()
    registerDefaults()
    handleFirstTime()
  }
}

// MARK: - Checklist Persistance
extension DataModel {
  var documentsDirectory: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  var dataFilePath: URL {
    return documentsDirectory.appendingPathComponent("Checklists.plist")
  }
  
  func saveChecklists() {
    let encoder = PropertyListEncoder()
    
    do {
      let tasksData = try encoder.encode(lists)
      try tasksData.write(to: dataFilePath, options: .atomic)
    } catch {
      print("Error encoding list array: \(error.localizedDescription)")
    }
  }
  
  func loadChecklists() {
    let decoder = PropertyListDecoder()
    
    do {
      let data = try Data(contentsOf: dataFilePath)
      lists = try decoder.decode([Checklist].self, from: data)
      sortChecklists()
    } catch {
      print("Error decoding list array: \(error.localizedDescription)")
    }
  }
}

// MARK: - Sort Checklist
extension DataModel {
  func sortChecklists() {
    lists.sort { (list1, list2) -> Bool in
      return list1.name.localizedCompare(list2.name) == .orderedAscending
    }
  }
}

// MARK: - UserDefaults
extension DataModel {
  var indexOfSelectedChecklist: Int {
    get {
      return UserDefaults.standard.integer(forKey: "ChecklistIndex")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
    }
  }
  
  func registerDefaults() {
    let dictionary = ["ChecklistIndex": -1, "FirstTime": true] as [String : Any]
    UserDefaults.standard.register(defaults: dictionary)
  }
  
  //首次使用app
  func handleFirstTime() {
    let userDefaults = UserDefaults.standard
    let firstTime = userDefaults.bool(forKey: "FirstTime")
    
    guard firstTime else { return }
    let checklist = Checklist(name: "List")
    lists.append(checklist)
    
    indexOfSelectedChecklist = 0
    userDefaults.set(false, forKey: "FirstTime")
    userDefaults.synchronize()
  }
}

// MARK: - Checklist Item Utilities
extension DataModel {
  class func nextChecklistItemID() -> Int {
    let userDefaults = UserDefaults.standard
    let itemID = userDefaults.integer(forKey: "ChecklistItemID")
    userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
    userDefaults.synchronize()
    return itemID
  }
}
