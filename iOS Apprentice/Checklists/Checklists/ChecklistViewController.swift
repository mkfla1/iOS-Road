//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by shuo zhang on 2020/7/21.
//  Copyright © 2020 MKFLA. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
  var items = [ChecklistItem]()
  
  // MARK: - Actions
  @IBAction func addItem() {
    let newRowIndex = items.count

    let item = ChecklistItem()
    item.text = "I am a new row"
    items.append(item)

    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
  }
}

// MARK: - LifeCycle
extension ChecklistViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.prefersLargeTitles = true
    
    let item1 = ChecklistItem()
    item1.text = "Walk the dog"
    items.append(item1)
    
    let item2 = ChecklistItem()
    item2.text = "Brush my teeth"
    item2.checked = true
    items.append(item2)
    
    let item3 = ChecklistItem()
    item3.text = "Learn iOS development"
    item3.checked = true
    items.append(item3)
    
    let item4 = ChecklistItem()
    item4.text = "Soccer practice"
    items.append(item4)
    
    let item5 = ChecklistItem()
    item5.text = "Eat ice cream"
    items.append(item5)
  }
}

// MARK: - Table View Data Source
extension ChecklistViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    let item = items[indexPath.row]
    
    configureText(for: cell, with: item)
    configureCheckmark(for: cell, with: item)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    items.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
}

// MARK: - Table view Delegate
extension ChecklistViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    let item = items[indexPath.row]
    
    item.toggleChecked()
    configureCheckmark(for: cell, with: item)

    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - Utilities
extension ChecklistViewController {
  private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
    cell.accessoryType = item.checked ? .checkmark : .none
  }
  
  private func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
  }
}
