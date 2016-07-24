//
//  ViewController.swift
//  timeApp-iOS
//
//  Created by dong liang on 7/21/16.
//  Copyright © 2016 kanic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    weak var message:UILabel?
    weak var viewCamera: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var a: UIButton!
        a = UIButton(type: UIButtonType.System)
        a.setTitle("haha", forState: UIControlState.Normal)
        a.translatesAutoresizingMaskIntoConstraints = false
        a.backgroundColor = UIColor.blackColor()
        view.addSubview(a)
//        let margins = view.layoutMarginsGuide
        
//        a.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
//        a.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
//        a.heightAnchor.constraintEqualToAnchor(a.widthAnchor, multiplier: 2.0)
        
        
        let leftConstraint = NSLayoutConstraint(item: a, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0)
        leftConstraint.active = true
        let rightConstraint = NSLayoutConstraint(item: a, attribute: NSLayoutAttribute.RightMargin, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0)
        rightConstraint.active = true
        let bottomConstrait = NSLayoutConstraint(item: a, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 20.0)
        bottomConstrait.active = true
        
        view.addConstraints([leftConstraint, rightConstraint, bottomConstrait])
    }
    
    var flag: Bool = false
    func buttonPress() {
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
