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
    @IBOutlet weak var viewForInfo: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var totalHourLabel: UILabel!
    @IBOutlet weak var staticMessageLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var iPadImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var clockImageView: UIImageView!
    
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        UISetUp()
        self.logoImageView.hidden = true
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        var captureDevice: AVCaptureDevice? = nil
        
        for device in videoDevices{
            let device = device as! AVCaptureDevice
            if device.position == AVCaptureDevicePosition.Front {
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
//        captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
//        let size = self.view.bounds.size
//        let cropRect = CGRectMake(40, 100, 240, 240)
//        captureMetadataOutput.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
//                                                          cropRect.origin.x/size.width,
//                                                          cropRect.size.height/size.height,
//                                                          cropRect.size.width/size.width)
//        captureMetadataOutput.rectOfInterest =
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
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
        
        if previewLayerConnection.supportsVideoOrientation {
            switch (UIApplication.sharedApplication().statusBarOrientation)
            {
            case UIInterfaceOrientation.LandscapeLeft:
                orientation = AVCaptureVideoOrientation.LandscapeLeft
            case UIInterfaceOrientation.LandscapeRight:
                orientation = AVCaptureVideoOrientation.LandscapeRight
            case UIInterfaceOrientation.Unknown:
                orientation = nil
            default:
                orientation = AVCaptureVideoOrientation.LandscapeLeft
            }
            
            if let orientation = orientation {
                previewLayerConnection.videoOrientation = orientation
            }
        }
        
//        if previewLayerConnection.supportsVideoMirroring {
//            previewLayerConnection.videoMirrored = true
//        }
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
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
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeRight
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    // rotate video orientation when main view rotated
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext) in
            let orientation = UIApplication.sharedApplication().statusBarOrientation
            if orientation == UIInterfaceOrientation.LandscapeLeft {
                self.videoPreviewLayer!.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft
            } else {
                self.videoPreviewLayer!.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeRight
            }
            }, completion: nil)
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    // UI set up
    func UISetUp() {
        // Set two placeholder views' attribute
        self.viewForCamera.backgroundColor = UIColor.greenColor()
        self.viewForInfo.layer.backgroundColor = UIColor(red:0.18, green:0.73, blue:0.84, alpha:1.0).CGColor
        self.viewForInfo.hidden = true
        self.viewForInfo.layer.cornerRadius = 15

        // Labels and image views
        self.nameLabel.hidden = true
        self.nameLabel.textColor = UIColor.whiteColor()
        self.nameLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
        
        self.teamLabel.hidden = true
        self.teamLabel.textColor = UIColor.whiteColor()
        self.teamLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
        
        self.clockLabel.hidden = true
        self.clockLabel.textColor = UIColor.whiteColor()
        self.clockLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
        
        self.totalHourLabel.hidden = true
        self.totalHourLabel.textColor = UIColor.whiteColor()
        self.totalHourLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
        
        self.staticMessageLabel.backgroundColor = UIColor.whiteColor()
        self.staticMessageLabel.textColor = UIColor(red:0.22, green:0.72, blue:0.62, alpha:1.0)
        self.staticMessageLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        self.staticMessageLabel.text = "Please scan your QR code"
        
        self.alertLabel.hidden = true
        self.alertLabel.layer.backgroundColor = UIColor(red:0.18, green:0.73, blue:0.84, alpha:1.0).CGColor
        self.alertLabel.layer.cornerRadius = 15
        self.alertLabel.textColor = UIColor.whiteColor()
        self.alertLabel.text = "Success!"
        
        
        self.logoImageView.image = UIImage(named: "zahn")
        self.iPadImageView.image = UIImage(named: "ipad")
        self.checkImageView.image = UIImage(named: "check")
        self.clockImageView.image = UIImage(named: "clock3")
        self.clockImageView.image = self.clockImageView.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.clockImageView.tintColor = UIColor.whiteColor()
        self.checkImageView.hidden = true
        
        
//        heImageView.image = theImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
//        theImageView.tintColor = UIColor.redColor()

    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                self.qrCodeFrameView?.frame = barCodeObject.bounds;
                print(metadataObj.stringValue)
                let hud = MBProgressHUD.showHUDAddedTo(self.viewForCamera, animated: true)
                hud.labelText = "Processing"
                self.captureSession?.stopRunning()
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                    // Wait for 4 seconds so that user can see their info
                    NSThread.sleepForTimeInterval(4)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.captureSession?.startRunning()
                        MBProgressHUD.hideHUDForView(self.viewForCamera, animated: true)
                        self.qrCodeFrameView?.frame = CGRectZero
                        self.hiddenAllComponents()
                        self.staticMessageLabel.hidden = false
                        self.iPadImageView.hidden = false
                    })
                })
                
                // Create a session on server
                let parameters = ["qr_code_string": metadataObj.stringValue]
                let headers = ["Authorization": "JWT \(TimeClient.sharedInstance.AccessToken!)"]
                TimeClient.sharedInstance.CheckInAndOutAPI("session-create", parameters: parameters, headers: headers, success: { (json) in
                    print(json)
                    let session = Session(dictionary: json)
                    if session.isActive! {
                        self.totalHourLabel.hidden = true
                        self.clockLabel.text = "\((session.signInTime)!)"
                        self.viewForInfo.layer.backgroundColor = UIColor(red:0.18, green:0.73, blue:0.84, alpha:1.0).CGColor
                        self.alertLabel.layer.backgroundColor = UIColor(red:0.18, green:0.73, blue:0.84, alpha:1.0).CGColor
                    } else {
                        self.totalHourLabel.text = "You've been in for \(NSString(format: "%.1f", session.total_minutes!/60)) hours"
                        self.totalHourLabel.hidden = false
                        self.clockLabel.text = "\((session.signOutTime)!)"
                        self.viewForInfo.layer.backgroundColor = UIColor(red:1.00, green:0.23, blue:0.42, alpha:1.0).CGColor
                        self.alertLabel.layer.backgroundColor = UIColor(red:1.00, green:0.23, blue:0.42, alpha:1.0).CGColor
                    }
                    if let team = session.team {
                        self.teamLabel.text = team
                        self.teamLabel.hidden = false
                    }
                    self.iPadImageView.hidden = true
                    self.staticMessageLabel.hidden = true
                    self.checkImageView.hidden = false
                    self.viewForInfo.hidden = false
                    self.nameLabel.text = session.user
                    self.nameLabel.hidden = false
                    self.alertLabel.hidden = false
                    self.clockLabel.hidden = false
                    self.staticMessageLabel.hidden = true
                    }, failure: {
                        print("error in check in and out in HomeViewController")
                })
            }
        }
    }

    func hiddenAllComponents() {
        self.alertLabel.hidden = true
        self.nameLabel.hidden = true
        self.teamLabel.hidden = true
        self.clockLabel.hidden = true
        self.totalHourLabel.hidden = true
        self.checkImageView.hidden = true
        self.viewForInfo.hidden = true
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
