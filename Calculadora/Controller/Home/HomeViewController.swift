//
//  HomeViewController.swift
//  Calculadora
//
//  Created by Edwin on 8/29/19.
//  Copyright © 2019 Edwin. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // Outlets
    
    // Result
    @IBOutlet weak var resultLabel: UILabel!
    
    // Number
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var operatorDecimal: UIButton!
    
    // Operators
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var operatorPlusMinus: UIButton!
    @IBOutlet weak var operatorPercent: UIButton!
    @IBOutlet weak var operatorResult: UIButton!
    @IBOutlet weak var operatorAddition: UIButton!
    @IBOutlet weak var operatorSubstraction: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    
    
    // MARK: - Variables
    private var total:Double = 0                    // total
    private var temp:Double = 0                     // valor por pantalla
    private var operating:Bool = false              // indicar si se ha seleccionado un operador
    private var decimal = false                     // indicar si el valor es decimal
    private var operation:OperationType = .none     // operacion actual
    
    // MARK: - Constantes
    
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLength = 9
    private let kMaxValue:Double = 999999999
    private let kMinLength:Double = 0.00000001
    
    private enum OperationType{
        case none, addition, substraction, multiplication, division, percent
    }
    
    // Formateo de valores auxiliar
    private let auxFormatter:NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // Formateo de valores por pantalla por defecto
    private let printFormatter:NumberFormatter = {
       let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    // Formateo de valores por pantalla en formato cientifico
    private let printScientificFormatter:NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    // MARK: - Inicialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        operatorDecimal.round()
        
        operatorAC.round()
        operatorPlusMinus.round()
        operatorPercent.round()
        operatorResult.round()
        operatorAddition.round()
        operatorSubstraction.round()
        operatorMultiplication.round()
        operatorDivision.round()
        
        operatorDecimal.setTitle(kDecimalSeparator, for: .normal)
        
        result()
        
    }
    
    // Button Actions
    
    @IBAction func operatorACAction(_ sender: UIButton) {
        clear()
        sender.shine()
    }
    
    @IBAction func operatorPlusMinusAction(_ sender: UIButton) {
        temp *= -1
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        sender.shine()
    }
    
    @IBAction func operatorPercentAction(_ sender: UIButton) {
        if operation != .percent {
            result()
        }
        operating = true
        operation = .percent
        result()
        sender.shine()
    }
    
    @IBAction func operatorResultAction(_ sender: UIButton) {
        result()
        sender.shine()
    }
    
    @IBAction func operatorAdditionAction(_ sender: UIButton) {
        result()
        operating = true
        operation = .addition
        sender.shine()
    }
    
    @IBAction func operatorSubstractionAction(_ sender: UIButton) {
        result()
        operating = true
        operation = .substraction
        sender.shine()
    }
    
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        result()
        operating = true
        operation = .multiplication
        sender.shine()
    }
    
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        result()
        operating = true
        operation = .division
        sender.shine()
    }
    
    @IBAction func numberDecimalAction(_ sender: UIButton) {
        let currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength {
            return
        }
        resultLabel.text = resultLabel.text! + kDecimalSeparator
        decimal = true
        sender.shine()
    }
    
    @IBAction func numberAction(_ sender: UIButton) {
        
        operatorAC.setTitle("C", for: .normal)
        var currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength {
            return
        }
        
        // Hemos seleccionado una operacion
        if operating{
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
        }
        
        // Hemos seleccionado decimales
        if decimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            decimal = false
        }
        
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        sender.shine()
    }
    
    // Limpia los valores
    private func clear(){
        operation = .none
        operatorAC.setTitle("AC", for: .normal)
        if temp != 0 {
            temp = 0
            resultLabel.text = "0"
        } else {
            total = 0
        }
    }
    
    // Obtiene resultado final
    private func result(){
        switch operation {
            
        case .none:
            break
        case .addition:
            total += temp
            break
        case .substraction:
            total -= temp
            break
        case .multiplication:
            total *= temp
            break
        case .division:
            total /= temp
            break
        case .percent:
            temp /= 100
            total = temp
            break
        }
        
        // Formateo en pantalla
        if total <= kMaxValue || total >= kMinLength {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        print(total)
        
    }
    
}
