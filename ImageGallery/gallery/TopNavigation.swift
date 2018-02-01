//
//  TopNavigation.swift
//  tossdown
//
//  Created by MacMini on 7/24/17.
//  Copyright © 2017 tossdown. All rights reserved.
//

import UIKit

class TopNavigation: UIView {

    @IBOutlet weak var mlblTitle: UILabel!
    @IBOutlet weak var pvuCurtain: UIView!
    @IBOutlet weak var mbtnLeft: UIButton!
    class func instanceFromNib() -> TopNavigation {
        return UINib(nibName: "TopNavigation", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TopNavigation
    }

    override func layoutSubviews() {
        
        self.frame.size.width = UIScreen.main.bounds.width
        self.frame.origin.y = 0
        self.frame.origin.x = 0
       
        pvuCurtain.frame.origin.x = 0
        pvuCurtain.frame.origin.y = 0
        pvuCurtain.frame.size = CGSize(width: UIScreen.main.bounds.width, height: self.frame.height)
        pvuCurtain.isHidden = true
        self.addSubview(pvuCurtain)
        
    }
    func dropCurtain(){
        
        pvuCurtain.isHidden = false
       
        
    }
    func liftCurtain(){
        pvuCurtain.isHidden = true
    }

}
