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
}