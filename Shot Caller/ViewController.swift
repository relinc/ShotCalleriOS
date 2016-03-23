//
//  ViewController.swift
//  Shot Caller
//
//  Created by Brent on 8/28/15.
//  Copyright (c) 2015 REL Inc. All rights reserved.
//

import UIKit
import Darwin

extension String {
    var doubleValue:Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var PreviousStrainRateTF: UITextField!
    @IBOutlet weak var PreviousStrikerBarLengthTF: UITextField!
    @IBOutlet weak var PreviousPressureTF: UITextField!
    @IBOutlet weak var NextStrainRateTF: UITextField!
    @IBOutlet weak var NextStrikerBarLengthTF: UITextField!
    @IBOutlet weak var NextPressureTextField: UITextField!
    @IBOutlet weak var myUIImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func imageClicked(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.relinc.net/split-hopkinson-bar-kolsky-bars/")!)
        
    }

    @IBAction func ClearFired(sender: AnyObject) {
        
        PreviousStrainRateTF.text = ""
        PreviousStrikerBarLengthTF.text = ""
        PreviousPressureTF.text = ""
        NextStrainRateTF.text = ""
        NextStrikerBarLengthTF.text = ""
        NextPressureTextField.text = ""
        
        PreviousStrainRateTF.backgroundColor = UIColor.whiteColor()
        PreviousStrikerBarLengthTF.backgroundColor = UIColor.whiteColor()
        PreviousPressureTF.backgroundColor = UIColor.whiteColor()
    }
    @IBAction func CalculateFired(sender: AnyObject) {
        println("Fired")
        println(PreviousStrainRateTF.text)
        println(PreviousStrikerBarLengthTF.text)
        println(PreviousPressureTF.text)
        println(NextStrainRateTF.text)
        println(NextStrikerBarLengthTF.text)
        println(NextPressureTextField.text)
        
        if(!checkPreviousBoxes()){
            return
        }
        
        if(!atLeastTwoNextBoxesFilled()){
            return
        }
        //data is valid, make the calculation
        
        if(NextStrainRateTF.text.doubleValue == nil){
            //perform SR calc
            calculateStrainRate();
        }
        else if(NextStrikerBarLengthTF.text.doubleValue == nil){
            //perform Striker Bar calc
            calculateStrikerBarLength();
        }
        else{
            //perform pressure by default.
            calculatePressure();
        }
        
        println("Continuing functions")
    }
    
    
    func calculateStrainRate(){
        var PreviousStrainRate : Double = PreviousStrainRateTF.text.doubleValue!;
        var PreviousStrikerBarLength : Double = PreviousStrikerBarLengthTF.text.doubleValue!;
        var PreviousPressure : Double = PreviousPressureTF.text.doubleValue!;
        var NextStrikerBarLength : Double = NextStrikerBarLengthTF.text.doubleValue!;
        var NextPressure : Double = NextPressureTextField.text.doubleValue!;
        
        
        var NewStrainRate : Double = PreviousStrainRate * sqrt(NextPressure / PreviousPressure * PreviousStrikerBarLength / NextStrikerBarLength);
        
        NextStrainRateTF.text = roundToPlaces(NewStrainRate,places: 3).description;
    }
    
    func calculateStrikerBarLength(){
        var PreviousStrainRate : Double = PreviousStrainRateTF.text.doubleValue!;
        var PreviousStrikerBarLength : Double = PreviousStrikerBarLengthTF.text.doubleValue!;
        var PreviousPressure : Double = PreviousPressureTF.text.doubleValue!;
        var NextStrainRate : Double = NextStrainRateTF.text.doubleValue!;
        var NextPressure : Double = NextPressureTextField.text.doubleValue!;
        
        
        
        var NewStrikerBarLength : Double = NextPressure / PreviousPressure * PreviousStrikerBarLength / pow(NextStrainRate / PreviousStrainRate, 2);
        
        NextStrikerBarLengthTF.text = roundToPlaces(NewStrikerBarLength,places: 3).description;
    }
    
    
    
    func calculatePressure(){
        var PreviousStrainRate : Double = PreviousStrainRateTF.text.doubleValue!;
        var PreviousStrikerBarLength : Double = PreviousStrikerBarLengthTF.text.doubleValue!;
        var PreviousPressure : Double = PreviousPressureTF.text.doubleValue!;
        var NextStrainRate : Double = NextStrainRateTF.text.doubleValue!;
        var NextStrikerBarLength : Double = NextStrikerBarLengthTF.text.doubleValue!;
        
        
        var NewPressure : Double = pow(NextStrainRate / PreviousStrainRate, 2) * PreviousPressure / PreviousStrikerBarLength * NextStrikerBarLength;
        
        NextPressureTextField.text = roundToPlaces(NewPressure,places: 3).description
    }

    func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    
    func checkPreviousBoxes() -> Bool{
        var isValid :Bool
        isValid = true
        if(PreviousPressureTF.text.doubleValue == nil){
            PreviousPressureTF.backgroundColor = UIColor.redColor()
            isValid = false
        }
        else{
            PreviousPressureTF.backgroundColor = UIColor.whiteColor()
        }
        
        if(PreviousStrainRateTF.text.doubleValue == nil){
            PreviousStrainRateTF.backgroundColor = UIColor.redColor()
            isValid = false
        }
        else{
            PreviousStrainRateTF.backgroundColor = UIColor.whiteColor()
        }
        if(PreviousStrikerBarLengthTF.text.doubleValue == nil){
            PreviousStrikerBarLengthTF.backgroundColor = UIColor.redColor()
            isValid = false
        }else{
            PreviousStrikerBarLengthTF.backgroundColor = UIColor.whiteColor()
        }
        return isValid;
    }
    
    func atLeastTwoNextBoxesFilled() -> Bool{
        var isValid :Bool
        var count : Int = 0
        
        if(NextStrainRateTF.text.doubleValue != nil)
        {
            count++
        }
        if(NextStrikerBarLengthTF.text.doubleValue != nil){
            count++
        }
        if(NextPressureTextField.text.doubleValue != nil){
            count++
        }
        return count > 1
        
    }
    
    func blinkTextField(textField : UITextField, color : UIColor){

        textField.backgroundColor = color;
        sleep(1);
        textField.backgroundColor = UIColor.whiteColor()
        sleep(1);
        textField.backgroundColor = color;
        sleep(1);
        textField.backgroundColor = UIColor.whiteColor()
        
        
        
    }
}

