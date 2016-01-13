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
    
    private var _index: Int!
    private var _bgColor: UIColor!
    private var _title: String!
    
    var title: String {
        return _title
    }
    
    var index: Int {
        return _index
    }
    
    var bgColor: UIColor {
        return _bgColor
    }
    
    init(index: Int, bgColor: UIColor, title: String) {
        _index = index
        _bgColor = bgColor
        _title = title
    }
    
    init() {
        _index = 0
        _bgColor = UIColor.whiteColor()
        _title = "not initialized"
    }
    
}

func == (lhs: Weekday, rhs: Weekday) -> Bool {
    return lhs.title == rhs.title
}