//
//  HourlyForecast.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-17.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import Foundation

class HourlyForecast {
    private var _time: String!
    private var _temp: String!
    private var _icon: String!
    
    var time: String {
        set (newVal) {
            _time = newVal
        } get {
            return _time
        }
    }
    
    var temp: String {
        set (newVal) {
            _temp = newVal
        } get {
            return _temp
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
    
    init() {
        _icon = "sun"
        _temp = "0"
        _time = "00:00"
    }
    
}