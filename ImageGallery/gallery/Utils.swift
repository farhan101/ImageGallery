//
//  Utils.swift
//  tossdown
//
//  Created by MacMini on 7/24/17.
//  Copyright © 2017 tossdown. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore



class UTILS{
    
    
    static func makePhoneCall(phoneNumber: String){
    
    
        var editedPhoneNumber = ""
        for i in phoneNumber.characters {
            
            switch (i){
            case "0","1","2","3","4","5","6","7","8","9" : editedPhoneNumber = editedPhoneNumber + String(i)
            default : break
            }
        }
        
        if let phoneCallURL = URL(string: "tel://\(editedPhoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string:"tel://\(editedPhoneNumber)"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.openURL(url)
                        
                    }
                }
            }
            
        }
        
    
    }
    
    
    
    static func makeViewShadow(vu: UIView){
        
        //HELP: https://stackoverflow.com/questions/805872/how-do-i-draw-a-shadow-under-a-uiview
        
        
        //let radius: CGFloat = vu.frame.width / 2.0 //change it to .height if you need spread for height
        let shadowPath = UIBezierPath(rect: CGRect(x: 1, y: 1, width: vu.frame.width, height: vu.frame.height))
        //Change 2.1 to amount of spread you need and for height replace the code for height
        
        vu.layer.cornerRadius = 2
        vu.layer.shadowColor = UIColor.lightGray.cgColor
        vu.layer.shadowOffset = CGSize(width: 0.1, height: 0.1)  //Here you control x and y
        vu.layer.shadowOpacity = 0.3
        vu.layer.shadowRadius = 1.0 //Here your control your blur
        vu.layer.masksToBounds =  false
        vu.layer.shadowPath = shadowPath.cgPath
        
    }
    static func makeViewShadowBorder(vu: UIView){
        
        //HELP: https://stackoverflow.com/questions/805872/how-do-i-draw-a-shadow-under-a-uiview
        
        //let radius: CGFloat = vu.frame.width / 2.0 //change it to .height if you need spread for height
//        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2.1 * radius, height: vu.frame.height))
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: vu.frame.width, height: vu.frame.height))
        //Change 2.1 to amount of spread you need and for height replace the code for height
        
        vu.layer.cornerRadius = 2
        vu.layer.shadowColor = UIColor.black.cgColor
        vu.layer.shadowOffset = CGSize(width: 0.1, height: 0.1)  //Here you control x and y
        vu.layer.shadowOpacity = 0.2
        vu.layer.shadowRadius = 2.0 //Here your control your blur
        vu.layer.masksToBounds =  false
        vu.layer.shadowPath = shadowPath.cgPath
        
//        //let radius: CGFloat = vu.frame.width / 2.0 //change it to .height if you need spread for height
//        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: vu.frame.width, height: vu.frame.height))
//        //Change 2.1 to amount of spread you need and for height replace the code for height
//        
//        vu.layer.cornerRadius = 2
//        vu.layer.shadowColor = UIColor.lightGray.cgColor
//        vu.layer.shadowOffset = CGSize(width: 0.1, height: 0.1)  //Here you control x and y
//        vu.layer.shadowOpacity = 0.5
//        vu.layer.shadowRadius = 1.0 //Here your control your blur
//        vu.layer.masksToBounds =  false
//        vu.layer.shadowPath = shadowPath.cgPath
        
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func labelSizeFor(label: UILabel, font: UIFont, width: CGFloat, text: String) -> CGSize{
    
        label.font = font
        let desiredString : String = text
        label.text = desiredString
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        let size: CGSize = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        
        return size
    }
    class func labelFitToText(label: UILabel, font: UIFont, width: CGFloat, text: String){
        

        let size: CGSize = UTILS.labelSizeFor(label:label, font: label.font, width: width, text: text)
        
        label.w = width
        label.text = text
        
        var newFrame = label.frame
        newFrame.size = CGSize(width: max(size.width, width), height: size.height)
        label.frame = newFrame
    }
    class func getImagePlaceholder() -> UIImage{
        return UIImage(named: "placeholder")!
    }
    class func stringToDate(dateString: String, format: String = "yyyy-MM-dd HH:mm:ss") -> Date{
        let df = DateFormatter()
        df.dateFormat = format
        let date = df.date(from: dateString)
        
        return date!
    }
    class func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }

}
class Validation{
    
    static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}

extension String
{
//    func trim() -> String
//    {
//        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
//    }
    
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

//NSMutableData
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
