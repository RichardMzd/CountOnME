//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    var calculator = Calculator()
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculator.delegate = self
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        calculator.tappedNumber(numberText: sender.title(for: .normal)!)
    }
    
    @IBAction func tappedOperator(_ sender: UIButton) {
        calculator.operatorTapped(operatorTitle: sender.title(for: .normal)!)
    }
    
    @IBAction func tappedResetButton(_ sender: Any) {
        calculator.resetButton()
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        _ = calculator.resultGiven(calculator.elements)
    }
}

extension ViewController : CalculatorDelegate {
    
    //    Method that display and save the numbers, operations & result directly in textView
    func AppendText(text: String) {
        textView.text = text
    }
    
    //    Method that handle the differents alert messages
    func showAlertMessage(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
