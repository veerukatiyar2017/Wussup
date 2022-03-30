//
//  WUSearchSectionHeaderView.swift
//  Wussup
//
//  Created by MAC219 on 5/3/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUSearchSectionHeaderView: UIView {

    //MARK: - IBOutlet
    @IBOutlet weak var labelSectionTitle: UILabel!

    //MARK: - Load Methods
    class func instanceFromNib() -> WUSearchSectionHeaderView {
        return UINib(nibName: Utill.getClassNameFor(classType: WUSearchSectionHeaderView()), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WUSearchSectionHeaderView
    }
}
