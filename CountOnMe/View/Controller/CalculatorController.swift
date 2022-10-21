//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class CalculatorController: UIViewController {
   
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    @IBOutlet var operationButtons: [UIButton]!
    
    @IBOutlet weak var dotButton: UIButton!
    
    private lazy var model = CalculatorModel(delegate: self)
    
    // View actions
    
    @IBAction func decimalTap(_ sender: UIButton) {
        model.add(symbol: .dot)
    }
    
    @IBAction func allClearTap(_ sender: UIButton) {
        model.resetText()
    }
    var userIsInMiddelOfTyping = false
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        model.add(number: numberText)
    }
    
    @IBAction func timesTap(_ sender: UIButton) {
        model.add(symbol: .multiplication)
    }
    
    @IBAction func divideTap(_ sender: UIButton) {
        model.add(symbol: .divide)
    }
    
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        model.add(symbol: .add)
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        model.add(symbol: .substraction)
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        self.resetTextView()
        model.calculate()
    }
}

// MARK: - CalculatorDelegate

extension CalculatorController: CalculatorDelegate {
    
    func showAlertController(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func deleteZero() {
        if textView.text.first == "0" {
            resetTextView()
        }
    }
    
    func resetTextView() {
        textView.text = ""
    }

    func addText(text: String) {
        textView.text.append(text)
    }
}
