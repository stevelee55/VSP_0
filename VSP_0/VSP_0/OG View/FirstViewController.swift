//
//  FirstViewController.swift
//  VSP_0
//
//  Created by Steve Lee on 5/16/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //View Controller's model.
    let model = VideoAppModel()
    
    //Variables.
    var actionButtonActivated = false
    var buttonsOGLocation: CGPoint! = CGPoint(x: 291, y: 537)
    
    //Camera component.
    let picker: UIImagePickerController = UIImagePickerController()
    
    //UIScrollView
    @IBOutlet weak var tableViewOfVideos: UITableView!
    //Cell: Custom for accessing a video clip.
    //Should have thumbnail, title, play, lambda, and more info(i) buttons.

    //Buttons.
    @IBOutlet weak var actionButtonOutlet: UIButton!
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    
    //Algorithm could be to either: export and send data to lambda as
    //image frames, or as video clips.
    //Also give an option to how many frames to export it as.
    
    //Give controls for the user on how to
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creating shadows for the action button.
        setShadowsOnGivenButton(button: actionButtonOutlet)
        
        //Using the list of urls and videos, store the list of thumbnails and
        //save them in a dictionary (file name/path : image)
        //for quick access by the tableviewcontroller.
        
        //Load up a list of urls for videos and thumbnails from the core data
        //or nsuserdefaults. This could be a custom datastructure that keeps track
        //of videos metadata, title, date, time, etc, which can be used to load
        //up data that's needed for tableviewcontroller. This should not store
        //the actual images, but the images/thumbnails' url names in strings, which
        //can be used to look up the images in the dictionary.
        model.loadVideosMetaData()
        
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
            //Setting camera settings.
            picker.videoQuality = .typeHigh
            let mediaTypesArray:[String] = [kUTTypeMovie as String]
            picker.mediaTypes = mediaTypesArray
            picker.delegate = self
            picker.modalPresentationStyle = .overCurrentContext
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
    
/*UIScrollView Delegate functions*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.videosMetaData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Reusable cell that is about to be loaded with new information and data
        //and used to be presented on the table view.
        let cell = tableViewOfVideos.dequeueReusableCell(withIdentifier: "cell") as! VideoClipCell
        //This sets the arrow thingy on the right edge of the tableviewcell.
        cell.accessoryType = .disclosureIndicator
        //Setting the data for the cell based on the array of videometadata.
        cell.thumbnail.image = model.videosMetaData[indexPath.row].thumbnail
        cell.videoTitle.text = model.videosMetaData[indexPath.row].title
        cell.recordedDate.text = model.videosMetaData[indexPath.row].recordedDate
        cell.videoLengthTime.text = model.videosMetaData[indexPath.row].videoDuration
        cell.recordedDate.text = model.videosMetaData[indexPath.row].recordedDate
        //Seting the orientation indicator image.
        if model.videosMetaData[indexPath.row].orientation == "Portrait" {
            cell.orientationIndicator.image = #imageLiteral(resourceName: "portrait")
        } else {
            cell.orientationIndicator.image = #imageLiteral(resourceName: "landscape")
        }
        cell.setEditing(true, animated: true)
        
        return cell
    }
    
/*Camera Functions*/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //Checking to see if the video was taken and has a url.
        var savedVideoURL:NSURL? = nil
        if let videoURL = info[UIImagePickerControllerMediaURL] as? NSURL {
            //Saves to the main photo album.
            UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath!, self, nil, nil)
            //Saving the video URL for storing and later playback.
            savedVideoURL = videoURL
            //Saving the video and the url and other metadata of the video to the
            //system data, but the job is done by the model.
            model.saveVideoAndItsMetaData(videoURL: savedVideoURL!)
        }
        
        //Doing something when the image picker view is dismissed.
        dismiss(animated: true, completion: {
            
            //Reload data for the tableview.
            self.tableViewOfVideos.reloadData()
            
            //Creating the alert for the user to tell them that the video has been
            //saved.
            let alert = UIAlertController(title: "VSP",
                                          message: "Video Saved!",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: {
                
            })
            
            //Storing video and its thumbanil in the documents directory of the app.
            //Storying the images and the file/path names
            
//            //Playing the recorded video after checking if the video has been saved.
//            if savedVideoURL != nil {
//                self.playVideo(videoLocalURL: savedVideoURL!)
//            }
        })
        
    }
    
    
/*Media Playback functions*/
    func playVideo(videoLocalURL: NSURL) {
        let player = AVPlayerViewController()
        player.player = AVPlayer(url: videoLocalURL as URL)
        self.present(player, animated: true, completion: nil)
    }
    
/*Animations*/
    func spreadOutAnimation() {
        //Animations: Camera button going up, settings button going left,
        //and the settings and the cancel buttons' opacity going from 0 to 1.
        
    }
    func revertAnimation() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

