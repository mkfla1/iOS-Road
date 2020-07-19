//
//  AboutViewController.swift
//  BullsEye
//
//  Created by shuo zhang on 2020/7/19.
//  Copyright © 2020 MKFLA. All rights reserved.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {
  @IBOutlet var webView: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let url = Bundle.main.url(forResource: "Bullseye", withExtension: "html") {
      let request = URLRequest(url: url)
      webView.load(request)
    }
  }
  
  @IBAction func close() {
    dismiss(animated: true, completion: nil)
  }
}
