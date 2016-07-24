//
//  HomeViewController.swift
//  timeApp-iOS
//
//  Created by dong liang on 7/19/16.
//  Copyright © 2016 kanic. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var viewForCamera: UIView!
    @IBOutlet weak var viewForInfo: UIView!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetUp()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        var captureDevice: AVCaptureDevice? = nil
        
        for device in videoDevices{
            let device = device as! AVCaptureDevice
            if device.position == AVCaptureDevicePosition.Back {
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
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
//        videoPreviewLayer?.frame = view.layer.bounds
//        view.layer.addSublayer(videoPreviewLayer!)
        videoPreviewLayer?.frame = viewForCamera.layer.bounds
        viewForCamera.layer.addSublayer(videoPreviewLayer!)
        
        self.viewForCamera.bringSubviewToFront(self.messageLabel)
        
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
        self.viewForCamera.backgroundColor = UIColor.whiteColor()
        self.viewForInfo.backgroundColor = UIColor.whiteColor()
        
        // Info labels
        self.messageLabel.text = "No QR code is detected"
        self.messageLabel.textColor = UIColor.whiteColor()
        
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
            }
        }
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
