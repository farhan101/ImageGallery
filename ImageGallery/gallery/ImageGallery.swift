//
//  ImageGallery.swift
//  ImageGallery
//
//  Created by Farhan Arshad on 2/3/18.
//  Copyright © 2018 Farhan Arshad. All rights reserved.
//

import UIKit

class ImageGallery: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var topFrame: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var countDisplay: UILabel!
    var delegate: ImageGalleryDelegate?
    fileprivate var numPages: Int = 0
    fileprivate var currentPage: Int = 0
    fileprivate var loadedIndexes: NSMutableDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        loadedIndexes = NSMutableDictionary()
    }

    func loadPage(page: Int){
        //If beyond the bounds or image has already been added at this index... RETURN
        if page < 0 || page > (numPages - 1) || ((loadedIndexes?.object(forKey: page)) != nil) {
            return
        }
        var frame = scrollView.frame
        // Offset the frame's X origin to its correct page offset.
        frame.origin.x = frame.width * CGFloat(page)
        frame.origin.y = 0
        let imageVU = ImageScrollView(frame: frame)
        scrollView.addSubview(imageVU)
        loadedIndexes?[page] = page //Just a flag to indicate that this place has been filled
        delegate?.imageGallery(gallery: self, imageForIndex: page, completion: { (image, index) in
            if index == page {
                imageVU.display(image: image)
            }
        })
        //imageVU.display(image: (delegate?.imageGallery(gallery: self, imageForIndex: currentPage))!)

    }
    /// Readjust the scroll view's content size in case the layout has changed.
    fileprivate func adjustScrollView(numPages: Int) {
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(numPages), height: scrollView.h - topFrame.h)
        self.numPages = numPages
        if numPages <= 0{
            currentPage = 0
        }
        countDisplay.text = (currentPage + 1).description + " / " + numPages.description
        
        loadPage(page: currentPage - 1)
        loadPage(page: currentPage)
        loadPage(page: currentPage + 1)
        
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Switch the indicator when more than 50% of the previous/next page is visible.
        let pageWidth = scrollView.frame.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        currentPage = Int(page)
        countDisplay.text = (Int(page) + 1).description + " / " + numPages.description
        loadPage(page: currentPage - 1)
        loadPage(page: currentPage)
        loadPage(page: currentPage + 1)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustScrollView(numPages: (delegate?.numberOfImages(in: self))!)
    }

    @IBAction func btnBack(_ sender: UIButton){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

protocol ImageGalleryDelegate{
    func numberOfImages(in : ImageGallery) -> Int
    func imageGallery(gallery : ImageGallery, imageForIndex: Int, completion: @escaping (UIImage, Int) -> Void)
}
