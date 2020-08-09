//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by shuo zhang on 2020/8/5.
//  Copyright © 2020 MKFLA. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
  func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
  let icons = [ "No Icon", "Appointments", "Birthdays", "Chores",
                "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips" ]
  weak var delegate: IconPickerViewControllerDelegate?
}

// MARK: - Table View Data Source
extension IconPickerViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return icons.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
    let iconName = icons[indexPath.row]
    cell.textLabel?.text = iconName
    cell.imageView?.image = UIImage(named: iconName)
    return cell
  }
}

// MARK: - Table view Delegate
extension IconPickerViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let iconName = icons[indexPath.row]
    delegate?.iconPicker(self, didPick: iconName)
  }
}
