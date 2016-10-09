//
//  IntroViewController.swift
//  timeApp-iOS
//
//  Created by dong liang on 10/2/16.
//  Copyright © 2016 kanic. All rights reserved.
//

import UIKit

class IntroViewController: UIPageViewController {

    let orderedViewControllers: [UIViewController] = {
        return [IntroViewController.newOrderedViewController("first"), IntroViewController.newOrderedViewController("second"), IntroViewController.newOrderedViewController("third")]
    }()
    weak var newDelegate: IntroViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        self.newDelegate?.IntroViewController(introPageViewController: self, didUpdatePageCount: orderedViewControllers.count)
        if let firstViewController = self.orderedViewControllers.first {
            setViewControllers([firstViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static func newOrderedViewController(_ order: String) -> UIViewController {
        return EachIntroViewController(name: order)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension IntroViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = self.viewControllers?.first, let index = orderedViewControllers.index(of: firstViewController) {
            newDelegate?.IntroViewController(introPageViewController: self, didUpdatePageIndex: index)
        }
    }
}

protocol IntroViewControllerDelegate: class {
    func IntroViewController(introPageViewController: IntroViewController, didUpdatePageCount count: Int)
    
    func IntroViewController(introPageViewController: IntroViewController, didUpdatePageIndex index: Int)
}

