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

    //Variables.
    var actionButtonActivated = false
    var buttonsOGLocation: CGPoint! = CGPoint(x: 291, y: 537)
    
    //Camera component.
    let picker: UIImagePickerController = UIImagePickerController()
    
    //Data components.
    
    //Dictionary that holds videos. The lookup table is filename : UIImage.
    //Difference between NSMutableDictionary and Dictionary is that
    //NSMutableDictionary is a reference semantic, which, I think, means that
    //
    var videosMetaData: [VideoMetaData] = []
    
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
        loadVideosMetaData()
        
    }
    
/*Setup Functions*/
    func setShadowsOnGivenButton(button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 7
        button.layer.shadowOpacity = 0.5
    }
    
    func loadVideosMetaData() {
        let defaults = UserDefaults()
        //Checking to see if any data is present in the system and if there is,
        //store the data to the videosMetaData dictionary.
        if let data = defaults.object(forKey: "VSP_Data_VideosMetaData") as? Data {
            //Unarchieving it.
            let unarchievedData = NSKeyedUnarchiver.unarchiveObject(with: data) as! [VideoMetaData]
            videosMetaData = unarchievedData
        } else {
            //Data doesn't exist.
            print("Data Doesn't Exist")
        }
    }

/*Data Functions*/
    
    //Saving the video for the long term.
    func saveVideosMetaDataToTheSystem() {
        //Archieving into a Data type.
        let data = NSKeyedArchiver.archivedData(withRootObject: videosMetaData);
        //Be able to save data when the app quits randomly or app is closed.
        let defaults = UserDefaults()
        defaults.set(data, forKey: "VSP_Data_VideosMetaData")
        defaults.synchronize()
    }
    
    //Saving the video that was just recorded.
    func saveVideoAndItsMetaData(videoURL: NSURL) {
        
        //Ask user for the title of the video. Could be a pop-up windown like
        //vnc asking for an ip address before connecting to anything.
        
        //Getting the duration of video.
        let sourceAsset = AVURLAsset(url: videoURL as URL)
        let duration = sourceAsset.duration.seconds
        
        //Getting the orientation of the video.
        var orientation = "Portrait"
        
        //Getting the date of the video.
        let date = sourceAsset.creationDate?.dateValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let formattedDate = dateFormatter.string(from: date!)
    
        //Getting the thumbnail of the video.
        let thumbnailGenerator = AVAssetImageGenerator(asset: AVAsset(url: videoURL as URL))
        let frameTimeStart = 3
        let frameLocaion = 1
        var thumbnail = #imageLiteral(resourceName: "Record Button")
        do {
            //Checking to see if the frame is valid. If not, the thumbnail
            //stays on the default image.
            //For getting the correct orientation.
            thumbnailGenerator.appliesPreferredTrackTransform = true
            let frameRef = try thumbnailGenerator.copyCGImage(at: CMTimeMake(Int64(frameTimeStart),
                                                                             Int32(frameLocaion)), actualTime: nil)
            //Determining what the orientation of the video is based on the
            //orientation of the thumbnail that was taken.
            if !isPortrait(width: frameRef.width, height: frameRef.height) {
                orientation = "Landscape"
            }
            //Getting the initial uiimage.
            thumbnail = UIImage(cgImage: frameRef)
            thumbnail = imageWithImage(image: thumbnail, newSize: CGSize(width: 126.22, height: 71))
            
            
        } catch {
            print("Frame cannot be captured.")
        }
        
        //Creating a new video meta data instance and adding it to the videos
        //metadata array.
        let videoMetaDataToSave = VideoMetaData()
        //MetaData below.
        videoMetaDataToSave.title = "Video titg"
        videoMetaDataToSave.videoDuration = convertIntToStringHoursMinutesAndSeconds(seconds: duration)
        videoMetaDataToSave.thumbnail = thumbnail
        videoMetaDataToSave.orientation = orientation
        videoMetaDataToSave.recordedDate = formattedDate
        videoMetaDataToSave.videoURLPath = videoURL
        
        print("\(videoURL)")
        
        //Appending to the metadata array.
        videosMetaData.append(videoMetaDataToSave)
        //Updating the tableview with new data.
        tableViewOfVideos.reloadData()
        
        saveVideosMetaDataToTheSystem()
    }
    
    /*Helper Functions*/
    
    //This is for converting seconds to hr:min:seconds format.
    func convertIntToStringHoursMinutesAndSeconds (seconds : Double) -> String {
        let duration: TimeInterval = seconds
        //Calculating hours, minutes, and seconds from the passed in seconds.
        let s: Int = Int(duration) % 60
        let m: Int = Int(duration) / 60
        let h: Int = Int(duration) / 3600
        //Formatting it. Still not sure how this works; string's function probs?
        let formattedDuration = String(format: "%02d:%02d:%02d", h, m, s)
        return formattedDuration
    }
    
    //Resizes the passed in image.
    func imageWithImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    //Determining if the image is portrait or landscape.
    func isPortrait(width: Int, height: Int) -> Bool {
        //If the width is greater than height, then it's a landscape.
        if (width > height) {
            return false
        }
        return true
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
        return videosMetaData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Reusable cell that is about to be loaded with new information and data
        //and used to be presented on the table view.
        let cell = tableViewOfVideos.dequeueReusableCell(withIdentifier: "cell") as! VideoClipCell
        //This sets the arrow thingy on the right edge of the tableviewcell.
        cell.accessoryType = .disclosureIndicator
        //Setting the data for the cell based on the array of videometadata.
        cell.thumbnail.image = videosMetaData[indexPath.row].thumbnail
        cell.videoTitle.text = videosMetaData[indexPath.row].title
        cell.recordedDate.text = videosMetaData[indexPath.row].recordedDate
        cell.videoLengthTime.text = videosMetaData[indexPath.row].videoDuration
        cell.recordedDate.text = String(videosMetaData[indexPath.row].videoURLPath.description)
        //Seting the orientation indicator image.
        if videosMetaData[indexPath.row].orientation == "Portrait" {
            cell.orientationIndicator.image = #imageLiteral(resourceName: "portrait")
        } else {
            cell.orientationIndicator.image = #imageLiteral(resourceName: "landscape")
        }
        
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
            //system data.
            saveVideoAndItsMetaData(videoURL: savedVideoURL!)
            //saveVideosMetaDataToTheSystem()
        }
        
        
        
        //Doing something when the image picker view is dismissed.
        dismiss(animated: true, completion: {
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

