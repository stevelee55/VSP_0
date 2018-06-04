//
//  SendDataToLambdaViewController.swift
//  VSP_0
//
//  Created by Steve Lee on 5/28/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import UIKit
import AVKit

class SendDataToLambdaViewController: UIViewController {
    
    @IBOutlet weak var recievedDataLabel: UILabel!
    
    //API object that is used to call functions for uploading or downloading
    //data from AWS services.
    let api = MobileBackendAPI()
    
    //This data is passed from the OG View Controller.
    var videoURL:URL = URL(fileURLWithPath: "default")
    
    //This is temp.
    var uploaded = false
    
    //May not need this at all.
    override func viewDidLoad() {
    }
    
    //Button that plays video that the passed in video url.
    @IBAction func videoPlayButton(_ sender: Any) {
        playVideoAtURLPath(url: videoURL)
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
/*Video Playback*/
    func playVideoAtURLPath(url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
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
