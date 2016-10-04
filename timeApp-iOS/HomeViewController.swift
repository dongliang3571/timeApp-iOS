//
//  HomeViewController.swift
//  timeApp-iOS
//
//  Created by dong liang on 7/19/16.
//  Copyright © 2016 kanic. All rights reserved.
//

import UIKit
import AVFoundation
import MBProgressHUD

class HomeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var viewForCamera: UIView!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var totalHourLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var staticLabel: UILabel!
    @IBOutlet weak var successImage: UIImageView!
    @IBOutlet weak var hoursImage: UIImageView!
    @IBOutlet weak var signInAndOutTextLabel: UILabel!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        UISetUp()
//        self.logoImageView.hidden = true
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let videoDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        var captureDevice: AVCaptureDevice? = nil
        
        for device in videoDevices!{
            let device = device as! AVCaptureDevice
            if device.position == AVCaptureDevicePosition.front {
                captureDevice = device
                break
            }
        }
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        let input: AnyObject! = try? AVCaptureDeviceInput(device: captureDevice)
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as? AVCaptureInput)
        
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
//        videoPreviewLayer?.frame = view.layer.bounds
//        view.layer.addSublayer(videoPreviewLayer!)
        videoPreviewLayer?.frame = viewForCamera.bounds
        viewForCamera.layer.addSublayer(videoPreviewLayer!)
        
        var orientation: AVCaptureVideoOrientation?
        let previewLayerConnection = self.videoPreviewLayer!.connection
        
        if (previewLayerConnection?.isVideoOrientationSupported)! {
            switch (UIApplication.shared.statusBarOrientation)
            {
            case UIInterfaceOrientation.landscapeLeft:
                orientation = AVCaptureVideoOrientation.landscapeLeft
            case UIInterfaceOrientation.landscapeRight:
                orientation = AVCaptureVideoOrientation.landscapeRight
            case UIInterfaceOrientation.unknown:
                orientation = nil
            default:
                orientation = AVCaptureVideoOrientation.landscapeLeft
            }
            
            if let orientation = orientation {
                previewLayerConnection?.videoOrientation = orientation
            }
        }
        
