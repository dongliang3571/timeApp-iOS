//
//  EachIntroViewController.swift
//  timeApp-iOS
//
//  Created by dong liang on 10/8/16.
//  Copyright © 2016 kanic. All rights reserved.
//

import UIKit

class EachIntroViewController: UIViewController {

    var name: String
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, name viewName: String) {
        self.name = viewName
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(name viewName: String) {
        self.init(nibName: nil, bundle: nil, name: viewName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetUp()
    }
    
    func UISetUp() {
        
        let view_width = self.view.bounds.width
        let view_height = self.view.bounds.height
        
        // creating image view in the middle
        let imageView = UIImageView()
        
        // creating label
        let descriptionLabel = UILabel()
        
        // Calculate components' postion
        imageView.bounds.size = CGSize(width: view_width/4.0, height: view_width/4.0)
        let width_imageView = imageView.bounds.size.width
        let height_imageView = imageView.bounds.size.height
        let origin_x = view_width/2.0 - width_imageView/2.0
        let origin_y = view_height/2.0 - height_imageView/2.0 - 20
        imageView.frame = CGRect(origin: CGPoint(x: origin_x, y: origin_y), size: imageView.bounds.size)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = NSTextAlignment.center
        descriptionLabel.bounds.size = CGSize(width: view_width/3*2, height: view_height/6 + 20)
        let width_description = descriptionLabel.bounds.size.width
        let height_description = descriptionLabel.bounds.size.height
        let origin_x_des = view_width/2.0 - width_description/2.0
        let origin_y_des = view_height/2.0 + height_description/2.0 + 20
        descriptionLabel.frame = CGRect(origin: CGPoint(x: origin_x_des, y: origin_y_des), size: descriptionLabel.bounds.size)
        
        // Different cases
        if self.name == "first" {
            imageView.image = UIImage(named: "pc")
            descriptionLabel.text = "On your admin panel, start by adding your employees. You will have the option to print and email their Qr code cards."
        } else if self.name == "second" {
            imageView.image = UIImage(named: "qr")
            descriptionLabel.text = "Each employee is assigned a specific Qr code. To sign in or out, your employee should scan their Qr code using your device camera."
        } else {
            imageView.image = UIImage(named: "panel")
            descriptionLabel.text = "On your admin panel, your can track attendance and earnings for each specific employee."
            let goodToGoButton = UIButton()
            goodToGoButton.layer.cornerRadius = 10.0
            goodToGoButton.setTitle("You are good to go!", for: UIControlState.normal)
            goodToGoButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            goodToGoButton.backgroundColor = UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0)
            goodToGoButton.bounds.size = CGSize(width: view_width/3.0, height: view_height/10.0)
            let width_goodToGoButton = goodToGoButton.bounds.size.width
            let origin_x_but = view_width/2.0 - width_goodToGoButton/2.0
            let origin_y_but = view_height/8.0*7.0
            goodToGoButton.frame = CGRect(origin: CGPoint(x: origin_x_but, y: origin_y_but), size: goodToGoButton.bounds.size)
            goodToGoButton.addTarget(self, action: #selector(self.buttonClicked), for: UIControlEvents.touchUpInside)
            self.view.addSubview(goodToGoButton)
        }

        // Add them to the view
        self.view.addSubview(imageView)
        self.view.addSubview(descriptionLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonClicked(_ sender: UIButton) {
        let ngc = self.presentingViewController as! UINavigationController
        dismiss(animated: true) {
            ngc.show(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScanView"), sender: ngc)
        }
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
