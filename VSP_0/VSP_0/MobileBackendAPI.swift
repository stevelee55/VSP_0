//
//  MobileBackendAPI.swift
//  VSP_0
//
//  Created by Steve Lee on 5/30/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation
import AWSAuthCore
import AWSCore
import AWSAPIGateway
import AWSMobileClient

//AWS S3
import AWSS3


class MobileBackendAPI {
    
    
/*AWSS3*/
    
    let bucketName = "vsp-userfiles-mobilehub-602139379/userData"
    
    func uploadData() {
        
        
        let stringData:String = "Hello World! This is from AWSS3! :0"
        
        let data: Data = stringData.data(using: .utf8)! //Data() // Data to be uploaded
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
                print(progress)
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                print("Upload Successful")
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        //Content Type lists: http://www.iana.org/assignments/media-types/media-types.xhtml
        
        transferUtility.uploadData(data,
                                   bucket: bucketName,
                                   key: "helloWorldFile",
                                   contentType: "text/plain",
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith {
                                    (task) -> AnyObject? in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                    
                                    if let _ = task.result {
                                        // Do something with uploadTask.
                                    }
                                    return nil;
        }
    }
    
    //Downloading data from s3 bucket.
    func downloadData(recievedDataLabel: UILabel) {
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
            // Do something e.g. Update a progress bar.
            print("Downloaded: \(progress)")
        })
        }

        //Use this later.
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        //This runs whenever the downloaddata function is finish getting the data.
        completionHandler = { (task, URL, data, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed downloads, `error` contains the error object.
                let responseString =  String(data:data!, encoding: .utf8)
                recievedDataLabel.text = responseString
                print("Download Successful")
            })
        }
        
        //Later change the permission for the s3 buckets.
        let transferUtility = AWSS3TransferUtility.default()
        //This is for getting the notification when the download is complete.
        transferUtility.downloadData(fromBucket: bucketName, key: "helloWorldFile", expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            if let _ = task.result {
                // Do something with downloadTask.
            }
            return nil
        }
    }
    
    
/*Lambda*/
    
    //Default invoking the API Gateway.
    //Origin: https://docs.aws.amazon.com/aws-mobile/latest/developerguide/add-aws-mobile-cloud-logic.html#connect-to-your-backend
    func doInvokeAPI(recievedDataLabel: UILabel) {
        // change the method name, or path or the query string parameters here as desired
        let httpMethodName = "POST"
        // change to any valid path you configured in the API
        let URLString = "/items"
        let queryStringParameters = ["key1":"{value1}"]
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let httpBody = "{ \n  " +
            "\"key1\":\"value1\", \n  " +
            "\"key2\":\"value2\", \n  " +
        "\"key3\":\"value3\"\n}"
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryStringParameters,
                                              headerParameters: headerParameters,
                                              httpBody: httpBody)
        
        // Create a service configuration object for the region your AWS API was created in
        let serviceConfiguration = AWSServiceConfiguration(
            region: AWSRegionType.USEast1,
            credentialsProvider: AWSMobileClient.sharedInstance().getCredentialsProvider())
        
        
        AWSAPI_TSYAQ88K2E_VSPMobileHubClient.register(with: serviceConfiguration!, forKey: "CloudLogicAPIKey")
        
        // Fetch the Cloud Logic client to be used for invocation
        let invocationClient =
            AWSAPI_TSYAQ88K2E_VSPMobileHubClient(forKey: "CloudLogicAPIKey")
        
        invocationClient.invoke(apiRequest).continueWith { (
            task: AWSTask) -> Any? in
            
            if let error = task.error {
                print("Error occurred: \(error)")
                // Handle error here
                return nil
            }
            
            // Handle successful result here
            let result = task.result!
            let responseString =
                String(data: result.responseData!, encoding: .utf8)
            
            print(responseString!)
            print(result.statusCode)
            
            //This allows the label to be updated after the "closure is completed".
            //It is almost like a delayed reaction.
            //I think this is like function getting called in the stack but
            //it still persists. Take a look into this later more in depth.
            DispatchQueue.main.async {
                recievedDataLabel.text = responseString
            }
            return nil
        }
    }
}
