//
//  PhotoGallery.swift
//  tossdown
//
//  Created by MacMini on 8/24/17.
//  Copyright © 2017 tossdown. All rights reserved.
//

import UIKit



class PhotoGallery: UIViewController, UIScrollViewDelegate, ImageLoaderProtocol  {
    
    struct Image{
        
        var url: String
        
        init(){
            url = ""
        }
    }

    
    @IBOutlet weak var mlblCount: UILabel!
    fileprivate var mTopNavigation: TopNavigation?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    let imageLoader: ImageLoader = ImageLoader()

    fileprivate var numPages = 0
    fileprivate var pages = [ImageScrollView?]()
    fileprivate var infoCard = [UIView?]()
    
    //Set this property if need a jump to a specific image
    var jumpToImage: Int = -1
    

    var delegate: PhotoGalleryProtocol!
    var needInfoView: Bool = false
    //Set this property before presenting the control
    var images: NSMutableArray?{
        didSet{
            
            numPages = (images?.count)!
            pages = [ImageScrollView?](repeating: nil, count: numPages)
            if needInfoView {
                
                infoCard = [UIView?](repeating: nil, count: numPages)
                
            }
            
        }
    }

    fileprivate var transitioning = false

    // MARK: - View Controller Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if mTopNavigation == nil {
            
