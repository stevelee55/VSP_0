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
    
    let api = MobileBackendAPI()
    
    var videoURL:URL = URL(fileURLWithPath: "default")
    
    var player = AVPlayer()
    
    var uploaded = false
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func videoPlayButton(_ sender: Any) {
        
        let player = AVPlayer(url: videoURL)  // video path coming from above function
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
//        let asset = AVURLAsset(url: videoURL, options: nil)
//        let playerItem = AVPlayerItem(asset: asset)
//        player = AVPlayer(playerItem: playerItem)
//        player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
//
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
