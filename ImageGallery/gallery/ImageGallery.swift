//
//  ImageGallery.swift
//  ImageGallery
//
//  Created by Farhan Arshad on 2/3/18.
//  Copyright © 2018 Farhan Arshad. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit

class ImageGalleryData{
    var videoThumbnail: String?
    var mediaUrl: String? //Either Image or Video
    var mediaAsImage: UIImage?
    var videoThumbnailAsImage: UIImage?
}
class ImageGallery: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var topFrame: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var countDisplay: UILabel!
    @IBOutlet weak var mbtnPlayMovie: IndexedButton!
    var delegate: ImageGalleryDelegate?
    var pageToJump: Int = 0
    fileprivate var mImageGalleryData: [ImageGalleryData]?
    fileprivate var numPages: Int = 0
    fileprivate var currentPage: Int = 0
    fileprivate var loadedIndexes: NSMutableDictionary?
    fileprivate var firstRun: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        loadedIndexes = NSMutableDictionary()
        self.mbtnPlayMovie.addTarget(self, action: #selector(playMovie), for: .allEvents)
    }

    func loadPage(page: Int){
        //If beyond the bounds or image has already been added at this index... RETURN
        self.mbtnPlayMovie.isHidden = true
        if ((loadedIndexes?.object(forKey: currentPage)) != nil) && page >= 0  && page <= numPages {
            if let data = self.mImageGalleryData?[currentPage]{
                if data.videoThumbnail != nil{//Its a movie
                    self.mbtnPlayMovie.info = data.mediaUrl
                    self.mbtnPlayMovie.isHidden = false
                }
            }
        }
        
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
        let downloader : SDWebImageDownloader = SDWebImageDownloader.shared
        if let media = self.mImageGalleryData?[page]{
            
            if media.mediaAsImage != nil{
                imageVU.display(image: media.mediaAsImage!)
            }else{
                var imageURL: URL?
                if media.videoThumbnail != nil{
                    imageURL = URL(string: media.videoThumbnail!)
                }else{
                    imageURL = URL(string: media.mediaUrl!)
                }
                downloader.downloadImage(with: imageURL, options: SDWebImageDownloaderOptions(rawValue: 0), progress: { (one, two, url) in
                    
                }) { (image, data, error, status) in
                    if let image = image{
                        imageVU.display(image: image)
                    }
                }
            }
            
        }
    }
    @objc func playMovie(sender: IndexedButton){
        //print(sender.info!)
        let player = AVPlayer(url: URL(string: (sender.info)!)!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
    }
    /// Readjust the scroll view's content size in case the layout has changed.
    fileprivate func adjustScrollView(numPages: Int) {
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(numPages), height: scrollView.frame.height - topFrame.frame.height)
        self.numPages = numPages
        if numPages <= 0{
            currentPage = 0
        }
        if pageToJump > 0{
            currentPage = pageToJump
            pageToJump = 0 //Reset. Not to use twice
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(currentPage), y: 0.0), animated: true)
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
        if firstRun {
            self.delegate?.imageGallery(completion: { (galleryData) in
                self.mImageGalleryData = galleryData
                    self.adjustScrollView(numPages: galleryData?.count ?? 0)
            })
            firstRun = false
        }
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
    func imageGallery(completion: @escaping ([ImageGalleryData]?) -> Void)
}
