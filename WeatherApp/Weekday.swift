//
//  Weekday.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-12.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import Foundation
import UIKit

class Weekday: Equatable {

    private var _bgColor: UIColor!
    private var _title: String!
    
    private var _temperature: String!
    private var _icon: String!
    
    var title: String {
        return _title
    }
    
    var bgColor: UIColor {
        return _bgColor
    }
    
    var temperature: String {
        set (newVal) {
            _temperature = newVal
        } get {
            return _temperature   
        }
    }

    var icon: String {
        set (newVal) {
            var v = "01d"
            switch (newVal) {
                case "01d":
                    v = "sun"
                case "01n":
                    v = "moon"
                case "02d", "03d", "03n", "04d", "04n":
                    v = "cloud"
                case "02n":
                    v = "cloudy_night"
                case "09d", "09n":
                    v = "rain"
                case "10d", "10n":
                    v = "heavy_rain"
                case "11d", "11n":
                    v = "storm"
                case "13d", "13n":
                    v = "snow"
                default:
                    v = "sun"
            }
            _icon = v
        } get {
            return _icon
        }
    }

    
    init(bgColor: UIColor, title: String) {
        _bgColor = bgColor
        _title = title
        _temperature = "0"
        _icon = "13d"
    }
    /*
    init() {
        _bgColor = UIColor.whiteColor()
        _title = "not initialized"
        _temperature = "0"
        _temperatureMax = "0"
        _temperatureMin = "0"
    }*/
    
}

func == (lhs: Weekday, rhs: Weekday) -> Bool {
    return lhs.title == rhs.title
}