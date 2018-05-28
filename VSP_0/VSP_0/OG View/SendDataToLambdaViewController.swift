//
//  SendDataToLambdaViewController.swift
//  VSP_0
//
//  Created by Steve Lee on 5/28/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import UIKit
import AWSLambda

class SendDataToLambdaViewController: UIViewController {
    
    @IBOutlet weak var recievedDataLabel: UILabel!
    
    override func viewDidLoad() {
        
    }
    
    
    //Connecting to AWS Lambda and requesting data/calling function.
    @IBAction func sendDataToAWSLambda(_ sender: Any) {
        //Send data to lambda function.
        //AWS Lambda Setup.
        let lambdaInvoker = AWSLambdaInvoker.default()
        let jsonObject: [String: Any] = ["key1" : "value1",
                                         "key2" : 2 ,
                                         "key3" : [1, 2],
                                         "isError" : false]
        lambdaInvoker.invokeFunction("randomNumberGenerator", jsonObject: jsonObject).continueWith(block: {(task:AWSTask<AnyObject>) -> Any? in
            if let error = task.error as NSError? {
                if (error.domain == AWSLambdaInvokerErrorDomain) && (AWSLambdaInvokerErrorType.functionError == AWSLambdaInvokerErrorType(rawValue: error.code)) {
                    print("Function error: \(String(describing: error.userInfo[AWSLambdaInvokerFunctionErrorKey]))")
                    } else {
                    print("Error: \(error)")
                    }
                    return nil
            }
            
            // Handle response in task.result
            if let JSONDictionary = task.result as? NSDictionary {
                print("Result: \(JSONDictionary)")
                print("resultKey: \(String(describing: JSONDictionary["resultKey"]))")
            }
            return nil
        })
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
