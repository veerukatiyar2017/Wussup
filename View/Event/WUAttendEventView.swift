//
//  WUAttendEventView.swift
//  Wussup
//
//  Created by MAC219 on 5/28/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUAttendEventView: UIView {
    
    //MARK: - Load Methods
    override func awakeFromNib() {
    }
    
    class func instanceFromNib() -> WUAttendEventView {
        return UINib(nibName: Utill.getClassNameFor(classType: WUAttendEventView()), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WUAttendEventView
    }
    
    // MARK: - Action Methods
    @IBAction func buttonMayBeAction(_ sender: Any) {
        
    }
    @IBAction func buttonYesAction(_ sender: Any) {
        
    }
}
