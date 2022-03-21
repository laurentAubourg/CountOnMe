//
//  modelCountOnMe.swift
//  CountOnMe
//
//  Created by laurent aubourg on 21/06/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation
protocol ModelCountOnMeDelegate{
    func  sreenCalculatoralueChange(value:String)
    func  alert(message:String,title:String)
    
}
final class ModelCountOnMe{
    private var listOperator = ["+","-","X",":"]
    var sreenCalculatorValue:String = ""{
        didSet {
            delegate?.sreenCalculatoralueChange(value: sreenCalculatorValue)
        }
    }
    private var elements: [String] {
        return sreenCalculatorValue.split(separator: " ").map { "\($0)" }
    }
    private var operationsToReduce:[String] = []
    var delegate:ModelCountOnMeDelegate?
    private var calculError:Bool = false
    
    //MARK: - Checks if there is at least one character on the screen
    
    var expressionIsCorrect: Bool {
        
        guard let char = elements.last else{
            return false
        }
        
        return !listOperator.contains(char)
    }
    
    //MARK: -Checks if there are at least three characters on the screen
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    //MARK: - Checks if there is at least one character on the screen
    
    private  var canAddOperator: Bool {
        return expressionIsCorrect
    }
    
    //MARK: - Checks if the = character is on the screen
    
    private  var expressionHaveResult: Bool {
        return sreenCalculatorValue.firstIndex(of: "=") != nil
    }
    
    //MARK: - add operator to sreenCalculatorValue variable
    
    func addOperator(value:String){
        if expressionHaveResult {
            delegate?.alert(message: "An operation is already in place !\n please clean screen Before performing any other operation",title: "operator")
            return
        }
        if (canAddOperator){
            sreenCalculatorValue.append(value)
            
        }else{
            if elements.count == 0{
                delegate?.alert(message: "no numerical value before the operator",title: "operator")
                return
            }
            delegate?.alert(message: "An operator is already in place !",title: "operator")
        }
        
    }
    
    //MARK: - add numeric value to sreenCalculatorValue variable
    
    func addNumericValue(value:String){
        if expressionHaveResult {
            sreenCalculatorValue = ""
        }
        sreenCalculatorValue.append(value)
        
    }
    
    //MARK: - Calculates the result of the operation recursively for operator : type_operator
    
    
    private func calcul(typeOperator:String){
        
    
        var result:Double = 0
        var first:Double = 0
        var second:Double = 0
        var idx = 0
        
        for item in operationsToReduce{
            if listOperator.contains(item){
                first  =  Double(operationsToReduce[idx - 1])!
                second =  Double(operationsToReduce[idx + 1])!
            }
            if (item == "X" || item == ":") && typeOperator == "Priority"{
               
               switch item{
                case "X":
                    result = first * second
                case ":":
                    guard second > 0 else{
                        calculError = true
                        delegate?.alert(message: "division by zero not possible!",title: "bad argument")
                        return
                    }
                    result = first / second
                default: break
                }
                updateOperationsToReduce(idx:idx,result:result)
                self.calcul(typeOperator:typeOperator)
                break
            }else if (item == "+" || item == "-") &&  typeOperator == "Secondary"{
                
                switch item{
                case "+":
                    result = first + second
                case "-":
                    result = first - second
                default: break
                }
                updateOperationsToReduce(idx:idx,result:result)
            
                self.calcul(typeOperator:typeOperator)
                break
            }
            idx += 1
        }
    }
    
  private  func updateOperationsToReduce(idx:Int,result:Double){
        operationsToReduce[idx] = String(forTrailingZero(result))
        operationsToReduce.remove(at: idx + 1)
        operationsToReduce.remove(at: idx - 1)
    }
    
    //MARK: Calculates the operation according to the priority of the operators
    
    func calculateResult(){
        guard !self.expressionHaveResult  else {
            delegate?.alert(message: "Enter a correct expression!",title: "Error")
            return
        }
        guard self.expressionHaveEnoughElement else {
            delegate?.alert(message: "not enough element",title: "Error")
            return
        }
        operationsToReduce = elements
        calcul(typeOperator:"Priority")
        if calculError{
            calculError = false
            return
            
        }
        calcul(typeOperator:"Secondary")
        sreenCalculatorValue.append(" = \(operationsToReduce.first!)")
        
    }
    
    //MARK: - supprime les 0 derrière le . dans un Double si il n’a pas d’autre chiffre après
  
    func forTrailingZero(_ temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
    }
    //MARK: - deletes the last character of the variable sreenCalculatorValue
    
    func deleteLastChar(){
        if(elements.count > 0){
            let tmpStr = sreenCalculatorValue.dropLast()
            sreenCalculatorValue = String(tmpStr)
            
        }
        
    }
    func clearScreen(){
        sreenCalculatorValue = ""
    }
}
