//
//  LogInViewController.swift
//  timeApp-iOS
//
//  Created by dong liang on 7/23/16.
//  Copyright © 2016 kanic. All rights reserved.
//

import UIKit
import MBProgressHUD

class LogInViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetUp()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UISetUp() {
        self.navigationController?.navigationBarHidden = true
        self.usernameField.placeholder = "Username"
        self.passwordField.placeholder = "Password"
        self.logInButton.addTarget(self, action: #selector(self.logInButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
    }
    
    func logInButtonPressed(sender: AnyObject) {
        let username = usernameField.text
        let password = passwordField.text
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Sending request..."
        
        TimeClient.sharedInstance.fetchToken("token-auth", username: username!, password: password!, success: {
            self.performSegueWithIdentifier("loginSegue", sender: self)
            }, failure: { (error1, error2) in
                if let error1 = error1 {
                    print(error1)
                    let alert = UIAlertController(title: "Error", message: "An unexpected error happened", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                } else if error2 != nil {
                    let alert = UIAlertController(title: "Invalid Credential", message: "Your username or password does not match", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
        })
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
