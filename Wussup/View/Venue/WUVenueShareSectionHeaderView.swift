//
//  WUVenueShareSectionHeaderView.swift
//  Wussup
//
//  Created by MAC219 on 5/10/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUVenueShareSectionHeaderView: UITableViewHeaderFooterView {
    
    //MARK: - IBOutlet
    @IBOutlet weak var labelSectionTitle: UILabel!
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    //MARK: - Load Methods
    class func instanceFromNib() -> WUVenueShareSectionHeaderView {
        return UINib(nibName: Utill.getClassNameFor(classType: WUVenueShareSectionHeaderView()), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WUVenueShareSectionHeaderView
    }
   
    func showInView(superView : UIView , at point : CGPoint ) {
        self.frame = CGRect(origin: point, size: CGSize(width: 100, height: 150))
        superView.addSubview(self)
        self.alpha = 0.0
        self.transform = (self.transform).scaledBy(x: 1/1.4, y: 1/1.4)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .beginFromCurrentState] , animations: {
            self.transform = (self.transform).scaledBy(x: 1.4, y: 1.4)
            self.alpha = 1.0
        }, completion: nil)
    }
}
