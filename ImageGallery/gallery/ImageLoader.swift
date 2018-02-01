//
//  ImageLoader.swift
//  tossdown
//
//  Created by MacMini on 8/7/17.
//  Copyright © 2017 tossdown. All rights reserved.
//

import Foundation
import UIKit

enum ActivityIndicatorStyle{
    
    case gray
    case white
    case whiteLarge
    
}

class ImageLoader{
    
    fileprivate var mActivityIndicator: UIActivityIndicatorView?
    var delegate: ImageLoaderProtocol?
    
    init() {
        
        mActivityIndicator = UIActivityIndicatorView()
        
    }
    init(style: ActivityIndicatorStyle?=nil, color: UIColor?=nil) {
        
        mActivityIndicator = UIActivityIndicatorView()
        if let mStyle : ActivityIndicatorStyle = style{
        
            switch mStyle {
            case .gray:
                mActivityIndicator?.activityIndicatorViewStyle = .gray
                break
            case .white:
                mActivityIndicator?.activityIndicatorViewStyle = .white
                break
            case .whiteLarge:
                mActivityIndicator?.activityIndicatorViewStyle = .whiteLarge
                break
            }
            
        }
        
        
        if let mColor: UIColor = color {
         
            mActivityIndicator?.color = mColor
            
        }
    }

    static func setPlaceholder(imageView: UIImageView){
        imageView.image = UIImage(named: "placeholder")
    }
    
    func load(Image url: String, In imageView: UIImageView){
        
        imageView.image = UIImage()
        mActivityIndicator?.frame.origin.y = imageView.frame.height / 2 - (mActivityIndicator?.frame.height)! / 2
        mActivityIndicator?.frame.origin.x = imageView.frame.width / 2 - (mActivityIndicator?.frame.width)! / 2
        mActivityIndicator?.startAnimating()
        imageView.addSubview(mActivityIndicator!)
        
        let encodedURL: String = url.spaceEncode()!
        
        if (GlobalData.sharedInstance.pImageCache.object(forKey: encodedURL as AnyObject)) != nil{
            
            let cacheImage : UIImage = GlobalData.sharedInstance.pImageCache.object(forKey: encodedURL as AnyObject) as! UIImage
            imageView.image = cacheImage
            mActivityIndicator?.stopAnimating()
            
            
        }else{
            DispatchQueue.global(qos: .userInitiated).async{
                
                let imgURL = URL(string: encodedURL)
                let data = try? Data(contentsOf: imgURL!)
                
                DispatchQueue.main.async{
                    if data != nil{
                        let img : UIImage = UIImage(data: data!)!
                        imageView.image = img
                        GlobalData.sharedInstance.pImageCache.setObject(img, forKey: encodedURL as AnyObject)
                        self.mActivityIndicator?.stopAnimating()
                    }else{
                        self.mActivityIndicator?.stopAnimating()
                    }
                    
                }
                
            }
            
        }
        
    
        
        
    }
    
    func load(Image url: String){
        
        
        let encodedURL: String = url.spaceEncode()!
        
        if (GlobalData.sharedInstance.pImageCache.object(forKey: encodedURL as AnyObject)) != nil{
            
            let cacheImage : UIImage = GlobalData.sharedInstance.pImageCache.object(forKey: encodedURL as AnyObject) as! UIImage
            delegate?.imageLoader!(image: cacheImage)
            
        }else{
            DispatchQueue.global(qos: .userInitiated).async{
                
                let imgURL = URL(string: encodedURL)
                let data = try? Data(contentsOf: imgURL!)
                
                DispatchQueue.main.async{
                    if data != nil{
                        
                        let img : UIImage = UIImage(data: data!)!
                        GlobalData.sharedInstance.pImageCache.setObject(img, forKey: encodedURL as AnyObject)
                        self.delegate?.imageLoader!(image: img)
                        
                    }else{
                        
                        self.delegate?.imageLoader!(image: nil)
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }
    func load(Image url: String, shouldReturnURL: Bool){
        
        
        let encodedURL: String = url.spaceEncode()!
        
        if (GlobalData.sharedInstance.pImageCache.object(forKey: encodedURL as AnyObject)) != nil{
            
            let cacheImage : UIImage = GlobalData.sharedInstance.pImageCache.object(forKey: encodedURL as AnyObject) as! UIImage
            delegate?.imageLoader!(image: cacheImage, url: url)
            
        }else{
            DispatchQueue.global(qos: .userInitiated).async{
                
                let imgURL = URL(string: encodedURL)
                let data = try? Data(contentsOf: imgURL!)
                
                DispatchQueue.main.async{
                    if data != nil{
                        
                        let img : UIImage = UIImage(data: data!)!
                        GlobalData.sharedInstance.pImageCache.setObject(img, forKey: encodedURL as AnyObject)
                        self.delegate?.imageLoader!(image: img, url: url)
                        
                    }else{
                        
                        self.delegate?.imageLoader!(image: nil, url: url)
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }
    func load(Image url: String, completion: @escaping (UIImage?,String)->()){
        
        
        let encodedURL: String = url.spaceEncode()!
        
        if (GlobalData.sharedInstance.pImageCache.object(forKey: encodedURL as AnyObject)) != nil{
            
            let cacheImage : UIImage = GlobalData.sharedInstance.pImageCache.object(forKey: encodedURL as AnyObject) as! UIImage
            //delegate?.imageLoader!(image: cacheImage, url: url)
            completion(cacheImage, encodedURL)
            
        }else{
            DispatchQueue.global(qos: .userInitiated).async{
                
                let imgURL = URL(string: encodedURL)
                let data = try? Data(contentsOf: imgURL!)
                
                DispatchQueue.main.async{
                    if data != nil{
                        
                        let img : UIImage = UIImage(data: data!)!
                        GlobalData.sharedInstance.pImageCache.setObject(img, forKey: encodedURL as AnyObject)
                        //self.delegate?.imageLoader!(image: img, url: url)
                        completion(img, encodedURL)
                        
                    }else{
                        
                        //self.delegate?.imageLoader!(image: nil, url: url)
                        completion(nil, encodedURL)
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }

}

@objc protocol ImageLoaderProtocol{
    
    @objc optional func imageLoader(image: UIImage?)
    @objc optional func imageLoader(image: UIImage?, url: String?)
    
}


