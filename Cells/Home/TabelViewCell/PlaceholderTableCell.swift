//
//  PlaceholderTableCell.swift
//  Wussup
//
//  Created by Serik on 5/9/19.
//  Copyright © 2019 MAC26. All rights reserved.
//

import UIKit

class PlaceholderTableCell: UITableViewCell {

    @IBOutlet private weak var viewContainer    : UIView!
    @IBOutlet private weak var placeholderView  : UIImageView!

    var placeholderCardAds: WUPlaceholder? {
        didSet {
            self.setCellDetail()
        }
    }
 
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialInterfaceSetUp()
    }
    
    //MARK: - Initial Interface SetUp
    
    private func initialInterfaceSetUp() {
        self.viewContainer.dropShadow()
    }
    
    private func setCellDetail() {
        
        guard let url = self.placeholderCardAds?.Url else {
            //self.placeholderView.image = UIImage.init(named: "UniversalPlaceholder")
            return
        }
        self.placeholderView.sd_setImage(with: URL(string: url), completed: nil)
    }
}