            for index in 0 ... (numPages - 1){
                
                //Photos
                var frame = scrollView.frame
                // Offset the frame's X origin to its correct page offset.
                frame.origin.x = frame.width * CGFloat(index)
                // Set frame's y origin value to take into account the top layout guide.
                frame.origin.y = -self.topLayoutGuide.length
                frame.size.height += self.topLayoutGuide.length
                let canvasView = ImageScrollView(frame: frame)
                let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapRecognizer(_ :)))
                tap.numberOfTapsRequired = 1
                canvasView.addGestureRecognizer(tap)
                let doubleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapRecognizer(_ :)))
                doubleTap.numberOfTapsRequired = 2
                canvasView.addGestureRecognizer(doubleTap)
                tap.require(toFail: doubleTap)
                scrollView.addSubview(canvasView)
                pages[index] = canvasView
                imageLoader.load(Image: (images?[index] as? Image)!.url, shouldReturnURL: true)
                

                //Deals
                if needInfoView {
                    
                    let infoView = delegate.photoGalleryProtocol(createInstance: true, frame: scrollView.frame, infoIndex: index)
                    infoView.x = scrollView.frame.width * CGFloat(index)
                    let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapRecognizer(_ :)))
                    tap.numberOfTapsRequired = 1
                    tap.delaysTouchesBegan = true
                    infoView.addGestureRecognizer(tap)
                    scrollView.addSubview(infoView)
                    infoCard[index] = infoView
                    //imageLoader.load(Image: (images?[index] as? Image)!.url, shouldReturnURL: true)
                    
                }
                
   
            }

            prepareNavigation()

        }
        
        /**
         Setup the initial scroll view content size and first pages only once.
         (Due to this function called each time views are added or removed).
         */


        _ = self.setupInitialPages
    }
    
    @objc func singleTapRecognizer(_ tap: UITapGestureRecognizer){
    
        if needInfoView {
            let pageWidth = scrollView.frame.width
            let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            let infoView =  infoCard[Int(page)]
            infoView?.isHidden = !(infoView?.isHidden)!
        }
        
  
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         View controllers are created lazily, in the meantime, load the array with
         placeholders which will be replaced on demand.
         */
        
//        pages = [ImageScrollView?](repeating: nil, count: numPages)
//        pageControl.numberOfPages = numPages
//        pageControl.currentPage = 0
        
        pageControl.numberOfPages = numPages
        pageControl.currentPage = 0
        
        imageLoader.delegate = self
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    
    lazy var setupInitialPages: Void = {
        /**
         Setup our initial scroll view content size and first pages once.
         
         Layout the scroll view's content size after we have knowledge of the topLayoutGuide dimensions.
         Each page is the width and height of the scroll view's frame.
         
         Note: Set the scroll view's content size to take into account the top layout guide.
         */
        self.adjustScrollView()
        
        if self.jumpToImage != -1 {
        
            self.gotoPage(page: self.jumpToImage, animated: false)
            
        }else{
            
            self.gotoPage(page: 0, animated: true)
        }
        
        // Pages are created on demand, load the visible page and next page.
        //self.loadPage(0)
        //self.loadPage(1)
        
    }()
    
    // MARK: - Utilities
    
    fileprivate func removeAnyImages() {
        for page in pages where page != nil {
            page?.removeFromSuperview()
        }
    }
    
    /// Readjust the scroll view's content size in case the layout has changed.
    fileprivate func adjustScrollView() {
        scrollView.contentSize =
            CGSize(width: scrollView.frame.width * CGFloat(numPages),
                   height: scrollView.frame.height - topLayoutGuide.length)
    }
    
    // MARK: - Transitioning
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        
//        /**
//         Since we transitioned to a different screen size we need to reconfigure the scroll view content.
//         Remove any the pages from our scrollview's content.
//         */
//        removeAnyImages()
//        
//        coordinator.animate(alongsideTransition: nil) { _ in
//            // Adjust the scroll view's contentSize (larger or smaller) depending on the new transition size.
//            self.adjustScrollView()
//            
//            // Clear out and reload the relevant pages.
//            self.pages = [ImageScrollView?](repeating: nil, count: self.numPages)
//            
//            self.transitioning = true
//            
//            // Go to the appropriate page (but with no animation).
//            self.gotoPage(page: self.pageControl.currentPage, animated: false)
//            
//            self.transitioning = false
//        }
//        
//        super.viewWillTransition(to: size, with: coordinator)
//    }
    
    // MARK: - Page Loading
    
    fileprivate func loadPage(_ page: Int) {
        guard page < numPages && page != -1 else { return }
        
        //Count at the bottom e.g. 2 / 20
        mlblCount.text = ("\(page + 1) / \(images?.count.description ?? "")")
        
        if pages[page] == nil {
            
            var frame = scrollView.frame
            // Offset the frame's X origin to its correct page offset.
            frame.origin.x = frame.width * CGFloat(page)
            // Set frame's y origin value to take into account the top layout guide.
            frame.origin.y = -self.topLayoutGuide.length
            frame.size.height += self.topLayoutGuide.length
            let canvasView = ImageScrollView(frame: frame)
            scrollView.addSubview(canvasView)
            pages[page] = canvasView
            
            imageLoader.load(Image: (images?[page] as? Image)!.url, shouldReturnURL: true)

        }else{
            
            
            imageLoader.load(Image: (images?[page] as? Image)!.url, shouldReturnURL: true)

        }
    }
    
    fileprivate func loadCurrentPages(page: Int) {
        // Load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling).
        
        // Don't load if we are at the beginning or end of the list of pages.
        //guard (page > 0 && page + 1 < numPages) || transitioning else { return }
        
        // Remove all of the images and start over.
//        removeAnyImages()
//        pages = [ImageScrollView?](repeating: nil, count: numPages)
        
        // Load the appropriate new pages for scrolling.
        //loadPage(Int(page) - 1)
        loadPage(Int(page))
        //loadPage(Int(page) + 1)
    }
    
    fileprivate func gotoPage(page: Int, animated: Bool) {
        loadCurrentPages(page: page)
        
        // Update the scroll view scroll position to the appropriate page.
        var bounds = scrollView.bounds
        bounds.origin.x = bounds.width * CGFloat(page)
        bounds.origin.y = 0
        scrollView.scrollRectToVisible(bounds, animated: animated)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Switch the indicator when more than 50% of the previous/next page is visible.
        let pageWidth = scrollView.frame.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        pageControl.currentPage = Int(page)
        
        loadCurrentPages(page: pageControl.currentPage)
        
    }
    
    // MARK: - Actions
    
    @IBAction func gotoPage(_ sender: UIPageControl) {
        // User tapped the page control at the bottom, so move to the newer page, with animation.
        gotoPage(page: sender.currentPage, animated: true)
    }


    func imageLoader(image: UIImage?, url: String?) {
        
        DispatchQueue.main.async {
            guard (image != nil) else{
                return
            }
            let indexes = self.images?.indexesOfObjects(options: [], passingTest: { (obj, index, stop: UnsafeMutablePointer<ObjCBool>) -> Bool in
                
                let img = obj as? Image
                if img?.url == url {
                    stop.pointee = true
                    return true
                }
                return false
            })
            
            let canvasView = self.pages[(indexes?.first?.littleEndian)!]
            canvasView?.display(image: image!)
            
        
        }
        

    }


    func prepareNavigation(){
        
        mTopNavigation = TopNavigation.instanceFromNib()
        mTopNavigation?.mbtnLeft.addTarget(self, action: #selector(btnBack), for: .touchUpInside)
        self.view.addSubview(mTopNavigation!)
        
    }
    @objc func btnBack(_ sender: UIButton){
        
        self.dismiss(animated: true, completion: nil)
        
    }


}

protocol PhotoGalleryProtocol{
    
    func photoGalleryProtocol(createInstance: Bool, frame: CGRect, infoIndex: Int) -> UIView
    
}


