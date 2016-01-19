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
    
    var scrollPercentage: CGFloat = 0
    var currentIndex: Int = 0
    var nextIndex: Int = 0
    var scrollDirection: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the scroll view
        for v in self.view.subviews{
            if v.isKindOfClass(UIScrollView){
                (v as! UIScrollView).delegate = self
            }
        }
        
        self.delegate = self
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
    

    // This is called after the app is reloaded
    func updateDataVC(notif: NSNotification) {
        
        if let vc = rootViewController.modelController.viewControllerAtIndex(getDayOfWeek()!-2, storyboard: rootViewController.storyboard!) as? UIViewController {
            let v = [vc]
            setViewControllers(v, direction: UIPageViewControllerNavigationDirection.Reverse, animated: false, completion: nil)
            if let dvc = v[0] as? DataViewController {
                parentView.backgroundColor = dvc.dataObject.bgColor
            }
        }
        
        if let dvc = self.viewControllers as? [DataViewController] {
            let actualIndex = rootViewController.modelController.indexOfViewController(dvc[0])
            currentIndex = actualIndex
            parentView.backgroundColor = DataService.instance.weekdays[currentIndex].bgColor
        }
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        scrollDirection = sign(scrollPercentage)
        
        // Calculate the next index based on scroll direction
        if scrollDirection > 0 && currentIndex < DataService.instance.weekdays.count-1 {
            nextIndex = currentIndex + 1
        } else if scrollDirection < 0 && currentIndex > 0 {
            nextIndex = currentIndex - 1
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let sx: CGFloat = CGFloat(scrollView.contentOffset.x)
        // Percentage of view scrolled
        if sx > 0.0 && sx < viewWidth {
            scrollPercentage = (sx / viewWidth) * CGFloat(-100)
        } else if sx > viewWidth && sx < viewWidth * 2 {
            scrollPercentage = ((viewWidth - sx) / viewWidth) * -100
        } else {
            if sx == 0.0 {
                scrollPercentage = -100
            } else if sx == viewWidth * 2 {
                scrollPercentage = 100
            }
        }
    
        // Update current index
        if let dvc = self.viewControllers as? [DataViewController] {
            let actualIndex = rootViewController.modelController.indexOfViewController(dvc[0])
            currentIndex = actualIndex
        }
        
        
        // Reverse equation if percentage is -
        if abs(scrollPercentage) > 0 && abs(scrollPercentage) < 100 {
            if sign(scrollPercentage) > 0 {
                parentView.backgroundColor = blendColor(DataService.instance.weekdays[currentIndex].bgColor, secondColor: DataService.instance.weekdays[nextIndex].bgColor, percent: CGFloat(scrollPercentage/100))
            } else if sign(scrollPercentage) < 0 {
                parentView.backgroundColor = blendColor(DataService.instance.weekdays[nextIndex].bgColor, secondColor: DataService.instance.weekdays[currentIndex].bgColor, percent: CGFloat(scrollPercentage/100))
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

