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
    
    private lazy var model = CalculatorModel(delegate: self)
    
    @IBAction func allClearTap(_ sender: UIButton) {
        model.resetCurrentOperation()
        resetTextView()
    }
    var userIsInMiddelOfTyping = false
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else { return }
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
    model.calculate()
        
    }
}

// MARK: - CalculatorDelegate

extension CalculatorController: CalculatorDelegate {
    
    func clearAll() {
        textView.text = " "
    }
    
    
    func showAlertController(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func deleteZero() {
        if textView.text.first == "0" {
            clearAll()
        }
    }
    
    func resetTextView() {
        textView.text = "0"
    }
    
    func addText(text: String) {
        textView.text.append(text)
    }
}
