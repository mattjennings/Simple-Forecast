//
//  DayForecastCell.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-15.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import UIKit

class DayForecastCell: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var tempLbl: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func configureCell(_ time: String, icon: String, temp: String) {
        timeLbl.text = time
        iconImg.image = UIImage(named: icon)
        tempLbl.text = "\(temp) °C"
    }

}
