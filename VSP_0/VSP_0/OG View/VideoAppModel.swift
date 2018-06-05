//
//  VideoAppModal.swift
//  VSP_0
//
//  Created by Steve Lee on 5/25/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation
import AVKit
import MobileCoreServices

class VideoAppModel: NSObject {
    
    //Initializer is not needed because there is no need to pre load anything.
    //Instead, the view controller "setsup" by calling the retrieve data from this
    //model in its init function.
    
    //What should a camera app be able to do?
    //1) Save video and load video. Saving includes saving meta data and whatnot.
    //Capturing isn't the responsibility of the model. Instad, the controller
    //gets the data and gives it to the model and then the model does the saving
    //video part of it.
    //2) Be able to load information for the table view.
    
/*Data components.*/
    
    //Dictionary that holds videos. The lookup table is filename : UIImage.
    //Difference between NSMutableDictionary and Dictionary is that
    //NSMutableDictionary is a reference semantic, which, I think, means that
    //This is used like a place to load the data onto so the view controller can
    //use it whenever it is needed.
    var videosMetaData: [VideoMetaData] = []
    
    
/*Save Video Function*/
    //Saving the video that was just recorded.
    func saveVideoAndItsMetaData(videoURL: URL) {
        
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
        //Saving data to the system permanantly.
        saveVideosMetaDataToTheSystem()
    }
    
    //Saving the video for the long term.
    private func saveVideosMetaDataToTheSystem() {
        //Archieving into a Data type.
        let data = NSKeyedArchiver.archivedData(withRootObject: videosMetaData);
        //Be able to save data when the app quits randomly or app is closed.
        let defaults = UserDefaults()
        defaults.set(data, forKey: "VSP_Data_VideosMetaData")
        defaults.synchronize()
    }

    /*Helper Functions*/
    
    //This is for converting seconds to hr:min:seconds format.
    private func convertIntToStringHoursMinutesAndSeconds (seconds : Double) -> String {
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
    private func imageWithImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    //Determining if the image is portrait or landscape.
    private func isPortrait(width: Int, height: Int) -> Bool {
        //If the width is greater than height, then it's a landscape.
        if (width > height) {
            return false
        }
        return true
    }
    
/*Load Data Function*.*/
 
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
    
}
