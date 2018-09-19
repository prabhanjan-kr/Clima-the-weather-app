//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityNameDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "8a47bb43eb2e4587a45f5f0db37ce32e"
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    var weatherData : WeatherDataModel = WeatherDataModel()
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func refreshButtonClicked(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url :String, parameters:[String:String]) {
        let URL = url
        Alamofire.request(URL, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("Successful reception of weather data")
                let responseJSON : JSON = JSON(response.result.value!)
                print(responseJSON)
                if responseJSON["cod"].stringValue == "404" {
                    self.cityLabel.text = responseJSON["message"].stringValue
                    self.weatherIcon.image = UIImage(named: "dunno")
                    self.temperatureLabel.text = ""
                }
                else {
                    self.updateWeatherData(json: responseJSON)
                }
                
            }
            else {
                print("Error:\(String(describing: response.result.error))")
            }
        }
        
    }
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateWeatherData(json : JSON) {
        weatherData.temperature = Int(json["main"]["temp"].doubleValue - 273.15)
        weatherData.cityName =  json["name"].stringValue
        weatherData.condition = json["weather"][0]["id"].intValue
        self.updateUIWithWeatherData()
        
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        self.temperatureLabel.text = String(describing: weatherData.temperature) + "°"
        self.cityLabel.text = weatherData.cityName
        self.weatherIcon.image = UIImage(named: weatherData.updateWeatherIcon(condition: weatherData.condition))
    }
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            if location.horizontalAccuracy > 0 {
                locationManager.stopUpdatingLocation()
            }
            var params : [String:String] = [String:String]()
            params["lat"] = String(location.coordinate.latitude)
            params["lon"] = String(location.coordinate.longitude)
            params["appid"] = APP_ID
            
            getWeatherData(url : WEATHER_URL, parameters : params)
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavailable"
    }
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    func cityNameChanged(to cityName: String) {
        print(cityName)
        //construct param into a dictionary
        var param = [String:String]()
        param["q"] = cityName
        param["appid"] = APP_ID
        //pass it to getWeatherData
        getWeatherData(url: WEATHER_URL, parameters: param)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ChangeCityViewController
        destinationVC.delegate = self
        
    }
    
    
    
    
    
}


