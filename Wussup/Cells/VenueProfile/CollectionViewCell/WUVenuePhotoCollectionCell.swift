//
//  WUVenuePhotoCollectionCell.swift
//  Wussup
//
//  Created by MAC219 on 5/17/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class WUVenuePhotoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    var enableCornerRadius : Bool = false{
        didSet{
            if enableCornerRadius == false {
                self.imageViewPhoto.layer.cornerRadius = 0
            }else{
                self.imageViewPhoto.layer.cornerRadius = 7.0
            }
        }
    }
    
    var venueImage : WUVenueImages! {
        didSet{
            self.setCellDetail()
        }
    }
    
    var eventPhotos : WUEventPhotos! {
        didSet{
            self.setEventCellDetail()
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Initial Interface SetUp
    private func initialInterfaceSetUp() {
        
    }
    
    private func setCellDetail()  {
        self.imageViewPhoto.sd_imageIndicator = SDWebImageActivityIndicator.white
//        self.imageViewPhoto.sd_setShowActivityIndicatorView(true)
//        self.imageViewPhoto.sd_setIndicatorStyle(.white)
        
        self.imageViewPhoto.sd_setImage(with:URL(string:self.venueImage.SquareImage) , placeholderImage:#imageLiteral(resourceName: "NullState_Photos"))
    }
    private func setEventCellDetail(){
        self.imageViewPhoto.sd_imageIndicator = SDWebImageActivityIndicator.white
//        self.imageViewPhoto.sd_setShowActivityIndicatorView(true)
//        self.imageViewPhoto.sd_setIndicatorStyle(.white)
        self.imageViewPhoto.sd_setImage(with:URL(string:self.eventPhotos.ImageURL) , placeholderImage: UIImage(named:"placeholder.png" ))
    }
    
}
