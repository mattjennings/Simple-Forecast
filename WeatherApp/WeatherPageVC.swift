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
        let sx = scrollView.contentOffset.x
        var percentage = 0.0
        
        // Percentage of view scrolled
        if sx >= 0.0 && sx < 375.0 {
            percentage = (Double(sx) / 375) * -100
        } else if sx > 375.0 && sx <= 750.0 {
            percentage = ((375 - Double(sx)) / 750) * -200
        } else {
            percentage = 100
        }
        
//        parentView.backgroundColor = blendColor(self.view.backgroundColor!, secondColor: UIColor.blueColor(), percent: CGFloat(percentage))
        
        

        var nextIndex: Int = clamp(DataService.currentIndex-1 + Int(1*sign(percentage)), lower: 0, upper: DataService.weekdays.count-1)
        var currentIndex: Int = clamp(DataService.currentIndex-1, lower: 0, upper: DataService.weekdays.count-1)
        print(nextIndex)
        parentView.backgroundColor = blendColor(DataService.weekdays[currentIndex].bgColor, secondColor: DataService.weekdays[nextIndex].bgColor, percent: CGFloat(percentage))
//        self.view.backgroundColor = parentView.backgroundColor
    }
    
    func blendColor(firstColor: UIColor, secondColor: UIColor, percent: CGFloat) -> UIColor {
        var difference = [CGFloat](count: 3, repeatedValue: 0.0) //RGB
        //var color = UIColor!
        
        
        difference[0] = (firstColor.coreImageColor!.red) - (secondColor.coreImageColor!.red)
        difference[1] = (firstColor.coreImageColor!.green) - (secondColor.coreImageColor!.green)
        difference[2] = (firstColor.coreImageColor!.blue) - (secondColor.coreImageColor!.blue)
        
        print(difference[0])
        print(difference[1])
        print(difference[2])
        
        let r: CGFloat = clamp(firstColor.coreImageColor!.red + (difference[0] * percent/100), lower: 0.0, upper: 1.0)
        let g: CGFloat = clamp(firstColor.coreImageColor!.green + (difference[1] * percent/100), lower: 0.0, upper: 1.0)
        let b: CGFloat = clamp(firstColor.coreImageColor!.blue + (difference[0] * percent/100), lower: 0.0, upper: 1.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 1)
        
        return color
    }
    
    func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
        return min(max(value, lower), upper)
    }
    
    func sign(num: Double) -> Double {
        if num > 0 {
            return 1
        } else if num < 0 {
            return -1
        } else {
            return 0
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


extension UIColor {
    var coreImageColor: CoreImage.CIColor? {
        return CoreImage.CIColor(color: self)  // The resulting Core Image color, or nil
    }
}
