//
//  ViewController.swift
//  BullsEye
//
//  Created by shuo zhang on 2020/7/16.
//  Copyright © 2020 MKFLA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var slider: UISlider!
  @IBOutlet var targetLabel: UILabel!
  @IBOutlet var scoreLabel: UILabel!
  @IBOutlet var roundLabel: UILabel!
  
  var currentValue = 0
  var targetValue = 0
  var score = 0
  var round = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setSliderUI()
    startNewGame()
  }
  
  @IBAction func showAlert() {
    let difference = abs(targetValue - currentValue)
    var points = 100 - difference
    
    let title: String
    switch difference {
    case 0:
      title = "Perfect"
      points += 100
    case ..<5:
      title = "You almost had it!"
      if difference == 1 {
        points += 50
      }
    case ..<10:
      title = "Pretty good!"
    default:
      title = "Not even close..."
    }
    score += points
    
    let message = "You scored \(points) points"
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    let action = UIAlertAction(title: "ok",
                               style: .default) { _ in
                                self.startNewRound()
    }
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func sliderMoved(_ slider: UISlider) {
    currentValue = Int(slider.value.rounded())
  }
  
  @IBAction func startOver() {
    startNewGame()
  }
}

// MARK: - Utilities
extension ViewController {
  private func startNewRound() {
    targetValue = Int.random(in: 1...100)
    currentValue = 50
    slider.value = Float(currentValue)
    round += 1
    updateLabels()
  }
  
  private func updateLabels() {
    targetLabel.text = "\(targetValue)"
    scoreLabel.text = "\(score)"
    roundLabel.text = "\(round)"
  }
  
  private func startNewGame() {
    score = 0
    round = 0
    startNewRound()
    
    let transition = CATransition()
    transition.type = .fade
    transition.duration = 1
    transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
    view.layer.add(transition, forKey: nil)
  }
  
  private func setSliderUI() {
    let thumbImageNormal = UIImage(named: "SliderThumb-Normal")!
    slider.setThumbImage(thumbImageNormal, for: .normal)
    
    let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")
    slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
    
    let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    
    let trackLeftImage = UIImage(named: "SliderTrackLeft")
    let trackLeftResizable = trackLeftImage?.resizableImage(withCapInsets: insets)
    slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
    
    let trackRightImage = UIImage(named: "SliderTrackRight")
    let trackRightResizable = trackRightImage?.resizableImage(withCapInsets: insets)
    slider.setMaximumTrackImage(trackRightResizable, for: .normal)
  }
}
