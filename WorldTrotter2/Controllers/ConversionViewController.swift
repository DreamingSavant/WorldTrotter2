//
//  ConversionViewController.swift
//  WorldTrotter2
//
//  Created by Roderick Presswood on 10/8/18.
//  Copyright © 2018 Roderick Presswood. All rights reserved.
//

import Foundation
import UIKit


class ConversionViewController: UIViewController,UITextFieldDelegate {
   
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ConversionViewController loaded its view.")
        
        updateCelsiusLabel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH a"
        let date = Date(timeIntervalSinceNow: 0)
        dateFormatter.locale = Locale(identifier: "en_US")
        let hour = dateFormatter.string(from: date)
        let nightFall = dateFormatter.string(from: date.addingTimeInterval(15000))
        let dayBreak = dateFormatter.string(from: date.addingTimeInterval(35000))
        
        if hour >= nightFall && hour <= dayBreak  {
            randomDarkColor()
//            print(dateFormatter.string(from: date))
            print(hour)
            print(nightFall)
            print(dayBreak)
        } else {
            randomLightColor()
//            print(dateFormatter.string(from: date))
        }
        
    }
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        celsiusLabel.text = textField.text
        
//        if let text = textField.text, let value = Double(text){
//            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        if let text = textField.text, let number = numberFormatter.number(from: text){
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue{
//            celsiusLabel.text = "\(celsiusValue.value)"
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    // use uitextfield delegates below
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print("Current text: \(String(describing: textField.text))")
//        print("Replacement text: \(string)")
//
//        return true
        
//        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
//        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        //adding separator ctype change depending on locale
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        
        let exisitingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        let charactersNotAllowed = NSCharacterSet.letters
        let replacementTextHasLetter = string.rangeOfCharacter(from: charactersNotAllowed)
        
        if exisitingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
            
            return false
        }
      
        if replacementTextHasLetter != nil {
            
            return false
        }
        
        return true
    }
    
    func randomLightColor() {
        let randomLightColorIndex = Int(arc4random_uniform(3))
        var arrayOfLightColors: [UIColor] = [UIColor.lightGray, UIColor.yellow, UIColor.orange]
        let colors = arrayOfLightColors[randomLightColorIndex]
        view.backgroundColor = colors
    }
    
    func randomDarkColor(){
        var arrayOfDarkColors: [UIColor] = [UIColor.darkGray, UIColor.black]
        let randomDarkColorIndex = Int(arc4random_uniform(2))
        let colors = arrayOfDarkColors[randomDarkColorIndex]
        view.backgroundColor = colors
    }
    
}
