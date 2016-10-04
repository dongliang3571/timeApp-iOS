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
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var brandName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UISetUp() {
        
        let view_width = self.view.bounds.width
        let view_height = self.view.bounds.height
        
        self.backgroundImage.image = UIImage(named: "login_bg")
        
        
        
        let origin_loginView = CGPoint(x: self.view.bounds.width/2.0 - self.loginView.bounds.width/2.0, y: view.bounds.height/2.0 - self.loginView.bounds.height/2.0)
        self.loginView.frame.origin = origin_loginView
        self.loginView.backgroundColor = UIColor.white
        self.loginView.layer.shadowColor = UIColor.gray.cgColor
        self.loginView.layer.shadowOpacity = 0.5
        self.loginView.layer.shadowOffset = CGSize.zero
        self.loginView.layer.shadowRadius = 3
        
        self.brandName.bounds.size = CGSize(width: 200.0, height: 60.0)
        let originX_brandName = view_width/2.0 - self.brandName.bounds.width/2.0
        let originY_brandName = self.loginView.frame.origin.y - self.brandName.bounds.height
        self.brandName.font = UIFont(name:"HelveticaNeue-Bold", size: 50.0)
        self.brandName.frame = CGRect(origin: CGPoint(x: originX_brandName, y: originY_brandName), size: self.brandName.bounds.size)
        
        
        self.usernameField.text = "dong"
        self.passwordField.text = "123"
        self.navigationController?.isNavigationBarHidden = true
        self.usernameField.placeholder = "Username"
        self.passwordField.placeholder = "Password"

        self.logInButton.backgroundColor = UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0)
        self.logInButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.logInButton.addTarget(self, action: #selector(self.logInButtonPressed), for: UIControlEvents.touchUpInside)
    }
    
    func logInButtonPressed(_ sender: AnyObject) {
        let username = usernameField.text
        let password = passwordField.text
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Signing in..."
        
        TimeClient.sharedInstance.fetchToken("token-auth", username: username!, password: password!, success: {
            let defaults = UserDefaults.standard
            let first = defaults.bool(forKey: "NotFirstTime")
            if first == true {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                MBProgressHUD.hide(for: self.view, animated: true)
                print("go to scan")
            } else {
                self.performSegue(withIdentifier: "intro", sender: self)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            }, failure: { (error1, error2) in
                if let error1 = error1 {
                    print(error1)
                    let alert = UIAlertController(title: "Error", message: "An unexpected error happened, try again later", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    MBProgressHUD.hide(for: self.view, animated: true)
                } else if error2 != nil {
                    let alert = UIAlertController(title: "Invalid Credential", message: "Your username or password does not match", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    MBProgressHUD.hide(for: self.view, animated: true)
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
