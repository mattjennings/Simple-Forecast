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
        Weekday(index: 0, bgColor: UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1), title: "Blue"),
        Weekday(index: 1, bgColor: UIColor(red: 197/255, green: 57/255, blue: 43/255, alpha: 1), title: "Red"),
        Weekday(index: 2, bgColor: UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1), title: "Green")
    ]
    
    static var currentIndex: Int = 0
}
