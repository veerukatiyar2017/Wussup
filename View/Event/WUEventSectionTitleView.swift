//
//  WUEventSectionTitleView.swift
//  Wussup
//
//  Created by MAC219 on 6/4/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUEventSectionTitleView: UIView {
    
    //MARK: - IBOutlet
    @IBOutlet weak var labelTitle: UILabel!
 
    //MARK: - Load Methods
    class func instanceFromNib() -> WUEventSectionTitleView {
        return UINib(nibName: Utill.getClassNameFor(classType: WUEventSectionTitleView()), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WUEventSectionTitleView
    }
}
