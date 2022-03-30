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
    @IBOutlet weak var buttonNewPromos      : UIButton!
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
    
    func markPromoAsRead(){
         ///Hide "New Promos" box
            if (self.venueLocalPromotion as! WUVenueLocalPromotions).HasRead.toBool() == false && (self.venueLocalPromotion as! WUVenueLocalPromotions).NotificationID != 0{
                
                self.callWS_MarkOneNotificationAsRead(notificationID: (self.venueLocalPromotion as! WUVenueLocalPromotions).NotificationID)
                let deadline: DispatchTime = .now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    self.buttonNewPromos.isHidden = true
                }
            }
     }
    
    
    private func callWS_MarkOneNotificationAsRead(notificationID: Int){
            WEB_API.call_api_MarkOneNotificationAsRead(user: Utill.getUserModel()!, notificationID: notificationID){ (response, success, message) in
                if success == true {
                    print("Sucess callWS_MarkOneNotificationAsRead")
                    
                    if GlobalShared.notifciationCount > 0 {

                        if GlobalShared.notifciationCount > 0 {
                            GlobalShared.notifciationCount = response!["TotalUnreadCount"].intValue
                            UIApplication.shared.applicationIconBadgeNumber = GlobalShared.notifciationCount
                            
                            if GlobalShared.notifciationCount == 0 {
                                GlobalShared.appTabbarController?.buttonNotificationCount.isHidden = true
                            } else {
                                GlobalShared.appTabbarController?.buttonNotificationCount.isHidden = false
                                GlobalShared.appTabbarController?.buttonNotificationCount.setTitle("\(GlobalShared.notifciationCount)", for: .normal)
                            }
                        }
                        
                    }
                    
                } else {
                    print(" Not Sucess callWS_MarkOneNotificationAsRead")
                }
            }
    }
    
    
    private func setCellDetail() {
        self.buttonNewPromos.isHidden = true
        self.imageViewSlider.sd_setShowActivityIndicatorView(true)
        self.imageViewSlider.sd_setIndicatorStyle(.white)
        
        if self.venueLocalPromotion is WUVenueLocalPromotions {
            if isNewPromos == true{

               if (self.venueLocalPromotion as! WUVenueLocalPromotions).HasRead.toBool() == false && (self.venueLocalPromotion as! WUVenueLocalPromotions).NotificationID != 0{
                    self.buttonNewPromos.isHidden = false
                }
            }
            self.imageViewSlider.sd_setImage(with: URL(string:(self.venueLocalPromotion as! WUVenueLocalPromotions).ImageURL),
                                             placeholderImage:#imageLiteral(resourceName: "NullState_Banner"),
                                             options: [SDWebImageOptions.cacheMemoryOnly])
        } else if self.venueLocalPromotion is WUHomeBannerList {
            self.imageViewSlider.sd_setImage(with: URL(string:(self.venueLocalPromotion as! WUHomeBannerList).ImageURL),
                                             placeholderImage:UIImage(named:"placeholder.png" ),
                                             options: [SDWebImageOptions.cacheMemoryOnly])
        } else {
            self.imageViewSlider.sd_setImage(with: URL(string:(self.venueLocalPromotion as! WUVenueSpecials).ImageURL),
                                             placeholderImage:UIImage(named:"placeholder.png" ),
                                             options: [SDWebImageOptions.cacheMemoryOnly])
        }
    }
}
