//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class SimpleCalcTests: XCTestCase {
    
    var simpleCalc: Calculator!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        simpleCalc = Calculator()
    }
    
    func testGivenNumbersAre2And1_WhenAdd_ThenResultIs3() {
            let inputs = ["2", "+", "1"]
            let expected = "3"
            let result = simpleCalc.resultGiven(inputs)
            XCTAssertEqual(expected, result)
        }
    
    func testGivenNumbersAre5And10_WhenMinus_ThenResultIsMinus5() {
            let inputs = ["5", "-", "10"]
            let expected = "-5"
            let result = simpleCalc.resultGiven(inputs)
            XCTAssertEqual(expected, result)
        }
    
    func testGivenNumbersAre2And10_WhenMultiply_ThenResult20() {
            let inputs = ["2", "x", "10"]
            let expected = "20"
            let result = simpleCalc.resultGiven(inputs)
            XCTAssertEqual(expected, result)
        }
    
    func testGiven2Plus1Minus3_WhenCalculate_ThenResultIs0() {
            let inputs = ["2", "+", "1", "-", "3"]
            let expected = "0"
            let result = simpleCalc.resultGiven(inputs)
            XCTAssertEqual(expected, result)
        }
    
    
    func testGivenAnyNumber_WhenDevidedByZero_ThenResultIsNil() {
            let inputs = ["4", "÷", "0"]
            let result = simpleCalc.resultGiven(inputs)
            XCTAssertNil(result)
        }
    
    func testGivenOneNumberAndOneOperator_WhenTappeEqual_ThenResultIsNil() {
            let inputs = ["4", "÷"]
            let result = simpleCalc.resultGiven(inputs)
            XCTAssertNil(result)
        }
    
    func testGivenFollowingOperators_WhenTappeEqual_ThenResultIsNil() {
           let inputs = ["4", "+", "÷"]
           let result = simpleCalc.resultGiven(inputs)
           XCTAssertNil(result)
       }
    
    func testGivenNumbers1Plus2Times3_WhenCalculate_ThenResultIs7() {
          let inputs = ["1", "+", "2", "x", "3"]
          let expected = "7"
          let result = simpleCalc.resultGiven(inputs)
          XCTAssertEqual(expected, result)
      }
    
    func testGivenReset_WhenResetTapped_ThenResetOn() {
      simpleCalc.resetButton()
        XCTAssertEqual(simpleCalc.testText == "4", simpleCalc.testText == "0")
    }
    
    func testgivenNumber_WhenNumberDisplayed_ThenShowNumber() {
        simpleCalc.tappedNumber(numberText: "3")
        XCTAssert(simpleCalc.testText == "3")
    }
    
    func testGivenNumber_WhenAddOperator_ThenAddNumber() {
        simpleCalc.operatorTapped(operatorTitle: "=")
        XCTAssert(simpleCalc.canAddOperator)
        
    }

}
