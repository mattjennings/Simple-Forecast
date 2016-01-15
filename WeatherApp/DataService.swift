//
//  DataService.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-12.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class DataService {

    static let instance = DataService()
    
    private var _currentIndex: Int = 0
    
    private var _city: String!
    private var _country: String!
    private var _temperature: [String]!
    private var _wind: [String]!
    
    private var _weekdays = [
        Weekday(bgColor: UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1), title: "Sunday"),     // Orange
        Weekday(bgColor: UIColor(red: 197/255, green: 57/255, blue: 43/255, alpha: 1), title: "Monday"),      // Red
        Weekday(bgColor: UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1), title: "Tuesday"),    // Blue
        Weekday(bgColor: UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1), title: "Wednesday"),  // Yellow
        Weekday(bgColor: UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1), title: "Thursday"),   // Purple
        Weekday(bgColor: UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1), title: "Friday"),      // Green
        Weekday(bgColor: UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1), title: "Saturday")   // White        
    ]
    
    var weekdays: [Weekday] {
        return _weekdays
    }
    
    var currentIndex: Int {
        set (newValue) {
            _currentIndex = newValue
        } get {
            return _currentIndex
        }
    }
    
    func getForecast(completed: DownloadComplete) {
        
        Alamofire.request(.GET, "\(URL_BASE)forecast?q=Brandon,ca&mode=json&cnt=7&units=metric&APPID=\(API_KEY)")
            .responseJSON { response in
                print(response.request)  // original URL request
                
                let result = response.result
                
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    
                    // Reminder of where city info is
                    // if let city = dict["city"] as? Dictionary<String, AnyObject>

                    // Days
                    if let lists = dict["list"] as? [AnyObject] {
                        
                        // Loop through each day
                        var i = 0 // index
                        for list in lists {
                            if let day = list as? Dictionary<String, AnyObject> {
                                
                                if let main = day["main"] as? Dictionary<String, AnyObject> {
                                    // Temperature
                                    if let temp = main["temp"] as? Double {
                                        self.weekdays[i].temperature = "\(temp)"
                                    }
                                }
                            }
                            i++
                        }
                    }
                }
                

                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "onReceivedWeather", object: nil));
                completed()
        }
    }
}
