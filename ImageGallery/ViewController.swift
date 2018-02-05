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
    func numberOfImages(in: ImageGallery) -> Int {
        return images.count
    }
    
    func imageGallery(gallery: ImageGallery, imageForIndex: Int, completion: @escaping (UIImage, Int) -> Void) {
        ImageLoader.load(Image: images[imageForIndex]) { (image, url) in
            if url == self.images[imageForIndex] && image != nil{
                completion(image!, imageForIndex)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

