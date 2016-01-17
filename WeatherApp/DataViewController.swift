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
    
    var dataObject: Weekday!
    var bgColor: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.view.backgroundColor = UIColor.clearColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateWeekday:", name: "onReceivedWeather", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateForecast:", name: "onReceivedForecast", object: nil);
        
        dayForecastTable.delegate = self
        dayForecastTable.dataSource = self
        dayForecastTable.backgroundColor = UIColor.clearColor()        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
        
    }
    
    func updateWeekday(notif: AnyObject) {
        updateData()
    }
    
    func updateData() {
        self.dayLabel!.text = dataObject.title
        self.tempLabel.text = "\(dataObject.temperature)"
        self.iconImg.image = UIImage(named: dataObject.icon)
        dayForecastTable.reloadData()
    }
    
    func updateForecast(notif: AnyObject) {
        dayForecastTable.reloadData()        
    }
    
    
    // Table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("DayForecastCell", forIndexPath: indexPath) as? DayForecastCell {
            if dataObject.forecasts.count > 0 {                
                let time = dataObject.forecasts[indexPath.row].time
                let icon = dataObject.forecasts[indexPath.row].icon
                let temp = dataObject.forecasts[indexPath.row].temp
                
                cell.configureCell(time, icon: icon, temp: temp)
            } else {
                cell.configureCell("00:00", icon: "sun", temp: "0")
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObject.forecasts.count
    }
}



