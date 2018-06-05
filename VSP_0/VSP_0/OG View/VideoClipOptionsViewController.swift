//
//  VideoClipOptionsViewController.swift
//  VSP_0
//
//  Created by Steve Lee on 5/28/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import UIKit
import AVKit

class VideoClipOptionsViewController: UIViewController {
    
    //This label is used to present the metadata of the video clip
    //that was specified by the user by clicking on the uitableviewcell.
    @IBOutlet weak var metaDataLabel: UILabel!
    
    //Data that are passed from the OG View Controller.
    var videoMetaData = VideoMetaData()
    
    //Thumbnail UIimage.
    @IBOutlet weak var videoThumbnail: UIImageView!
    
    //May not need this at all.
    override func viewDidLoad() {
        //Setting the passed in thumbnail image to the current vc.
        videoThumbnail.image = videoMetaData.thumbnail
    }

/*Buttons*/
    
    @IBAction func prepForLambdaButton(_ sender: Any) {
        performSegue(withIdentifier: "SegueToAWSPrepper", sender: self)
    }
    
    //Button that plays video that the passed in video url.
    @IBAction func videoPlayButton(_ sender: Any) {
        playVideoAtURLPath(url: videoMetaData.videoURLPath)
    }
    
/*Preparing data to pass over to the other view controller.*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVS = segue.destination as! AWSPrepper
        destinationVS.videoMetaData = videoMetaData
        present(destinationVS, animated: true, completion: nil)
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
