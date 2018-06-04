//
//  VideoMetaData.swift
//  VSP_0
//
//  Created by Steve Lee on 5/24/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import Foundation
import UIKit

class VideoMetaData: NSObject, NSCoding {
    
    var title: String = "n/a"
    var recordedDate: String = "n/a"
    var videoDuration: String = "n/a"
    var thumbnail: UIImage = #imageLiteral(resourceName: "Record Button")
    var videoURLPath: URL = URL(fileURLWithPath: "n/a")
    var orientation: String = "n/a"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.recordedDate, forKey: "recordedDate")
        aCoder.encode(self.videoDuration, forKey: "videoDuration")
        aCoder.encode(self.thumbnail, forKey: "thumbnail")
        aCoder.encode(self.videoURLPath, forKey: "videoURLPath")
        aCoder.encode(self.orientation, forKey: "orientation")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = (aDecoder.decodeObject(forKey: "title") as? String)!
        self.recordedDate = (aDecoder.decodeObject(forKey: "recordedDate") as? String)!
        self.videoDuration = (aDecoder.decodeObject(forKey: "videoDuration") as? String)!
        self.thumbnail = (aDecoder.decodeObject(forKey: "thumbnail") as? UIImage)!
        self.videoURLPath = aDecoder.decodeObject(forKey: "videoURLPath") as! URL
        self.orientation = aDecoder.decodeObject(forKey: "orientation") as! String
    }
    
    override init() {
    }
}


