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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.dayLabel!.text = dataObject.title
        updateData()
//        iconImg.image = invertImage(iconImg.image!)
    }
    
    func updateWeekday(notif: AnyObject) {
        updateData()
    }
    
    func updateData() {
        
    }
    
    
    // Table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("DayForecastCell", forIndexPath: indexPath) as? DayForecastCell {
            
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
}



