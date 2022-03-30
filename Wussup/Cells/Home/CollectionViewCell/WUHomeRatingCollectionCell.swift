//
//  WUHomeRatingCollectionCell.swift
//  Wussup
//
//  Created by MAC219 on 4/18/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - Delegate
protocol WURatingCollectionCellDelegate : class {
    func ratingCollectionCell(ratingCollectionCell : WUHomeRatingCollectionCell, didChangeRating newRating : Int)
    func ratingCollectionCellLiveCamButtonClicked(cell : WUHomeRatingCollectionCell, withVenueCategory venueCategory : Any)
    func goToClaimBussinessScreenWithVenue(_ venue : WUVenue)
}

extension WURatingCollectionCellDelegate {
    func ratingCollectionCell(ratingCollectionCell : WUHomeRatingCollectionCell, didChangeRating newRating : Int){
    }
    
    func ratingCollectionCellLiveCamButtonClicked(cell : WUHomeRatingCollectionCell, withVenueCategory venueCategory : Any){
    }
    
    func goToClaimBussinessScreenWithVenue(_ venue : WUVenue){
    }
}

class WUHomeRatingCollectionCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var imageViewRating  : UIImageView!
    @IBOutlet private weak var buttonDistance   : UIButton!
    @IBOutlet private weak var buttonVideo      : UIButton!
    @IBOutlet private weak var labelTitle       : UILabel!
    @IBOutlet private weak var viewStarRating   : DXStarRatingView!
    
//    @IBOutlet weak var viewClaimABusinessAlert: UIView!
//    @IBOutlet weak var viewBlackDetail: UIView!
//    @IBOutlet weak var buttonClaimThisBusiness: UIButton!
    
    // MARK: - Variables
    weak var delegate                           : WURatingCollectionCellDelegate?
    
    var venue : WUVenue! {
        didSet{
            self.setCellDetail()
        }
    }
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInterfaceSetUp()
    }
    
    @objc func didChangeRating(_newRating: NSNumber?) {
        self.delegate?.ratingCollectionCell(ratingCollectionCell: self, didChangeRating:_newRating as! Int)
        Utill.printInTOConsole(printData:"didChangeRating: \(_newRating ?? 0)")
    }
    
    
    //MARK: - Initial Interface SetUp
    
    private func initialInterfaceSetUp() {
        self.viewStarRating.isUserInteractionEnabled = false
        self.buttonDistance.backgroundColor = .buttonDistanceColor
//        if self.viewClaimABusinessAlert.isHidden == false{
//            self.buttonClaimThisBusiness.tintColor = .LoalPromosColor
//            self.buttonClaimThisBusiness.backgroundColor = .ClaimThisBusinessColor
//            self.buttonClaimThisBusiness.layer.borderColor = UIColor.LoalPromosColor.cgColor
//            self.viewClaimABusinessAlert.layer.borderColor = UIColor.LoalPromosColor.cgColor
//        }
    }
    
    private func setCellDetail() {
        self.buttonVideo.isHidden = true
        if self.venue.LiveCamsURLs.count > 0 {
            self.buttonVideo.isHidden = false
        }
//        self.imageViewRating.sd_setShowActivityIndicatorView(true)
//        self.imageViewRating.sd_setIndicatorStyle(.white)
        self.imageViewRating.sd_imageIndicator = SDWebImageActivityIndicator.white
        let coverImage = self.venue.VenueImages.filter({$0.IsConverPhoto.toBool() == true})
        if coverImage.count > 0 {
            self.imageViewRating.sd_setImage(with: URL(string: coverImage[0].SquareImage), placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto") , options: .refreshCached)
        }else {
            self.imageViewRating.image = #imageLiteral(resourceName: "NullState_CoverPhoto")
        }
        
        //        self.imageViewRating.sd_setImage(with: URL(string:self.venue.VenueImages.count > 0 ? self.venue.VenueImages[0].SquareImage : ""), placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto"), options: [SDWebImageOptions.cacheMemoryOnly])
        self.buttonDistance.backgroundColor = UIColor.buttonDistanceColor
        self.buttonDistance.setTitle(NSString(format: "%0.2f Mi", Float(self.venue.VenueDistance) ?? 0) as String, for:.normal)
        self.labelTitle.text = venue.VenueName
        
        self.viewStarRating.setStars(Int32(Float(self.venue.VenueRating) ?? 0) , target: self, callbackAction:  #selector(didChangeRating(_newRating:)))
        
        /*self.viewClaimABusinessAlert.isHidden = true
        
        if self.venue.IsSponseredVenues.toBool() == false && self.venue.IsClaimVenue.toBool() == false
        {
            self.viewClaimABusinessAlert.isHidden = false
        }*/
    }
    
    //MARK: - Action Methods
    @IBAction func buttonVideoAction(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.ratingCollectionCellLiveCamButtonClicked(cell: self, withVenueCategory: self.venue)
        }
    }
    
//    @IBAction func buttonClaimThisBusinessAction(_ sender: Any) {
//        if let delegate = self.delegate {
//            delegate.goToClaimBussinessScreenWithVenue(self.venue)
//        }
//    }
}


