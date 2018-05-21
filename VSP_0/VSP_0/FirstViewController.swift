//
//  FirstViewController.swift
//  VSP_0
//
//  Created by Steve Lee on 5/16/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import UIKit
import MobileCoreServices

class FirstViewController: UIViewController {

    //Variables.
    var actionButtonActivated = false
    var buttonsOGLocation: CGPoint! = CGPoint(x: 291, y: 537)
    
    //Buttons.
    @IBOutlet weak var actionButtonOutlet: UIButton!
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creating shadows for the action button.
        setShadowsOnGivenButton(button: actionButtonOutlet)
    }
    
/*Setup Functions*/
    func setShadowsOnGivenButton(button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 7
        button.layer.shadowOpacity = 0.5
    }
    
    
    
/*Button Functions*/
    //Launching Camera Button.
    @IBAction func actionButton(_ sender: Any) {
        
        /*UIImagePickerController Method*/
        //Checking to see if the camera is available.
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            //Instance of uiimage picker controller, which is used
            //for setting camera settings
            let picker = UIImagePickerController()
            picker.videoQuality = .typeHigh
            let mediaTypesArray:[String] = [kUTTypeMovie as String]
            picker.mediaTypes = mediaTypesArray
            picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        } else {
            //This part may not be needed if the camera automatically puts up
            //the "Camera not available message"
            let alert = UIAlertController(title: "VSP",
                                          message: "Camera not available",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        //Keeping track of if the action has been pressed or not and creating the
        //animation according to it.
//        if !actionButtonActivated {
//            //If it hasn't been activated, it means the animation hasn't happened.
//            //So do the spreading out animation.
//
//
//            actionButtonActivated = true
//        } else {
//            //IF it has been activated, it menas that the animation has been
//            //run.
//            //So do the combining animation.
//
//
//            actionButtonActivated = false
//        }
//
        
        //initializeCamera(view: view)
        //session.startRunning()
        
        //There are two buttons already below it, and they are both inactive.
        //Check to see if they're ever at a "pending status or not.
        
        //set shadows for the other buttons too.
        //Maybe not set the shadows and darken the background instead.
        //setShadowsOnGivenButton(button: settingsButtonOutlet)
        
    }
    
    //Launching Settings Button.
    @IBAction func launchSettingsButton(_ sender: Any) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/*Animations*/
    func spreadOutAnimation() {
        
        //Animations: Camera button going up, settings button going left,
        //and the settings and the cancel buttons' opacity going from 0 to 1.
        
        
    }
    func revertAnimation() {
        
        
    }
}




