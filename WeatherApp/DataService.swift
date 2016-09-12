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
import MapKit

class DataService {

    static let instance = DataService()
    
    fileprivate var _currentLocation: CLLocation!
    fileprivate var _city: String = "LOADING"
    fileprivate var _country: String = ""
    
    fileprivate var _weekdays = [
        Weekday(bgColor: UIColor(red: 51/255, green: 110/255, blue: 123/255, alpha: 1), title: "Sunday"),     // Faded blue
        Weekday(bgColor: UIColor(red: 197/255, green: 57/255, blue: 43/255, alpha: 1), title: "Monday"),      // Red
        Weekday(bgColor: UIColor(red: 34/255, green: 167/255, blue: 240/255, alpha: 1), title: "Tuesday"),    // Bright Blue
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
    
    var currentLocation: CLLocation {
        set (newVal) {
            _currentLocation = newVal
        } get {
            return _currentLocation
        }
    }
    
    var city: String! {
        set (newVal) {
            _city = newVal
        } get {
            return _city
        }
    }
    
    var country: String! {
        set (newVal) {
            _country = newVal
        } get {
            return _country
        }
    }
    
    func getForecast(_ completed: @escaping DownloadComplete) {
        
        let locationType = "lat=\(self.currentLocation.coordinate.latitude)&lon=\(self.currentLocation.coordinate.longitude)"
        
        let url = "\(URL_BASE)forecast/daily?\(locationType)&mode=json&cnt=7&units=metric&APPID=\(API_KEY)"
                
        // Get the temperature for the week
        Alamofire.request(url)
            .responseJSON { response in
                let result = response.result
                
                let dateFormatter = DateFormatter()
                let yearFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd"
                yearFormatter.dateFormat = "yyyy"

                if let dict = result.value as? Dictionary<String, AnyObject> {
                    
                    // Reminder of where city info is
                    if let city = dict["city"] as? Dictionary<String, AnyObject> {
                        if let name = city["name"] as? String {
                            self.city = name
                        }
                        
                        if let country = city["country"] as? String {
                            self.country = country
                        }
                    }

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
                                
                                // Date
                                if let dateInt = day["dt"] as? Int {
                                    let date = NSDate(timeIntervalSince1970: TimeInterval(dateInt))
                                    let dateAndMonth = dateFormatter.string(from: date as Date)
                                    let year = yearFormatter.string(from: date as Date)
                                    self.weekdays[i].date = "\(dateAndMonth)"
                                    self.weekdays[i].year = "\(year)"
                                }
                            }
                            
                            i += 1
                        }
                    }
                }

                NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "onReceivedWeather"), object: nil) as Notification);
                completed()
        }
        
        
        // Get the 5 day forecast with 3 hour intervals
        
        // Clear existing forecasts
        for wd in self.weekdays {
            wd.forecasts = []
        }
        
        Alamofire.request("\(URL_BASE)forecast/?q=Brandon,ca&mode=json&units=metric&APPID=\(API_KEY)")
            .responseJSON { response in
                
                let result = response.result
                
                let currentDay = getDayOfMonth()
                let dayFormatter = DateFormatter()
                
                let timeFormatter = DateFormatter()
                dayFormatter.dateFormat = "dd"
                timeFormatter.dateFormat = "h:mm a"
                
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    
                    if let lists = dict["list"] as? [AnyObject] {
                        
                        for list in lists {
                            
                            var indexToSet = 0
                            
                            var newTime = "00:00"
                            var newIcon = "01n"
                            var newTemp = "-60"
                            var newWeatherDesc = "CLOUDS"
                            var newForecast: HourlyForecast!
                            
                            // Get date and time
                            if let dateInt = list["dt"] as? Int {
                                let date = NSDate(timeIntervalSince1970: TimeInterval(dateInt))
                                let day = dayFormatter.string(from: date as Date)
                                let hour = timeFormatter.string(from: date as Date)
                                
                                
                                // Index to assign the forecast to
                                indexToSet = Int(day)! - currentDay!
                                newTime = hour
                            }
                            
                            if let main = list["main"] as? Dictionary<String, AnyObject> {
                                if let temp = main["temp"] as? Double {
                                    newTemp = "\(Int(temp - 273.15))" // Convert from Kelvin to Celsius
                                }
                            }
                            
                            if let weather = list["weather"] as? [AnyObject] {
                                if let icon = weather[0]["icon"] as? String {
                                    newIcon = icon
                                }
                                
                                if let description = weather[0]["description"] as? String {
                                    newWeatherDesc = description
                                }
                            }
                            
                            newForecast = HourlyForecast(time: newTime, icon: newIcon, weatherDescription: newWeatherDesc, temp: newTemp)
                            
                            // Prevent crash if user changed date
                            if indexToSet >= 0 {
                                self.weekdays[indexToSet].forecasts += [newForecast]
                            }
                        }
                        
                    }
                }
                NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "onReceivedForecast"), object: nil) as Notification);
                completed()
        }
    }
}



