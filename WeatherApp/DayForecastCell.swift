//
//  DayForecastCell.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-15.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import UIKit

class DayForecastCell: UITableViewCell {

    @IBOutlet weak var weatherLbl: UILabel!
    private var _weatherDescription: String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //layer.cornerRadius = 5.0
    }
    
    func configureCell() {
    }

}
