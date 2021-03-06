//
//  WULiveCamGridCollectionCell.swift
//  Wussup
//
//  Created by MAC219 on 7/17/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class WULiveCamGridCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewSeparator: UIView!
    
//    var  liveCamVenue: WUVenueLiveCams!{
//        didSet{
//            self.setCellDetail()
//        }
//    }
    var  liveCamVenue: [String: Any]!{
        didSet{
            self.setCellDetail()
        }
    }
    
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInterfaceSetUp()
    }
    
    
    
    //MARK: - Initial Interface SetUp
    
    private func initialInterfaceSetUp() {
        self.viewSeparator.backgroundColor = .LiveCamSepratorColor
    }
    
    private func setCellDetail() {
        self.imageViewIcon.sd_imageIndicator = SDWebImageActivityIndicator.white
//        self.imageViewIcon.sd_setIndicatorStyle(.white)
//        self.imageViewIcon.sd_setShowActivityIndicatorView(true)
        
        if let youtubeURL = self.liveCamVenue["url"] as? String, youtubeURL != "" {
            let fullNameArr = youtubeURL.split(separator: "=")
            print(fullNameArr.count)
            if fullNameArr.count > 1 {
                var firstName: String = String(fullNameArr[0])
                var youtubeId: String = String(fullNameArr[1])
                print(youtubeId)
                let thumbnilURl = "http://img.youtube.com/vi/\(youtubeId)/0.jpg"
                self.imageViewIcon.sd_setImage(with: URL(string: thumbnilURl), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: .refreshCached)
                print(thumbnilURl)
            }
        }
        self.labelTitle.text = self.liveCamVenue["name"] as? String
    }
}
