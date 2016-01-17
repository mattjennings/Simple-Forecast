//
//  Constants.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-14.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import Foundation
import UIKit

let API_KEY = "09c72ff225abb33534a6ee08ffd85687"
let URL_BASE = "http://api.openweathermap.org/data/2.5/"

typealias DownloadComplete = () -> ()


func getDayOfWeek() -> Int? {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "e"
    let dayOfWeekString = dateFormatter.stringFromDate(NSDate())
    return (Int(dayOfWeekString))
}

func getDayOfMonth() -> Int? {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd"
    let dayOfMonthString = dateFormatter.stringFromDate(NSDate())
    return (Int(dayOfMonthString))
}

extension Array {
    
    //Stack - LIFO
    mutating func push(newElement: Element) {
        self.append(newElement)
    }
    
    mutating func pop() -> Element? {
        return self.removeLast()
    }
    
    func peekAtStack() -> Element? {
        return self.last
    }
    
    //Queue - FIFO
    mutating func enqueue(newElement: Element) {
        self.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        return self.removeAtIndex(0)
    }
    
    func peekAtQueue() -> Element? {
        return self.first
    }
}

extension UIColor {
    var coreImageColor: CoreImage.CIColor? {
        return CoreImage.CIColor(color: self)  // The resulting Core Image color, or nil
    }
    
    func adjust(red: CGFloat, green: CGFloat, blue: CGFloat, alpha:CGFloat) -> UIColor{
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        var w: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: r+red, green: g+green, blue: b+blue, alpha: a+alpha)
    }
}