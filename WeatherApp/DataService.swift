//
//  DataService.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-12.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import Foundation
import UIKit

class DataService {

    static var weekdays = [
        Weekday(bgColor: UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1), title: "Sunday"),     // Orange
        Weekday(bgColor: UIColor(red: 197/255, green: 57/255, blue: 43/255, alpha: 1), title: "Monday"),      // Red
        Weekday(bgColor: UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1), title: "Tuesday"),    // Blue
        Weekday(bgColor: UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1), title: "Wednesday"),  // Yellow
        Weekday(bgColor: UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1), title: "Thursday"),   // Purple
        Weekday(bgColor: UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1), title: "Friday"),      // Green
        Weekday(bgColor: UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1), title: "Saturday")   // White        
    ]
    
    static var currentIndex: Int = 0
}
