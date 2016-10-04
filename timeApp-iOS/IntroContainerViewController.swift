//
//  IntroContainerViewController.swift
//  timeApp-iOS
//
//  Created by dong liang on 10/2/16.
//  Copyright © 2016 kanic. All rights reserved.
//

import UIKit

class IntroContainerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.pageIndicatorTintColor = UIColor(red:0.7, green:0.7, blue:0.7, alpha:0.5)
        pageControl.currentPageIndicatorTintColor = UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0)
        pageControl.isEnabled = false
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "NotFirstTime")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let introPageViewController = segue.destination as? IntroViewController {
            introPageViewController.newDelegate = self
        }
    }
 

}

extension IntroContainerViewController: IntroViewControllerDelegate {
    func IntroViewController(introPageViewController: IntroViewController, didUpdatePageCount count: Int) {
        self.pageControl.numberOfPages = count
    }
    
    func IntroViewController(introPageViewController: IntroViewController, didUpdatePageIndex index: Int) {
        self.pageControl.currentPage = index
    }
}
