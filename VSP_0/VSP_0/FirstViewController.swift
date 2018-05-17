//
//  FirstViewController.swift
//  VSP_0
//
//  Created by Steve Lee on 5/16/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController {

    
    @IBOutlet weak var actionButtonOutlet: UIButton!
    //Instances needed for camera.
    let session = AVCaptureSession()
    var deviceCamera: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput: AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*Setting up camera.*/
        //Setting the resolution of the video.
        session.sessionPreset = .high
        //Setting the type of the media.
        deviceCamera = AVCaptureDevice.default(for: AVMediaType.video)
        //Checking if the device has the auto focus mode. If it's not available,
        //so something else.
        if (deviceCamera?.isFocusModeSupported(.continuousAutoFocus))! {
            //Trying to see if lock for configuration is possible.
            do {
                //Setting auto focus.
                //Not sure what this "lock for config is for, but it is necessary
                //before setting a focus mode.
                try deviceCamera?.lockForConfiguration()
                deviceCamera?.focusMode = AVCaptureDevice.FocusMode.continuousAutoFocus
                deviceCamera?.unlockForConfiguration()
            } catch {
                //Lock for configuration is not possible and the continuous auto focus
                //cannot be set.
                print("Cannot set auto focus")
            }
        }
        
        do {
            //Checking to see see if the camera is present and see if it works.
            let cameraCaptureInput = try AVCaptureDeviceInput(device: deviceCamera!)
            //Creating and setting the instances to the global variables.
            cameraCaptureOutput = AVCapturePhotoOutput()
            //Setting things up for session for input and output.
            session.addInput(cameraCaptureInput)
            session.addOutput(cameraCaptureOutput!)
            //Setting up the camera preview layer, which is a uiview like a thingy
            //that shows what the camera is shooting at.
            cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            cameraPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
            cameraPreviewLayer!.frame = view.bounds
            cameraPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            //Setting the camera preview layer on top of the current view.
            view.layer.insertSublayer(cameraPreviewLayer!, at: 2)
        } catch {
            //Print some error message.
        }
        
        //Creating shadows for the action button.
        setShadowsOnGivenButton(button: actionButtonOutlet)
        
        
    }
    
/*Setup Functions*/
    func setShadowsOnGivenButton(button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
    }
    
/*Button Functions*/
    
    //Launching Camera Button.
    @IBAction func actionButton(_ sender: Any) {
        
        //session.startRunning()
        
    }
    
    //Launching Settings Button.
    @IBAction func launchSettingsButton(_ sender: Any) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

