//
//  ViewController.swift
//  ImageGallery
//
//  Created by Farhan Arshad on 2/1/18.
//  Copyright © 2018 Farhan Arshad. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ImageGalleryDelegate {
    
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
        return 9
    }
    func imageGallery(gallery: ImageGallery, imageForIndex: Int) -> UIImage? {
        return UIImage(named: imageForIndex.description)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

