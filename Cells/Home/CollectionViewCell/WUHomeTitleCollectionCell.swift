//
//  WUHomeTitleCollectionCell.swift
//  Wussup
//
//  Created by MAC219 on 4/18/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - Delegate
protocol WUHomeTitleCollectionCellDelegate : class {
    func homeTilteCollectionCellLiveCamButtonClicked(cell : WUHomeTitleCollectionCell, withVenueCategory venueCategory : Any)
    func goToClaimBussinessScreenWithArtEntVenue(_ venue : WUVenue)
}

extension WUHomeTitleCollectionCellDelegate{
    func homeTilteCollectionCellLiveCamButtonClicked(cell : WUHomeTitleCollectionCell, withVenueCategory venueCategory : Any){
        
    }
    func goToClaimBussinessScreenWithArtEntVenue(_ venue : WUVenue){
        
    }
}

class WUHomeTitleCollectionCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet private weak var imageViewTitle   : UIImageView!
    @IBOutlet private weak var buttonDistance   : UIButton!
    @IBOutlet private weak var labelTitle       : UILabel!
    @IBOutlet private weak var buttonVideo      : UIButton!
  
//    @IBOutlet weak var viewClaimABusinessAlert  : UIView!
//    @IBOutlet weak var viewBlackDetail          : UIView!
//    @IBOutlet weak var buttonClaimThisBusiness  : UIButton!
    
    // MARK: - Variables
    weak var delegate                           : WUHomeTitleCollectionCellDelegate?

    var venueProfileDetail : WUVenueLocalPromotions! {
        didSet{
            self.setCellDetailOfVenueProfile()
        }
    }
    
    var venueLiveCamsOrArtEntmt : Any! {
        didSet{
            self.setCellDetail()
        }
    }

    
    // MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInterfaceSetUp()
    }
    
    //MARK: - Initial Interface SetUp
    private func initialInterfaceSetUp() {
        self.buttonDistance.backgroundColor = .buttonDistanceColor
//        if self.viewClaimABusinessAlert.isHidden == false{
//            self.buttonClaimThisBusiness.tintColor = .LoalPromosColor
//            self.buttonClaimThisBusiness.backgroundColor = .ClaimThisBusinessColor
//            self.buttonClaimThisBusiness.layer.borderColor = UIColor.LoalPromosColor.cgColor
//            self.viewClaimABusinessAlert.layer.borderColor = UIColor.LoalPromosColor.cgColor
//        }
    }
    
    private func setCellDetail() {
        self.buttonDistance.isHidden = false
//        self.viewClaimABusinessAlert.isHidden = true

        if self.venueLiveCamsOrArtEntmt is WUVenueLiveCams {
            self.buttonDistance.isHidden = true
            self.buttonVideo.isHidden = true
            if (self.venueLiveCamsOrArtEntmt as! WUVenueLiveCams).LiveCamURL != "" {
                self.buttonVideo.isHidden = false
            }
            self.labelTitle.text  = (self.venueLiveCamsOrArtEntmt as! WUVenueLiveCams).Name
            self.imageViewTitle.sd_setShowActivityIndicatorView(true)
            self.imageViewTitle.sd_setIndicatorStyle(.white)
            self.imageViewTitle.sd_setImage(with:URL(string:(self.venueLiveCamsOrArtEntmt as! WUVenueLiveCams).ImageURL) , placeholderImage: UIImage(named:"placeholder.png" ))
        }else if self.venueLiveCamsOrArtEntmt is WUVenue {
             self.buttonVideo.isHidden = true
            if (self.venueLiveCamsOrArtEntmt as! WUVenue).LiveCamsURLs.count > 0 {
                self.buttonVideo.isHidden = false
            }
            self.imageViewTitle.sd_setShowActivityIndicatorView(true)
            self.imageViewTitle.sd_setIndicatorStyle(.white)
            let coverImage = (self.venueLiveCamsOrArtEntmt as! WUVenue).VenueImages.filter({$0.IsConverPhoto.toBool() == true})
            if coverImage.count > 0 {
                self.imageViewTitle.sd_setImage(with: URL(string: coverImage[0].SquareImage), placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto") , options: [SDWebImageOptions.cacheMemoryOnly])
            }else {
                self.imageViewTitle.image = #imageLiteral(resourceName: "NullState_CoverPhoto")
            }
//            self.imageViewTitle.sd_setImage(with: URL(string:(self.venueLiveCamsOrArtEntmt as! WUVenue).VenueImages.count > 0 ? (self.venueLiveCamsOrArtEntmt as! WUVenue).VenueImages[0].SquareImage : ""), placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto"), options: [SDWebImageOptions.cacheMemoryOnly])
            
            self.buttonDistance.backgroundColor = UIColor.buttonDistanceColor
            self.buttonDistance.setTitle(NSString(format: "%0.2f Mi", Float((self.venueLiveCamsOrArtEntmt as! WUVenue).VenueDistance) ?? 0) as String, for:.normal)
            self.labelTitle.text = (self.venueLiveCamsOrArtEntmt as! WUVenue).VenueName
            
//            if (self.venueLiveCamsOrArtEntmt as! WUVenue).IsSponseredVenues.toBool() == false && (self.venueLiveCamsOrArtEntmt as! WUVenue).IsClaimVenue.toBool() == false {
//                self.viewClaimABusinessAlert.isHidden = false
//            }
        } else {
//            self.viewClaimABusinessAlert.isHidden = true
            self.buttonVideo.isHidden = true
            if (self.venueLiveCamsOrArtEntmt as! WUEventDetail).LiveCamsURL.count > 0 {
                self.buttonVideo.isHidden = false
            }
            self.buttonDistance.backgroundColor = UIColor.buttonDistanceColor
            self.buttonDistance.setTitle(NSString(format: "%0.2f Mi", Float((self.venueLiveCamsOrArtEntmt as! WUEventDetail).DirectionDetail.Distance) ?? 0) as String, for:.normal)
            self.labelTitle.text = (self.venueLiveCamsOrArtEntmt as! WUEventDetail).Name
            self.imageViewTitle.sd_setShowActivityIndicatorView(true)
            self.imageViewTitle.sd_setIndicatorStyle(.white)
            self.imageViewTitle.sd_setImage(with:URL(string:(self.venueLiveCamsOrArtEntmt as! WUEventDetail).ConverPhotoURL) , placeholderImage: UIImage(named:"placeholder.png" ))
        }
    }
    
    private func setCellDetailOfVenueProfile()  {
        self.buttonDistance.isHidden = true
        self.labelTitle.isHidden = true
        self.imageViewTitle.sd_setShowActivityIndicatorView(true)
        self.imageViewTitle.sd_setIndicatorStyle(.white)
        self.imageViewTitle.sd_setImage(with:URL(string:venueProfileDetail.ImageURL) , placeholderImage: UIImage(named:"placeholder.png" ))
    }
    
    //MARK: - Action Methods
    @IBAction func buttonVideoAction(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.homeTilteCollectionCellLiveCamButtonClicked(cell: self, withVenueCategory: venueLiveCamsOrArtEntmt)
        }
    }
    
//    @IBAction func buttonClaimThisBusinessAction(_ sender: Any) {
//        if let delegate = self.delegate {
//            delegate.goToClaimBussinessScreenWithArtEntVenue(self.venueLiveCamsOrArtEntmt as! WUVenue)
//        }
//    }
}
