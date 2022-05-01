//
//  Model.swift
//  CountOnMe
//
//  Created by Richard Arif Mazid on 31/03/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation
protocol CalculatorDelegate: AnyObject {
    func testAppendText(text: String)
    func showAlertMessage(title: String, message: String)
}

class Calculator {
    
    weak var delegate: CalculatorDelegate?
    
    var testText: String = ""
    var elements: [String] {
        return testText.split(separator: " ").map { "\($0)" }
    }
    
    func expressionHaveEnoughElement(_ elements: [String]) -> Bool {
           return elements.count >= 3
       }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"  && elements.last != "x"  && elements.last != "÷"
    }
    
    var expressionHaveResult: Bool {
        return testText.firstIndex(of: "=") != nil
    }
    
    func expressionIsCorrect(_ elements: [String]) -> Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "÷"
    }
    
    func operatorTapped(operatorTitle: String) {
        if canAddOperator == false {
            delegate?.showAlertMessage(title: "Erreur", message: "Un opérateur est déja mis !")
        } else {
            testText += " \(operatorTitle) "
            delegate?.testAppendText(text: " \(testText) ")
        }
    }
    
    func tappedNumber(numberText: String) {
        testText += "\(numberText)"
        delegate?.testAppendText(text: testText)
    }
    
    func resetButton() {
        testText = " "
        delegate?.testAppendText(text: "0")
    }
    
    func resultGiven(_ elements: [String]) -> String? {
        var operationsToReduce = elements
        guard expressionHaveEnoughElement(elements) && expressionIsCorrect(elements) else {
            delegate?.showAlertMessage(title: "Erreur", message: "Entrez une expression correcte")
            print("ok")
            return nil
        }
        
        while operationsToReduce.count > 1 {
            guard let firstResult = priorityOperation(operationsToReduce) else {
                return nil
            }
            if firstResult.count == 1 {
                return firstResult.first
            } else {
                guard let finalResult = nonPriorityOperation(firstResult) else {
                    return nil
                }
                operationsToReduce = finalResult
                testText = "\(operationsToReduce[0])"
            }
        }
        return operationsToReduce.first
    }
    
    private func priorityOperation(_ elements: [String]) -> [String]? {
        var operationsToReduce = elements
        while operationsToReduce.contains("x") || operationsToReduce.contains("÷") {
            
            if let index = operationsToReduce.firstIndex(where: {$0 == "x" || $0 == "÷"}), let left = Float(operationsToReduce[index - 1]), let right = Float(operationsToReduce[index + 1])  {
                print("test")
                var result: Float
                var isInteger: Bool {
                    return floor(result) == result
                }
                let operand = operationsToReduce[index]
                switch operand {
                case "x": result = Float(left * right)
                case "÷":
                    if right == 0 {
                        delegate?.showAlertMessage(title: "Erreur", message: "Impossible de diviser par zéro !")
                        return nil
                    }
                    result = Float(left / right)
                default: return nil
                }
                if isInteger {
                    operationsToReduce[index - 1] = "\(Int(result))"
                    print("multi")
                } else {
                    operationsToReduce[index - 1] = "\(result)"
                    print("div")
                }
                operationsToReduce.remove(at: index + 1)
                operationsToReduce.remove(at: index)
                delegate?.testAppendText(text: "\(operationsToReduce[0])")
                testText = "\(operationsToReduce[0])"
            }
        }
        return operationsToReduce
    }
    
    private func nonPriorityOperation(_ elements: [String]) -> [String]? {
        var operationsToReduce = elements
        let operand = operationsToReduce[1]
        if let left = Float(operationsToReduce[0]), let right = Float(operationsToReduce[2]) {
            var result: Float
            var isInteger: Bool {
                return floor(result) == result
            }
            switch operand {
            case "+": result = Float(left + right)
            case "-": result = Float(left - right)
            default: return nil
            }
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            if isInteger {
                operationsToReduce.insert("\(Int(result))", at: 0)
            } else {
                operationsToReduce.insert("\(result)", at: 0)
            }
            delegate?.testAppendText(text: "\(operationsToReduce[0])")
        }
        return operationsToReduce
    }
}
