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
        Weekday(index: 0, bgColor: UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1), title: "Sunday"),       // Orange
        Weekday(index: 1, bgColor: UIColor(red: 197/255, green: 57/255, blue: 43/255, alpha: 1), title: "Monday"),      // Red
        Weekday(index: 2, bgColor: UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1), title: "Tuesday"),    // Blue
        Weekday(index: 3, bgColor: UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1), title: "Wednesday"),  // Yellow
        Weekday(index: 4, bgColor: UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1), title: "Thursday"),   // Purple
        Weekday(index: 5, bgColor: UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1), title: "Friday"),      // Green
        Weekday(index: 6, bgColor: UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1), title: "Saturday")   // White

        
    ]
    
    static var currentIndex: Int = 0
}
