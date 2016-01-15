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
    
    init(bgColor: UIColor, title: String) {
        _bgColor = bgColor
        _title = title
        _temperature = "0"
    }
    
    init() {
        _bgColor = UIColor.whiteColor()
        _title = "not initialized"
        _temperature = "0"
    }
    
}

func == (lhs: Weekday, rhs: Weekday) -> Bool {
    return lhs.title == rhs.title
}