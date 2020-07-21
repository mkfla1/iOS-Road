//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by shuo zhang on 2020/7/21.
//  Copyright © 2020 MKFLA. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

}

// MARK: - Table View Data Source
extension ChecklistViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 500
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    
    let label = cell.viewWithTag(1000) as! UILabel
    
    switch indexPath.row % 5 {
    case 0:
      label.text = "Walk the dog"
    case 1:
      label.text = "Brush my teeth"
    case 2:
      label.text = "Learn iOS development"
    case 3:
      label.text = "Soccer practice"
    case 4:
      label.text = "Eat ice cream"
    default:
      label.text = "To Do Something"
    }
    
    return cell
  }
}

// MARK: - Table view Delegate
extension ChecklistViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    cell.accessoryType =
      cell.accessoryType == .none ?
      .checkmark : .none
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
