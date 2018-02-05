

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
