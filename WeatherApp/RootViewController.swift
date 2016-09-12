//
//  RootViewController.swift
//  PageBasedApplication
//
//  Created by Matt Jennings on 2016-01-11.
//  Copyright © 2016 Matt Jennings. All rights reserved.
//

import UIKit
import MapKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {
    
    var pageViewController: WeatherPageVC?
    
    @IBOutlet weak var viewFrame: UIView!        
    @IBOutlet weak var cityLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set status bar to light
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = WeatherPageVC(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController!.delegate = self
        
        let startingViewController: DataViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
        
        self.pageViewController!.dataSource = self.modelController
        //self.pageViewController!.delegate = self
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        
        var pageViewRect = self.view.frame
        if UIDevice.current.userInterfaceIdiom == .pad {
        pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
        }
        self.pageViewController!.view.frame = pageViewRect

        
        self.pageViewController!.didMove(toParentViewController: self)
        
        
        self.pageViewController!.parentView = self.view
        self.pageViewController!.rootViewController = self
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
        
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.updateData(_:)), name: NSNotification.Name(rawValue: "onReceivedReload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.updateData(_:)), name: NSNotification.Name(rawValue: "onReceivedWeather"), object: nil)
    }
    
    func updateData(_ notif: Notification) {
        updateLabel()
    }
    
    func updateLabel() {
        let city = DataService.instance.city!
        let country = DataService.instance.country!
        cityLabel.text = "\(city), \(country)"
    }

    override func viewDidLayoutSubviews() {
        // After constraints are applied
        self.pageViewController!.view.frame = viewFrame.frame
        
    }
    
    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
        }
        return _modelController!
    }
    
    var _modelController: ModelController? = nil
    
    
    // MARK: - UIPageViewController delegate methods
    
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        //if (orientation == .Portrait) || (orientation == .PortraitUpsideDown) || (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
            let currentViewController = self.pageViewController!.viewControllers![0]
            let viewControllers = [currentViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
            
            self.pageViewController!.isDoubleSided = false
            return .min    
    }
    
}

