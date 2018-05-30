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

class MobileBackendAPI {
    
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
