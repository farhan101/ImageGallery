//
//  ViewController.swift
//  ImageGallery
//
//  Created by Farhan Arshad on 2/1/18.
//  Copyright © 2018 Farhan Arshad. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ImageGalleryDelegate {
    
    fileprivate let images: [String] = [
        "https://i.imgur.com/fCIQXYz.jpg",
        "https://i.imgur.com/nXjDbCM.jpg",
        "https://i.imgur.com/fr45ksmb.jpg",
        "https://i.imgur.com/amXEetmb.jpg",
        "https://i.imgur.com/2gTFkQBb.jpg",
        "https://i.imgur.com/2AWxv4Kb.jpg"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func actionGallery(_ sender: UIButton) {
        let gallery = ImageGallery()
        gallery.delegate = self
        gallery.modalTransitionStyle = .crossDissolve
        self.present(gallery, animated: true, completion: nil)
    }
    func imageGallery(completion: @escaping ([ImageGalleryData]?) -> Void) {
        var collection:[ImageGalleryData] = []
        let data = ImageGalleryData()
        data.mediaUrl = images[0]
        collection.append(data)
        let data2 = ImageGalleryData()
        data2.mediaUrl = "https://www.radiantmediaplayer.com/media/bbb-360p.mp4"
        data2.videoThumbnail = images[1]
        collection.append(data2)
        completion(collection)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

