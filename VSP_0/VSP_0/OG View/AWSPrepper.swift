//
//  AWSPrepper.swift
//  VSP_0
//
//  Created by Steve Lee on 6/5/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation
import AVKit


class AWSPrepper:UIViewController {
    
    //API object that is used to call functions for uploading or downloading
    //data from AWS services.
    let api = MobileBackendAPI()
   
    //This gets run and updated whenever a data is being uploaded to AWS.
    @IBOutlet weak var uploadToAWSProgressBar: UIProgressView!
    
    //Data that are passed from the OG View Controller.
    var videoMetaData = VideoMetaData()
    
/*Data Prep*/
    
    //Allow the user to choose which frame to modift and be able to choose it and
    //turn it into Data() and send it to Lambda by using the function uploadData(progressbar, data).
    func getNthFrameAsImageData(nth: Int, videoURL: URL) -> Data {
        //Getting the thumbnail of the video.
        let thumbnailGenerator = AVAssetImageGenerator(asset: AVAsset(url: videoURL as URL))
        let frameTimeStart = nth//3
        let frameLocation = 1
        var frameImage = #imageLiteral(resourceName: "Record Button")
        do {
            //Checking to see if the frame is valid. If not, the thumbnail
            //stays on the default image.
            //For getting the correct orientation.
            thumbnailGenerator.appliesPreferredTrackTransform = true
            let frameRef = try thumbnailGenerator.copyCGImage(at: CMTimeMake(Int64(frameTimeStart),
                                                                             Int32(frameLocation)), actualTime: nil)
            //Getting the initial uiimage.
            //This is the actual frame.
            frameImage = UIImage(cgImage: frameRef)
        } catch {
            print("Frame cannot be captured.")
        }
        
        let data: Data = UIImagePNGRepresentation(frameImage)!
        return data
    }
    
    
/*Uploading and recieving data via AWS*/
    
    //This is done after the user configures everything and everything is setup.
    @IBAction func sendDataToAWS(_ sender: Any) {
        //Getting the frame as an image from the video url.
        var data: Data = Data()
        do {
             data = try Data(contentsOf: videoMetaData.videoURLPath)
            
        } catch {
            
        } //getNthFrameAsImageData(nth: 10, videoURL: videoMetaData.videoURLPath)
        //Attempting to upload the data AWS S3.
        if  !(api.uploadData(progressBar: uploadToAWSProgressBar, dataToUpload: data)) {
            //Internet not available alert.
            let alert = UIAlertController(title: "AWS Not Available", message: "Device is not connected to the internet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            startingUploadToAWSProgressBar()
        }
        
        //Connecting to AWS Lambda and requesting data/calling function.
        //Send data to lambda function.
        //AWS Lambda Setup.
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
    
    //Dismisses the current view whenever the cancel button is clicked.
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}
