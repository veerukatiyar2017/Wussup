//
//  WUHomeSliderCollectionCell.swift
//  Wussup
//
//  Created by MAC219 on 4/20/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class WUHomeSliderCollectionCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var imageViewSlider      : UIImageView!
    @IBOutlet private weak var buttonNewPromos      : UIButton!
    var isNewPromos : Bool = false
    // MARK: - Variables
    var venueLocalPromotion : Any! {
        didSet{
            self.setCellDetail()
        }
    }
    
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonNewPromos.backgroundColor = UIColor.buttonDistanceColor
        self.buttonNewPromos.dropBlcakShadow()
    }
    
    //MARK: - Initial Interface SetUp
    private func initialInterfaceSetUp() {
        
    }
    
    private func setCellDetail() {
        self.buttonNewPromos.isHidden = true
//        self.imageViewSlider.sd_setShowActivityIndicatorView(true)
//        self.imageViewSlider.sd_setIndicatorStyle(.white)
        self.imageViewSlider.sd_imageIndicator = SDWebImageActivityIndicator.white
        
        if self.venueLocalPromotion is WUVenueLocalPromotions {
            if isNewPromos == true{
               if (self.venueLocalPromotion as! WUVenueLocalPromotions).HasRead.toBool() == false{
                    self.buttonNewPromos.isHidden = false
                }
            }
            self.imageViewSlider.sd_setImage(with: URL(string:(self.venueLocalPromotion as! WUVenueLocalPromotions).ImageURL),
                                             placeholderImage:#imageLiteral(resourceName: "NullState_Banner"),
                                             options: .refreshCached)
        } else if self.venueLocalPromotion is WUHomeBannerList {
            self.imageViewSlider.sd_setImage(with: URL(string:(self.venueLocalPromotion as! WUHomeBannerList).ImageURL),
                                             placeholderImage:UIImage(named:"placeholder.png" ),
                                             options: .refreshCached)
        } else {
            self.imageViewSlider.sd_setImage(with: URL(string:(self.venueLocalPromotion as! WUVenueSpecials).ImageURL),
                                             placeholderImage:UIImage(named:"placeholder.png" ),
                                             options: .refreshCached)
        }
    }
}
