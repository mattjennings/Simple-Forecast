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
let DEFAULT_CITY = "Brandon,ca"

typealias DownloadComplete = () -> ()


func getDayOfWeek() -> Int? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "e"
    let dayOfWeekString = dateFormatter.string(from: Date())
    return (Int(dayOfWeekString))
}

func getDayOfMonth() -> Int? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd"
    let dayOfMonthString = dateFormatter.string(from: Date())
    return (Int(dayOfMonthString))
}

func iconNameToImageName(_ name: String) -> String {
    var v = ""
    switch (name) {
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
    return v
}

extension Array {
    
    //Stack - LIFO
    mutating func push(_ newElement: Element) {
        self.append(newElement)
    }
    
    mutating func pop() -> Element? {
        return self.removeLast()
    }
    
    func peekAtStack() -> Element? {
        return self.last
    }
    
    //Queue - FIFO
    mutating func enqueue(_ newElement: Element) {
        self.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        return self.remove(at: 0)
    }
    
    func peekAtQueue() -> Element? {
        return self.first
    }
}

extension UIColor {
    var coreImageColor: CoreImage.CIColor? {
        return CoreImage.CIColor(color: self)  // The resulting Core Image color, or nil
    }
    
    func adjust(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha:CGFloat) -> UIColor{
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: r+red, green: g+green, blue: b+blue, alpha: a+alpha)
    }
}
