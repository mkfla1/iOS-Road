//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by shuo zhang on 2020/7/21.
//  Copyright © 2020 MKFLA. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
  // MARK: - Properties
  var items = [ChecklistItem]()
  var checklist: Checklist!
}

// MARK: - LifeCycle
extension ChecklistViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .never
    loadChecklistItems()
    title = checklist.name
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
    saveChecklistItems()
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
    saveChecklistItems()
  }
}

// MARK: - Utilities
extension ChecklistViewController {
  private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
    let label = cell.viewWithTag(1001) as! UILabel
    
    label.text = item.checked ? "🍗" : ""
  }
  
  private func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
  }
  
  // MARK: - Persistence
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Checklists.plist")
  }
  
  func saveChecklistItems() {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(items)
      try data.write(to: dataFilePath(), options: .atomic)
    } catch {
      print("Error encoding item array: \(error.localizedDescription)")
    }
  }
  
  func loadChecklistItems() {
    let path = dataFilePath()
    let decoder = PropertyListDecoder()
    
    do {
      let data = try Data(contentsOf: path)
      items = try decoder.decode([ChecklistItem].self, from: data)
    } catch {
      print("Error decoding item array: \(error.localizedDescription)")
    }
  }
  
}

// MARK: - Navigation
extension ChecklistViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItem" {
      let controller = segue.destination as! ItemDetailViewController
      controller.delegate = self
    } else if segue.identifier == "EditItem" {
      let controller = segue.destination as! ItemDetailViewController
      controller.delegate = self
      
      guard let indexPath = tableView.indexPath(for: sender as! UITableViewCell) else { return }
      controller.itemToEdit = items[indexPath.row]
    }
    
    
  }
}

// MARK: - Add Item View Controller Delegate
extension ChecklistViewController: ItemDetailViewControllerDelegate {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
    let newRowIndex = items.count
    items.append(item)
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
    navigationController?.popViewController(animated: true)
    saveChecklistItems()
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
    defer {
      navigationController?.popViewController(animated: true)
    }
    
    guard let index = items.firstIndex(of: item) else { return }
    let indexPath = IndexPath(row: index, section: 0)
    if let cell = tableView.cellForRow(at: indexPath) {
      configureText(for: cell, with: item)
    }
    saveChecklistItems()
  }
}
