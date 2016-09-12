//
//  DataViewController.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-11.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var dayForecastTable: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var forecastLabel: UILabel!
    
    var dataObject: Weekday!
    var bgColor: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.view.backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateWeekday(_:)), name: NSNotification.Name(rawValue: "onReceivedWeather"), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateForecast(_:)), name: NSNotification.Name(rawValue: "onReceivedForecast"), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewController.updateAll(_:)), name: NSNotification.Name(rawValue: "onReceivedReload"), object: nil);
        
        dayForecastTable.delegate = self
        dayForecastTable.dataSource = self
        dayForecastTable.backgroundColor = UIColor.clear    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()        
    }
    
    func updateWeekday(_ notif: AnyObject) {
        updateData()
    }
    
    func updateData() {
        self.dayLabel!.text = dataObject.title
        self.tempLabel.text = "\(dataObject.temperature)"        
        self.iconImg.image = UIImage(named: dataObject.icon)
        self.dateLabel.text = dataObject.date
        self.yearLabel.text = dataObject.year
        updateTable()
    }
    
    func updateTable() {
        dayForecastTable.reloadData()
        
        if dayForecastTable.visibleCells.count != 0 {
            forecastLabel.isHidden = true
        } else {
            forecastLabel.isHidden = false
        }
    }
    
    func updateAll(_ notif: AnyObject) {
        updateData()
    }
    
    func updateForecast(_ notif: AnyObject) {
        updateTable()
    }
    
    // Table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DayForecastCell", for: indexPath) as? DayForecastCell {
            if dataObject.forecasts.count > 0 {                
                let time = dataObject.forecasts[(indexPath as NSIndexPath).row].time
                let icon = dataObject.forecasts[(indexPath as NSIndexPath).row].icon
                let temp = dataObject.forecasts[(indexPath as NSIndexPath).row].temp
                
                cell.configureCell(time, icon: icon, temp: temp)
            } else {
                cell.configureCell("00:00", icon: "sun", temp: "0")
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObject.forecasts.count
    }
}



