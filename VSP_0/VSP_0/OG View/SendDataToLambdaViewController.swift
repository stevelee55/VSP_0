//
//  SendDataToLambdaViewController.swift
//  VSP_0
//
//  Created by Steve Lee on 5/28/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import UIKit

class SendDataToLambdaViewController: UIViewController {
    
    @IBOutlet weak var recievedDataLabel: UILabel!
    
    let api = MobileBackendAPI()
    
    var uploaded = false
    
    override func viewDidLoad() {
        
    }
    
    //Connecting to AWS Lambda and requesting data/calling function.
    @IBAction func sendDataToAWSLambda(_ sender: Any) {
        //Send data to lambda function.
        //AWS Lambda Setup.
        
        //Calling the API Gateway and getting the response from AWS Lambda.
        
        
        if !uploaded {
            api.uploadData()
            //api.doInvokeAPI(recievedDataLabel: recievedDataLabel)
            uploaded = true
        } else {
            api.downloadData(recievedDataLabel: recievedDataLabel)
            uploaded = false
        }
        
    }

    //Dismissing the current view controller.
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
