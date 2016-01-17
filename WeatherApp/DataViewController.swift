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
        self.tempLabel.text = "\(dataObject.temperature) °C"
        self.iconImg.image = UIImage(named: dataObject.icon)
    }
    
    
    // Table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("DayForecastCell", forIndexPath: indexPath) as? DayForecastCell {
            cell.alpha = 0
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
        return 5
    }
    
    // TODO: find the correct value for maxY so that alpha returns 0-1
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print(dayForecastTable.visibleCells.count)
        for cell in dayForecastTable.visibleCells as! [DayForecastCell] {
            var point = dayForecastTable.convertPoint(cell.center, toView: dayForecastTable.superview)
            //print(dayForecastTable.bounds.maxY)
            //cell.alpha = ((point.y * 100) / dayForecastTable.bounds.maxY) / 100
            //cell.weatherLbl.text = "\(cell.alpha)"
        }
    }
}



