//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit


//Write the protocol declaration here:
protocol ChangeCityNameDelegate {
    func cityNameChanged(to cityName: String)
}



class ChangeCityViewController: UIViewController {
    
    //Declare the delegate variable here:
    var delegate : ChangeCityNameDelegate?
    

    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        if (changeCityTextField.text == nil || changeCityTextField.text == "") {
            print("Enter a city name to Continue")
        }
        else if let enteredCityName = changeCityTextField.text {
            self.delegate?.cityNameChanged(to: enteredCityName)
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