//        if previewLayerConnection.supportsVideoMirroring {
//            previewLayerConnection.videoMirrored = true
//        }
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        self.viewForCamera.addSubview(qrCodeFrameView!)
//        self.viewForCamera.bringSubviewToFront(qrCodeFrameView!)
        
        // Start video capture.
        captureSession?.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Be able to rotate the screen
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    // rotate video orientation when main view rotated
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext) in
            let orientation = UIApplication.shared.statusBarOrientation
            if orientation == UIInterfaceOrientation.landscapeLeft {
                self.videoPreviewLayer!.connection.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            } else {
                self.videoPreviewLayer!.connection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
            }
            }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // UI set up
    func UISetUp() {
        // Set two placeholder views' attribute
        let view_width = self.view.bounds.width
        let view_height = self.view.bounds.height
        let originX = CGFloat(0.0)
        let originY = CGFloat(20.0)
        let sizeX = view_width*4.5/10.0
        let sizeY = view_height - originY
        
        self.viewForCamera.frame = CGRect(origin: CGPoint(x: originX, y: originY), size: CGSize(width: sizeX, height: sizeY))

        // Labels and image views
        self.logOutButton.backgroundColor = UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0)
        self.logOutButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.logOutButton.layer.cornerRadius = 10.0
        self.logOutButton.addTarget(self, action: #selector(self.logoutButtonClicked), for: UIControlEvents.touchUpInside)
        
        self.staticLabel.sizeToFit()
        let originX_staticLabel = sizeX + (view_width - sizeX)/2.0 - self.staticLabel.bounds.width/2.0
        let originY_staticLabel = view_height/2.0
        self.staticLabel.font = UIFont(name: "Avenir", size: 20.0)
        self.staticLabel.text = "Please scan your QR code"
        self.staticLabel.sizeToFit()
        self.staticLabel.textColor = UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0)
        self.staticLabel.frame = CGRect(origin: CGPoint(x: originX_staticLabel, y: originY_staticLabel), size: self.staticLabel.bounds.size)
        
        self.successImage.bounds.size = CGSize(width: view_width*2.0/10.0, height: view_width*2.0/10.0)
        let originX_successImage = sizeX + (view_width - sizeX)/2.0 - self.successImage.bounds.width/2.0
        let originY_successImage = view_height/2.0 - self.successImage.bounds.height/2.0
        self.successImage.image = UIImage(named: "Oval_check")
        self.successImage.frame = CGRect(origin: CGPoint(x: originX_successImage, y: originY_successImage), size: self.successImage.bounds.size)
        self.successImage.alpha = 0.0
        
        self.hoursImage.bounds.size = CGSize(width: view_width*2.0/10.0, height: view_width*2.0/10.0)
        self.hoursImage.image = UIImage(named: "Oval_1")
        let originX_hourImage = sizeX + (view_width - sizeX)/2.0
        let originY_hourImage = view_height/2.0 - self.hoursImage.bounds.height/2.0
        self.hoursImage.frame = CGRect(origin: CGPoint(x: originX_hourImage, y: originY_hourImage), size: self.hoursImage.bounds.size)
        self.hoursImage.alpha = 0.0
        
        
        self.totalHourLabel.alpha = 0.0
        self.totalHourLabel.textColor = UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0)
        self.totalHourLabel.font = UIFont(name:"Avenir", size: 20.0)
        
        
        self.signInAndOutTextLabel.text = "Hi Dong Liang, you've signed in!"
        self.signInAndOutTextLabel.sizeToFit()
        let originX_signInAndOutTextLabel = sizeX + (view_width - sizeX)/2.0 - self.signInAndOutTextLabel.bounds.width/2.0
        let originY_signInAndOutTextLabel = originY_successImage + self.successImage.bounds.height + 30
        self.signInAndOutTextLabel.textColor = UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0)
        self.signInAndOutTextLabel.frame = CGRect(origin: CGPoint(x: originX_signInAndOutTextLabel, y: originY_signInAndOutTextLabel), size: self.signInAndOutTextLabel.bounds.size)
        self.signInAndOutTextLabel.alpha = 0.0
        
        self.clockLabel.text = "05:00pm"
        self.clockLabel.sizeToFit()
        self.clockLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
        let originX_clockLabel = sizeX + (view_width - sizeX)/2.0 - self.clockLabel.bounds.width/2.0
        let originY_clockLabel = originY_signInAndOutTextLabel + self.clockLabel.bounds.height + 5
        self.clockLabel.textColor = UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0)
        self.clockLabel.frame = CGRect(origin: CGPoint(x: originX_clockLabel, y: originY_clockLabel), size: self.clockLabel.bounds.size)
        self.clockLabel.alpha = 0.0
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                self.qrCodeFrameView?.frame = barCodeObject.bounds;
                print(metadataObj.stringValue)
                let hud = MBProgressHUD.showAdded(to: self.viewForCamera, animated: true)
                hud.label.text = "Processing"
                self.captureSession?.stopRunning()
                
                // get current time
                let currentDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.current
                dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                let dateString = dateFormatter.string(from: currentDate)
                
                // Create a session on server
                let parameters = ["qr_code_string": metadataObj.stringValue, "time_now": dateString]
                let headers = ["Authorization": "JWT \(TimeClient.sharedInstance.AccessToken!)"]
                TimeClient.sharedInstance.CheckInAndOutAPI("session-create", parameters: parameters as? [String : String], headers: headers, success: { (json) in
                    print(json)
                    if let _ = json["is_active"] {
                        let session = Session(dictionary: json)
                        if session.isActive! {
                            self.moveImageWhenSignIn()
                            self.signInAndOutTextLabel.text = "Hi \(session.user!), you've signed in!"
                            self.signInAndOutTextLabel.sizeToFit()
                            self.clockLabel.text = "\(session.signInTime!)"
                            self.clockLabel.sizeToFit()
                            UIView.animate(withDuration: 2.0, animations: {
                                self.signInAndOutTextLabel.alpha = 1.0
                                self.clockLabel.alpha = 1.0
                                self.staticLabel.alpha = 0.0
                                self.successImage.alpha = 1.0
                                }, completion: { (isComplete) in
                                    self.finishCapture()
                                    UIView.animate(withDuration: 2.5, animations: {
                                        self.signInAndOutTextLabel.alpha = 0.0
                                        self.clockLabel.alpha = 0.0
                                        self.staticLabel.alpha = 1.0
                                        self.successImage.alpha = 0.0
                                    })
                            })
                        } else {
                            self.moveImageWhenSignOut()
                            self.signInAndOutTextLabel.text = "Hi \(session.user!), you've signed out!"
                            self.signInAndOutTextLabel.sizeToFit()
                            UIView.animate(withDuration: 2.0, animations: {
                                self.signInAndOutTextLabel.alpha = 1.0
                                self.clockLabel.alpha = 1.0
                                self.staticLabel.alpha = 0.0
                                self.successImage.alpha = 1.0
                                self.hoursImage.alpha = 1.0
                                }, completion: { (isComplete) in
                                    self.finishCapture()
                                    UIView.animate(withDuration: 2.0, animations: {
                                        self.signInAndOutTextLabel.alpha = 0.0
                                        self.clockLabel.alpha = 0.0
                                        self.staticLabel.alpha = 1.0
                                        self.successImage.alpha = 0.0
                                        self.hoursImage.alpha = 0.0
                                    })
                            })
                            self.finishCapture()
                        }
                    } else {
                        self.finishCapture()
                        self.presentError()
                    }
                    }, failure: {
                        self.finishCapture()
                        self.presentError()
                        print("error in check in and out in HomeViewController")
                })
            }
        }
    }
    
    func logoutButtonClicked() {
        let alert = UIAlertController(title: "Sign out?", message: "Are you sure that you want to sign out?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
        
    }

    private func finishCapture() {
        MBProgressHUD.hide(for: self.viewForCamera, animated: true)
        self.captureSession?.startRunning()
        self.qrCodeFrameView?.frame = CGRect.zero
    }
    
    private func hiddenAllComponents() {
        self.totalHourLabel.isHidden = true
    }
    
    private func moveImageWhenSignIn() {
        let view_width = self.view.bounds.width
        let view_height = self.view.bounds.height
        let sizeX = view_width*4.5/10.0
        
        let originX_successImage = sizeX + (view_width - sizeX)/2.0 - self.successImage.bounds.width/2.0
        let originY_successImage = view_height/2.0 - self.successImage.bounds.height/2.0
        self.successImage.frame = CGRect(origin: CGPoint(x: originX_successImage, y: originY_successImage), size: self.successImage.bounds.size)
    }
    
    private func moveImageWhenSignOut() {
        let view_width = self.view.bounds.width
        let view_height = self.view.bounds.height
        let sizeX = view_width*4.5/10.0
        
        let originX_successImage = sizeX + (view_width - sizeX)/2.0 - self.successImage.bounds.width
        let originY_successImage = view_height/2.0 - self.successImage.bounds.height/2.0
        self.successImage.frame = CGRect(origin: CGPoint(x: originX_successImage, y: originY_successImage), size: self.successImage.bounds.size)
    }
    
    private func presentError() {
        let alert = UIAlertController(title: "Error", message: "An unexpected error happened, try again later", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
