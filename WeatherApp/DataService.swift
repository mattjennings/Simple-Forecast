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
    
    private var _weekdays = [
        Weekday(bgColor: UIColor(red: 51/255, green: 110/255, blue: 123/255, alpha: 1), title: "Sunday"),     // Faded blue
        Weekday(bgColor: UIColor(red: 197/255, green: 57/255, blue: 43/255, alpha: 1), title: "Monday"),      // Red
        Weekday(bgColor: UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1), title: "Tuesday"),    // Bright Blue
        Weekday(bgColor: UIColor(red: 241/255, green: 171/255, blue: 53/255, alpha: 1), title: "Wednesday"),  // Yellow
        Weekday(bgColor: UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1), title: "Thursday"),   // Purple
        Weekday(bgColor: UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1), title: "Friday"),      // Green
        Weekday(bgColor: UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1), title: "Saturday")      // Dark blue
    ]
    
    var weekdays: [Weekday] {
        set(newValue) {
            _weekdays = newValue
        } get {
            return _weekdays
        }
    }
    
    var currentIndex: Int {
        set (newValue) {
            _currentIndex = newValue
        } get {
            return _currentIndex
        }
    }
    
    func getForecast(completed: DownloadComplete) {
        // forecast/daily?q= gets the 16 day forecast so we can restrict it to 7 results
        // forecast?q= gets the 5 day forecast in 3 hour intervals
        
        // Get the temperature for the week
        Alamofire.request(.GET, "\(URL_BASE)forecast/daily?q=Brandon,ca&mode=json&cnt=7&units=metric&APPID=\(API_KEY)")
            .responseJSON { response in
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
                                
                                // Temperature
                                if let temp = day["temp"] as? Dictionary<String, AnyObject> {
                                    if let dayTemp = temp["day"] as? Double {
                                        self.weekdays[i].temperature = "\(Int(dayTemp))"
                                    }
                                }
                                
                                // Weather icon
                                if let weather = day["weather"] as? [AnyObject] {
                                    
                                    if let icon = weather[0]["icon"] as? String {
                                        self.weekdays[i].icon = icon
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
        
        
        // Get the 5 day forecast with 3 hour intervals
        
        Alamofire.request(.GET, "\(URL_BASE)forecast/?q=Brandon,ca&mode=json&units=metric&APPID=\(API_KEY)")
            .responseJSON { response in
                
                let result = response.result
                
                let dayFormatter = NSDateFormatter()
                let timeFormatter = NSDateFormatter()
                dayFormatter.dateFormat = "dd"
                timeFormatter.dateFormat = "HH:mm"
                
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    
                    if let lists = dict["list"] as? [AnyObject] {
                        
                        var i = 0 // index
                        for list in lists {
                            //print(list["dt"])
                            if let dateInt = list["dt"] as? Int {
                                var date = NSDate(timeIntervalSince1970: NSTimeInterval(dateInt))
                                let day = dayFormatter.stringFromDate(date)
                                let hour = timeFormatter.stringFromDate(date)
                                print("Day: \(day) Hour: \(hour)")
                            }
                        }
                    }
                }
                completed()
        }
    }
}



