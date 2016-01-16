//
//  DataViewController.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-11.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    
    var dataObject: Weekday!
    var bgColor: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.view.backgroundColor = UIColor.clearColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateWeekdays:", name: "onReceivedWeather", object: nil);
        
        
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
    
    func updateWeekdays(notif: AnyObject) {
        print("update")
        updateData()
    }
    
    func updateData() {
        
    }
}



