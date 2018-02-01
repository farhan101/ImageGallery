//
//  GlobalData.swift
//  Sufi
//
//  Created by MacMini on 3/6/17.
//  Copyright © 2017 tossdown. All rights reserved.
//

import Foundation
import UIKit

class GlobalData {
    
    
    static let sharedInstance: GlobalData = {
        let instance = GlobalData()
        return instance
    }()
    
    // Can't init is singleton
    private init() {

        pImageCache = NSCache<AnyObject, AnyObject>()

    }

    var pImageCache: NSCache<AnyObject, AnyObject>
    

}
