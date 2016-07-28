//
//  ViewController.swift
//  timeApp-iOS
//
//  Created by dong liang on 7/21/16.
//  Copyright © 2016 kanic. All rights reserved.
//

import UIKit
import SwiftQRCode

class ViewController: UIViewController {
    let scanner = QRCode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanner.prepareScan(view) { (stringValue) -> () in
            print(stringValue)
        }
        scanner.scanFrame = view.bounds
    }

    override func viewDidAppear(animated: Bool) {
        scanner.startScan()
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
