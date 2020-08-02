//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by shuo zhang on 2020/8/2.
//  Copyright © 2020 MKFLA. All rights reserved.
//

import UIKit

// MARK: - Protocols
protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
  func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
  func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController {
  // MARK: - Outlets
  @IBOutlet var textField: UITextField!
  @IBOutlet var doneBarButton: UIBarButtonItem!
  
  // MARK: - Properties
  weak var delegate: ListDetailViewControllerDelegate?
  var checklistToEdit: Checklist?
  
  // MARK: - Actions
  @IBAction func cancel() {
    delegate?.listDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let checklistToEdit = checklistToEdit {
      checklistToEdit.name = textField.text!
      delegate?.listDetailViewController(self, didFinishEditing: checklistToEdit)
    } else {
      let checklist = Checklist(name: textField.text!)
      delegate?.listDetailViewController(self, didFinishAdding: checklist)
    }
  }
}

// MARK: - Life Cycle
extension ListDetailViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let checklistToEdit = checklistToEdit {
      title = "Edit Checklist"
      textField.text = checklistToEdit.name
      doneBarButton.isEnabled = true
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
}

// MARK: - Table View Delegate
extension ListDetailViewController {
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}

// MARK: - Text Field Delegate
extension ListDetailViewController: UITextFieldDelegate {
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
