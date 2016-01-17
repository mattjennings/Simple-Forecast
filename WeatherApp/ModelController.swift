//
//  ModelController.swift
//  WeatherApp
//
//  Created by Matt Jennings on 2016-01-11.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class ModelController: NSObject, UIPageViewControllerDataSource {

    var pageData: [Weekday] = []


    override init() {
        super.init()
        // Create the data model.
        pageData = DataService.instance.weekdays

        // Re-organize Weekdays so that the current day is index 0
        if let dayOfWeek = getDayOfWeek() {
            for index in 1...dayOfWeek-1 {
                //print("moving \(DataService.instance.weekdays[index].title)")
                DataService.instance.weekdays.append(DataService.instance.weekdays.dequeue()!)
                //print("new day: \(DataService.instance.weekdays[0].title)")
            }
        }
        
        DataService.instance.getForecast { () -> () in
            print("complete")
        }
    }
    
    func getDayOfWeek() -> Int? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "e"
        let dayOfWeekString = dateFormatter.stringFromDate(NSDate())
        return (Int(dayOfWeekString))
    }

    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> DataViewController? {
        // Return the data view controller for the given index.
        if (self.pageData.count == 0) || (index >= self.pageData.count) {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewControllerWithIdentifier("DataViewController") as! DataViewController
        dataViewController.dataObject = self.pageData[index]
        return dataViewController
    }

    func indexOfViewController(viewController: DataViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        return pageData.indexOf(viewController.dataObject) ?? NSNotFound
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        
        // For some reason the index value is not proper (in relation to DataService.[Weekday]) when read after the index--
        // this method came with the template provided by Xcode 7... not experienced enough to know why
        DataService.instance.currentIndex = index
        if (index == 0) || (index == NSNotFound) {
            return nil
        }

        index--
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        DataService.instance.currentIndex = index
        if index == NSNotFound {
            return nil
        }
        
        index++
        if index == self.pageData.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

}

