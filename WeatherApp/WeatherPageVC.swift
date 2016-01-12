//
//  WeatherPageVC.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-11.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import UIKit

class WeatherPageVC: UIPageViewController, UIScrollViewDelegate {

    var parentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for v in self.view.subviews{
            if v.isKindOfClass(UIScrollView){
                (v as! UIScrollView).delegate = self
            }
        }
    }
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        // snapped = 375, left = 0, right = 750
        print(scrollView.contentOffset)
        
        let array = [UIColor.lightGrayColor(), UIColor.orangeColor()]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        if scrollView.contentOffset.x == 750.0 || scrollView.contentOffset.x == 0.0 {
            print("change color")
            var color: UIColor!
            if parentView.backgroundColor == UIColor.orangeColor() {
                color = UIColor.lightGrayColor()
            } else {
                color = UIColor.orangeColor()
            }
            parentView.backgroundColor = color
            self.view.backgroundColor = color
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
