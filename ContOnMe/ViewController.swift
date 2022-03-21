//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    
    
    
   
    @IBOutlet weak var textView: UITextView!
  //  @IBOutlet var numberButtons: [UIButton]!
    private  var model:ModelCountOnMe = ModelCountOnMe()
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
       
    }
    
    // MARK: - IBAction
    
    //MARK - numeric button is tapped
    
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
    
        model.addNumericValue(value: numberText)
    }
    //MARK - operator button is tapped
    
    @IBAction func tappedOperatorButton (_ sender: UIButton) {
        guard let numericOperator:String = sender.titleLabel!.text else{
            return
        }
    
        model.addOperator(value: " \(numericOperator) ")
        
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        
        model.calculateResult()
        
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        model.deleteLastChar()
    }
    
    @IBAction func clearBtnTapped(_ sender: Any) {
        model.clearScreen()
    }
}
//MARK: - DELEGATE extension

extension ViewController:ModelCountOnMeDelegate{
    func sreenCalculatoralueChange(value: String) {
        textView.text = value
        
        if(textView.text.count == 0){
          
        }
    }
    
    func  alert(message:String,title:String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
