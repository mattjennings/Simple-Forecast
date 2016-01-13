//
//  DataViewController.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-11.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: Weekday = Weekday()
    var bgColor: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject.title
        //print(dataObject.index)
        /*
        let array = [
                    UIColor(red: 52, green: 152, blue: 219, alpha: 1),
                    UIColor(red: 155, green: 89, blue: 182, alpha: 1),
                    UIColor(red: 39, green: 174, blue: 96, alpha: 1),
                    UIColor(red: 241, green: 196, blue: 15, alpha: 1)
                    ]
        print(dataObject)
*/
    
        //self.view.backgroundColor = dataObject.bgColor
        
    }


}

