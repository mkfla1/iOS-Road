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
  
  @IBOutlet var textField: UITextField!
  @IBOutlet var doneBarButton: UIBarButtonItem!
  
  // MARK: - Properties
  weak var delegate: ItemDetailViewControllerDelegate?
  var itemToEdit: ChecklistItem?
  
  // MARK: - Actions
  @IBAction func cancel() {
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let item = itemToEdit {
      item.text = textField.text!
      delegate?.itemDetailViewController(self, didFinishEditing: item)
      return
    }
    
    let item = ChecklistItem()
    item.text = textField.text!
    delegate?.itemDetailViewController(self, didFinishAdding: item)
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
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
}

// MARK: - Table view Delegate
extension ItemDetailViewController {
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
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
}
