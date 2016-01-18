//
//  WeatherPageVC.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-11.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import UIKit


class WeatherPageVC: UIPageViewController, UIPageViewControllerDelegate, UIScrollViewDelegate {

    var rootViewController: RootViewController!
    var parentView: UIView!
    var viewWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the scroll view
        for v in self.view.subviews{
            if v.isKindOfClass(UIScrollView){
                (v as! UIScrollView).delegate = self
            }
        }
        
        viewWidth = self.view.bounds.width
        
        // If DataService.instance.weekdays was updated/rearranged
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateDataVC:", name: "onReceivedReload", object: nil);
    }
    
    override func viewWillAppear(animated: Bool) {
        parentView.backgroundColor = DataService.instance.weekdays[0].bgColor
    }

    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    func updateDataVC(notif: NSNotification) {
        
        if let vc = rootViewController.modelController.viewControllerAtIndex(getDayOfWeek()!-2, storyboard: rootViewController.storyboard!) as? UIViewController {
            let v = [vc]
            setViewControllers(v, direction: UIPageViewControllerNavigationDirection.Reverse, animated: false, completion: nil)
            if let dvc = v[0] as? DataViewController {
                parentView.backgroundColor = dvc.dataObject.bgColor
            }
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let sx: CGFloat = CGFloat(scrollView.contentOffset.x)
        var percentage: CGFloat = 0.0
        
        // Percentage of view scrolled
        if sx > 0.0 && sx < viewWidth {
            percentage = (sx / viewWidth) * CGFloat(-100)
        } else if sx > viewWidth && sx < viewWidth * 2 {
            percentage = ((viewWidth - sx) / viewWidth) * -100
        } else {
            if sx == 0.0 {
                percentage = -100
            } else if sx == viewWidth * 2 {
                percentage = 100
            }
        }
        
        // Indexes
        let currentIndex: Int = clamp(DataService.instance.currentIndex, lower: 0, upper: DataService.instance.weekdays.count-1)
        let nextIndex: Int = clamp(DataService.instance.currentIndex + Int(1*sign(percentage)), lower: 0, upper: DataService.instance.weekdays.count-1)
                
        // Reverse equation if percentage is -
        if abs(percentage) < 100 {
            if sign(percentage) > 0 {
                parentView.backgroundColor = blendColor(DataService.instance.weekdays[currentIndex].bgColor, secondColor: DataService.instance.weekdays[nextIndex].bgColor, percent: CGFloat(percentage/100))
            } else if sign(percentage) < 0 {
                parentView.backgroundColor = blendColor(DataService.instance.weekdays[nextIndex].bgColor, secondColor: DataService.instance.weekdays[currentIndex].bgColor, percent: CGFloat(percentage/100))
            }
        }
    }
    
    func blendColor(firstColor: UIColor, secondColor: UIColor, percent: CGFloat) -> UIColor {
        var difference = [CGFloat](count: 3, repeatedValue: 0.0) //RGB
        let perc = abs(percent)

        difference[0] = (firstColor.coreImageColor!.red) - (secondColor.coreImageColor!.red)
        difference[1] = (firstColor.coreImageColor!.green) - (secondColor.coreImageColor!.green)
        difference[2] = (firstColor.coreImageColor!.blue) - (secondColor.coreImageColor!.blue)
        
        let r: CGFloat = clamp(secondColor.coreImageColor!.red + (difference[0]) - (difference[0] * perc), lower: 0.0, upper: 1.0)
        let g: CGFloat = clamp(secondColor.coreImageColor!.green + (difference[1]) - (difference[1] * perc), lower: 0.0, upper: 1.0)
        let b: CGFloat = clamp(secondColor.coreImageColor!.blue + (difference[2]) - (difference[2] * perc), lower: 0.0, upper: 1.0)

        let color = UIColor(red: r, green: g, blue: b, alpha: 1)
        
        return color
    }
    
    func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
        return min(max(value, lower), upper)
    }
    
    func sign(num: CGFloat) -> Int {
        if num > 0 {
            return 1
        } else if num < 0 {
            return -1
        } else {
            return 0
        }
    }
}

