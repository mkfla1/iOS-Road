//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by shuo zhang on 2020/7/23.
//  Copyright © 2020 MKFLA. All rights reserved.
//

import UIKit

// MARK: - Protocols
protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {
  // MARK: - Outlets
  @IBOutlet var textField: UITextField!
  @IBOutlet var doneBarButton: UIBarButtonItem!
  @IBOutlet var shouldRemindSwitch: UISwitch!
  @IBOutlet var dueDateLabel: UILabel!
  @IBOutlet var datePickerCell: UITableViewCell!
  @IBOutlet var datePicker: UIDatePicker!
  
  // MARK: - Properties
  weak var delegate: ItemDetailViewControllerDelegate?
  var itemToEdit: ChecklistItem?
  var dueDate = Date()
  var datePickerVisible = false
  
  // MARK: - Actions
  @IBAction func cancel() {
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    // add new
    if let item = itemToEdit {
      item.text = textField.text!
      item.shouldRemind = shouldRemindSwitch.isOn
      item.dueDate = dueDate
      item.scheduleNotification()
      delegate?.itemDetailViewController(self, didFinishEditing: item)
      return
    }
    
    // edit old
    let item = ChecklistItem(text: textField.text!)
    item.shouldRemind = shouldRemindSwitch.isOn
    item.dueDate = dueDate
    item.scheduleNotification()
    delegate?.itemDetailViewController(self, didFinishAdding: item)
  }
  
  // date picker
  @IBAction func dateChanged(_ datePicker: UIDatePicker) {
    dueDate = datePicker.date
    updateDueDateLabel()
  }
  
  // 通知开关打开时要先获取用户通知许可
  @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
    textField.resignFirstResponder()
    
    guard switchControl.isOn else { return }
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound]) { granted, error in
    }
  }
}

// MARK: - Life Cycle
extension ItemDetailViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    
    if let itemToEdit = itemToEdit {
      title = "Edit Item"
      textField.text = itemToEdit.text
      doneBarButton.isEnabled = true
      shouldRemindSwitch.isOn = itemToEdit.shouldRemind
      dueDate = itemToEdit.dueDate
    }
    updateDueDateLabel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
}

// MARK: - Table view Delegate
extension ItemDetailViewController {
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.section == 1 && indexPath.row == 1 {
      return indexPath
    }
    
    return nil
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    textField.resignFirstResponder()
    
    // show/hide date picker
    if indexPath.section == 1 && indexPath.row == 1 {
      if !datePickerVisible {
        showDatePicker()
      } else {
        hideDatePicker()
      }
    }
  }
}

// MARK: - Text Field Delegate
extension ItemDetailViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText = textField.text!
    let stringRange = Range(range, in: oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    
    doneBarButton.isEnabled = !newText.isEmpty
    return true
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    doneBarButton.isEnabled = false
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    hideDatePicker()
  }
}

// MARK: - Due Date related
extension ItemDetailViewController {
  func updateDueDateLabel() {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    dueDateLabel.text = formatter.string(from: dueDate)
  }
  
  func showDatePicker() {
    datePickerVisible = true
    let indexPathDatePicker = IndexPath(row: 2, section: 1)
    tableView.insertRows(at: [indexPathDatePicker], with: .fade)
    datePicker.setDate(dueDate, animated: false)
    dueDateLabel.textColor = dueDateLabel.tintColor
  }
  
  func hideDatePicker() {
    guard datePickerVisible else { return }
    datePickerVisible = false
    let indexPathDatePicker = IndexPath(row: 2, section: 1)
    tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
    dueDateLabel.textColor = .black
  }
}

// MARK: - Table View Data Source
extension ItemDetailViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 && datePickerVisible {
      return 3
    }
    return super.tableView(tableView, numberOfRowsInSection: section)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 1 && indexPath.row == 2 {
      return datePickerCell
    }
    return super.tableView(tableView, cellForRowAt: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1 && indexPath.row == 2 {
      return 217
    }
    return super.tableView(tableView, heightForRowAt: indexPath)
  }
  
  // cheating the indentation to avoid crash
  override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
    var newIndexPath = indexPath
    if indexPath.section == 1 && indexPath.row == 2 {
      newIndexPath = IndexPath(row: 0, section: indexPath.section)
    }
    return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
  }
}
