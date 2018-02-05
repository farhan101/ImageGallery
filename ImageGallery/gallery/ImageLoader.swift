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
    
    class func load(Image url: String, completion: @escaping (UIImage?,String)->()){
        
        
        let encodedURL: String = url.spaceEncode()!
        
        if (GlobalData.sharedInstance.pImageCache.object(forKey: encodedURL as AnyObject)) != nil{
            
            let cacheImage : UIImage = GlobalData.sharedInstance.pImageCache.object(forKey: encodedURL as AnyObject) as! UIImage
            
            completion(cacheImage, encodedURL)
            
        }else{
            DispatchQueue.global(qos: .userInitiated).async{
                
                let imgURL = URL(string: encodedURL)
                let data = try? Data(contentsOf: imgURL!)
                
                DispatchQueue.main.async{
                    if data != nil{
                        
                        let img : UIImage = UIImage(data: data!)!
                        GlobalData.sharedInstance.pImageCache.setObject(img, forKey: encodedURL as AnyObject)
                        
                        completion(img, encodedURL)
                        
                    }else{
                        
                        completion(nil, encodedURL)
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }

}



