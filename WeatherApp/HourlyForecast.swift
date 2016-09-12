//
//  HourlyForecast.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-17.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import Foundation

class HourlyForecast {
    fileprivate var _time: String!
    fileprivate var _temp: String!
    fileprivate var _icon: String!
    fileprivate var _weatherDesc: String!
    
    var time: String {
        return _time
    }
    
    var temp: String {
        return _temp
    }
    
    var icon: String {
        return _icon
    }
    
    var weatherDescription: String {
        return _weatherDesc
    }
    
    init(time: String, icon: String, weatherDescription: String!, temp: String) {
        _temp = temp
        _time = time
        _weatherDesc = weatherDescription
        _icon = iconNameToImageName(icon)
    }
    
}
