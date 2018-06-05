//
//  AWSPrepper.swift
//  VSP_0
//
//  Created by Steve Lee on 6/5/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation


class AWSPrepper:UIViewController {
    
    //API object that is used to call functions for uploading or downloading
    //data from AWS services.
    let api = MobileBackendAPI()
    
    
    //This is temp.
    var uploaded = false
    
   
    //This gets run and updated whenever a data is being uploaded to AWS.
    @IBOutlet weak var uploadToAWSProgressBar: UIProgressView!
    
    //This is done after the user configures everything and everything is setup.
    @IBAction func sendDataToAWS(_ sender: Any) {
        
        startingUploadToAWSProgressBar()
        api.uploadData(progressBar: uploadToAWSProgressBar)
        
        //Connecting to AWS Lambda and requesting data/calling function.
        //Send data to lambda function.
        //AWS Lambda Setup.
        
//        //Calling the API Gateway and getting the response from AWS Lambda.
//        if !uploaded {
//            api.uploadData(progressBar: uploadToAWSProgressBar)
//            //api.doInvokeAPI(recievedDataLabel: recievedDataLabel)
//            uploaded = true
//        } else {
//            api.downloadData(progressBar: uploadToAWSProgressBar)
//            uploaded = false
//        }
    }
    
/*Objects initializers*/
    func initUploadToAWSProgressBar() {
        uploadToAWSProgressBar.alpha = 0.0
        uploadToAWSProgressBar.progress = Float(0.0)
        uploadToAWSProgressBar.isUserInteractionEnabled = false
    }
    func startingUploadToAWSProgressBar() {
        uploadToAWSProgressBar.alpha = 1.0
        uploadToAWSProgressBar.isUserInteractionEnabled = true
    }
    
    //Setup when the view is loaded.
    override func viewDidLoad() {
        initUploadToAWSProgressBar()
    }
    
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}
