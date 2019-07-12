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
        "https://upload.wikimedia.org/wikipedia/commons/2/22/Big.Buck.Bunny.-.Bunny.Portrait.png",
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
        let gallery = MediaGallery()
        gallery.delegate = self
        gallery.topTitle = "Media Gallery"
        gallery.modalTransitionStyle = .crossDissolve
        self.present(gallery, animated: true, completion: nil)
    }
                                 
    func imageGallery(completion: @escaping ([MediaRecord]?) -> Void) {
        var collection:[MediaRecord] = []
        var data = ImageRecord<String>()
        data.media = images[0]
        collection.append(data)
        var data1_1 = ImageRecord<UIImage>()
        data1_1.media = UIImage(named: "k2")
        collection.append(data1_1)
        var data2 = VideoRecord<String, String>()
        data2.media = "https://www.radiantmediaplayer.com/media/bbb-360p.mp4"
        data2.thumbnail = images[1]
        collection.append(data2)
        completion(collection)
        var data2_1 = VideoRecord<String, UIImage>()
        data2_1.media = "https://www.radiantmediaplayer.com/media/bbb-360p.mp4"
        data2_1.thumbnail = UIImage(named: "bunny")
        collection.append(data2_1)
        completion(collection)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

