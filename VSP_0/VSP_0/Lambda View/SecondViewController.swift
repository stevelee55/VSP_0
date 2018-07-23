//
//  SecondViewController.swift
//  VSP_0
//
//  Created by Steve Lee on 5/16/18.
//  Copyright © 2018 stevesl. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var progressbarrr: UIProgressView!
    //API object that is used to call functions for uploading or downloading
    //data from AWS services.
    let api = MobileBackendAPI()
    
    @IBAction func getResultFromS3Button(_ sender: Any) {
        api.downloadData(progressBar: progressbarrr)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        progressbarrr.progress = Float(0.0)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

