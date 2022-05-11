//
//  Model.swift
//  CountOnMe
//
//  Created by Richard Arif Mazid on 31/03/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

//Protocol to communicate with the viewController
protocol CalculatorDelegate: AnyObject {
    //    Methods to communicate with the data to viewController
    func AppendText(text: String)
    func showAlertMessage(title: String, message: String)
}

class Calculator {
    
    weak var delegate: CalculatorDelegate?
    
    var numbersShown: String = ""
    var elements: [String] { return numbersShown.split(separator: " ").map { "\($0)" }
    }
    
    func expressionHaveEnoughElement(_ elements: [String]) -> Bool {
        return elements.count >= 3
    }
    
    func expressionIsCorrect(_ elements: [String]) -> Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "÷"
    }
    
    // Method that displays an alert message when you try to put two operators in a row
    func operatorTapped(operatorTitle: String) {
        if expressionIsCorrect(elements) == false {
            delegate?.showAlertMessage(title: "Erreur", message: "Un opérateur est déja mis !")
        } else {
            numbersShown += " \(operatorTitle) "
            delegate?.AppendText(text: " \(numbersShown) ")
        }
    }
    
    // Method that displayed a number in the textView when tapped
    func tappedNumber(numberText: String) {
        numbersShown += "\(numberText)"
        delegate?.AppendText(text: numbersShown)
    }
    
    // Method that allows the reset
    func resetButton() {
        numbersShown = " "
        delegate?.AppendText(text: "0")
    }
    
    // Method that give result when equal button is tapped
    func resultGiven(_ elements: [String]) -> String? {
        var operationsToReduce = elements
        guard expressionHaveEnoughElement(elements) && expressionIsCorrect(elements) else {
            delegate?.showAlertMessage(title: "Erreur", message: "Entrez une expression correcte")
            return nil
        }
        //      Methods that handle calculations based on the type of operation
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
                numbersShown = "\(operationsToReduce[0])"
            }
        }
        return operationsToReduce.first
    }
    
    // Method that handle multiply and division (Also no dividing by 0)
    private func priorityOperation(_ elements: [String]) -> [String]? {
        var operationsToReduce = elements
        while operationsToReduce.contains("x") || operationsToReduce.contains("÷") {
            
            if let index = operationsToReduce.firstIndex(where: {$0 == "x" || $0 == "÷"}), let left = Float(operationsToReduce[index - 1]), let right = Float(operationsToReduce[index + 1])  {
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
                } else {
                    operationsToReduce[index - 1] = "\(result)"
                }
                operationsToReduce.remove(at: index + 1)
                operationsToReduce.remove(at: index)
                delegate?.AppendText(text: "\(operationsToReduce[0])")
                numbersShown = "\(operationsToReduce[0])"
            }
        }
        return operationsToReduce
    }
    
    // Method that handle addition & substraction
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
                operationsToReduce.insert("\(Float(result))", at: 0)
            }
            delegate?.AppendText(text: "\(operationsToReduce[0])")
        }
        return operationsToReduce
    }
}
