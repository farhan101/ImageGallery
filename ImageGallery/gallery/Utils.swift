
import Foundation
import UIKit



extension String
{
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    //Encode URLs with white spaces in them
    func spaceEncode() -> String?
    {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    func budgetDollars() -> String?{
        if self.trim() == ""{
            return self
        }
        return String(repeating: "$", count: Int(Double(self)!))
    }
}
//UIView
extension UIView{
    
    var w:CGFloat {
        get {
            
            return frame.width
            
        }
        set {
            
            frame.size.width = newValue
            
        }
    }
    var h:CGFloat {
        get {
            
            return frame.height
            
        }
        set {
            
            frame.size.height = newValue
            
        }
    }
    var x:CGFloat {
        get {
            
            return frame.origin.x
            
        }
        set {
            
            frame.origin.x = newValue
            
        }
    }
    var y:CGFloat {
        get {
            
            return frame.origin.y
            
        }
        set {
            
            frame.origin.y = newValue
            
        }
    }
    

    
}
//UIScreen
extension UIScreen {
    class var w:CGFloat {
        get {
            return UIScreen.main.bounds.width
        }
    }
    
    class var h:CGFloat {
        get {
            return UIScreen.main.bounds.height
        }
    }
}


