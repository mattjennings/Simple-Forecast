//
//  WeatherPageVC.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-11.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class WeatherPageVC: UIPageViewController, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    var rootViewController: RootViewController!
    var parentView: UIView!
    var viewWidth: CGFloat!
    
    var scrollPercentage: CGFloat = 0
    var lastScrollPercentage: CGFloat = 0
    var currentIndex: Int = 0
    var nextIndex: Int = 0
    var scrollDirection: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the scroll view
        for v in self.view.subviews{
            if v.isKind(of: UIScrollView.self){
                (v as! UIScrollView).delegate = self
            }
        }
        
        self.delegate = self
        viewWidth = self.view.bounds.width
        
        // If DataService.instance.weekdays was updated/rearranged
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherPageVC.updateDataVC(_:)), name: NSNotification.Name(rawValue: "onReceivedReload"), object: nil);
        
        // On orientation change
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherPageVC.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parentView.backgroundColor = DataService.instance.weekdays[0].bgColor
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]?) {
// Local variable inserted by Swift 4.2 migrator.
let options = convertFromOptionalUIPageViewControllerOptionsKeyDictionary(options)

        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: convertToOptionalUIPageViewControllerOptionsKeyDictionary(options))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func rotated() {
        updateCurrentIndex()
    }
    
    
    @objc func updateDataVC(_ notif: Notification) {
        
        if let vc = rootViewController.modelController.viewControllerAtIndex(0, storyboard: rootViewController.storyboard!) {
            let v = [vc]
            setViewControllers(v, direction: UIPageViewController.NavigationDirection.reverse, animated: false, completion: nil)
            let dvc = v[0]            
            parentView.backgroundColor = dvc.dataObject.bgColor
            currentIndex = 0
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if sign(scrollPercentage) > 0 && currentIndex < DataService.instance.weekdays.count-1 {
            nextIndex = currentIndex + 1
        } else if sign(scrollPercentage) < 0 && currentIndex > 0 {
            nextIndex = currentIndex - 1
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        updateCurrentIndex()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
        
        // 1 = original direction, -1 = opposite of original direction
        scrollDirection = sign(scrollPercentage - lastScrollPercentage)
        
        
        // this prevents the colors from messing up when rapidly swiping back and forth between 2 views
        if scrollDirection == -1 {
            updateCurrentIndex()
        }
        
        // Reverse equation if percentage is -
        if abs(scrollPercentage) > 0 && abs(scrollPercentage) < 100 {
            if sign(scrollPercentage) > 0 {
                parentView.backgroundColor = blendColor(DataService.instance.weekdays[currentIndex].bgColor, secondColor: DataService.instance.weekdays[nextIndex].bgColor, percent: CGFloat(scrollPercentage/100))
            } else if sign(scrollPercentage) < 0 {
                parentView.backgroundColor = blendColor(DataService.instance.weekdays[nextIndex].bgColor, secondColor: DataService.instance.weekdays[currentIndex].bgColor, percent: CGFloat(scrollPercentage/100))
            }
        }
        
        lastScrollPercentage = scrollPercentage
        
    }
    
    func updateCurrentIndex() {
        if let dvc = self.viewControllers as? [DataViewController] {
            let actualIndex = rootViewController.modelController.indexOfViewController(dvc[0])
            currentIndex = actualIndex
        }
    }
    
    func blendColor(_ firstColor: UIColor, secondColor: UIColor, percent: CGFloat) -> UIColor {
        var difference = [CGFloat](repeating: 0.0, count: 3) //RGB
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
    
    func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
        return min(max(value, lower), upper)
    }
    
    func sign(_ num: CGFloat) -> Int {
        if num > 0 {
            return 1
        } else if num < 0 {
            return -1
        } else {
            return 0
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromOptionalUIPageViewControllerOptionsKeyDictionary(_ input: [UIPageViewController.OptionsKey: Any]?) -> [String: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalUIPageViewControllerOptionsKeyDictionary(_ input: [String: Any]?) -> [UIPageViewController.OptionsKey: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIPageViewController.OptionsKey(rawValue: key), value)})
}
