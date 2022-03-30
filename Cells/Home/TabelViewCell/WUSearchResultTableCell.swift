//
//  WUSearchResultTableCell.swift
//  Wussup
//
//  Created by MAC219 on 5/23/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

// MARK: - Delegate
protocol WUSearchResultTableCellDelegate : class {
    func didSelectMoreButton(searchResultCell : WUSearchResultTableCell)
    func searchResultTableCellLiveCamButtonClicked(cell : WUSearchResultTableCell, withVenueCategory venueCategory : Any)
    func goToClaimBussinessScreenWithVenue(_ venue : WUVenue)
}
extension WUSearchResultTableCellDelegate{
    func didSelectMoreButton(searchResultCell : WUSearchResultTableCell){
        
    }
    func searchResultTableCellLiveCamButtonClicked(cell : WUSearchResultTableCell, withVenueCategory venueCategory : Any){
        
    }
    func goToClaimBussinessScreenWithVenue(_ venue : WUVenue){
    }
}

class WUSearchResultTableCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var placeholderView          : UIImageView!
    @IBOutlet private weak var viewContainer            : UIView!
    @IBOutlet private weak var imageViewOfSearchResult  : UIImageView!
    @IBOutlet private weak var buttonDistance           : UIButton!
    @IBOutlet private weak var labelPrice               : UILabel!
    @IBOutlet private weak var labelTitle               : UILabel!
    @IBOutlet private weak var labelTitleAddress        : UILabel!
    @IBOutlet private weak var viewStarRating           : DXStarRatingView! 
    @IBOutlet private weak var labelRateCount           : UILabel!
    @IBOutlet private weak var labelOpenTime            : UILabel!
    @IBOutlet private weak var buttonMore               : UIButton!
    @IBOutlet private weak var imageViewMap             : UIImageView!
    @IBOutlet weak var buttonCall                       : UIButton!
    @IBOutlet private weak var buttonVideo              : UIButton!
    @IBOutlet private weak var labelOpenNowStatus       : UILabel!
    @IBOutlet private weak var categoryNameLabel        : UILabel!

    // MARK: - Variables
    weak var delegate      : WUSearchResultTableCellDelegate?
    var searchedVenueData  : SearchVenueAndEventData!
    var venueProfileDetail : WUVenueDetail!

    var venue : WUVenue! {
        didSet{
            self.setCellDetail()
        }
    }
    
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialInterfaceSetUp()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Initial Interface SetUp
    private func initialInterfaceSetUp() {
        self.viewContainer.dropShadow()
        self.backgroundColor = UIColor.mainBackgroundColor
    }
    
    private func setCellDetail(){

        self.viewStarRating.isHidden        = false
        self.labelPrice.isHidden            = false
        self.labelOpenTime.isHidden         = false
        self.labelOpenNowStatus.isHidden    = false
       // self.buttonMore.isHidden            = true
        
        if self.venue.IsPremiumVenue == true {  // PREMIUM
            self.viewContainer.backgroundColor  = UIColor.LiveCamYellowColor // orange color
        } else {                                // FourSquare
            self.viewContainer.backgroundColor  = UIColor.white
        }
        
        self.buttonVideo.isHidden = true
        
        if self.venue.LiveCamsURLs.count > 0 {
            self.buttonVideo.isHidden = false
        }
        
        self.buttonMore.isSelected = false
        self.buttonMore.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_MoreButton, color: .BlueColor ), for: .normal)

//        self.buttonCallWidthConst.constant = 30.0.propotional
//        if venue.VenuePhone == "" {
//            self.buttonCall.isHidden = true
//            self.buttonCallWidthConst.constant = 0.0
//        }
        self.imageViewOfSearchResult.sd_setShowActivityIndicatorView(true)
        self.imageViewOfSearchResult.sd_setIndicatorStyle(.white)
        let coverImage = self.venue.VenueImages.filter({$0.IsConverPhoto.toBool() == true})
        if coverImage.count > 0 {
            self.imageViewOfSearchResult.sd_setImage(with: URL(string: coverImage[0].SquareImage), placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto") , options: [SDWebImageOptions.cacheMemoryOnly])
        }else {
            self.imageViewOfSearchResult.image = #imageLiteral(resourceName: "NullState_CoverPhoto")
        }
//        self.imageViewOfSearchResult.sd_setImage(with: URL(string: self.venue.VenueImages.count > 0 ? self.venue.VenueImages[0].SquareImage : ""), placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto"), options: [SDWebImageOptions.cacheMemoryOnly])
        self.buttonDistance.setTitle(NSString(format: "%0.2f Mi", Float(venue.VenueDistance) ?? 0) as String, for:.normal)
        self.buttonDistance.backgroundColor = UIColor.buttonDistanceColor

        self.categoryNameLabel.text = self.venue.CategoryName
        
        self.viewStarRating.setStars(Int32(Float(self.venue.VenueRating) ?? 0) ,
                                     target: self,
                                     callbackAction:  #selector(didChangeRating(_newRating:)))
        self.viewStarRating.isUserInteractionEnabled = false
        self.labelTitle.text = venue.VenueName
        
        self.labelTitleAddress.text = self.venue.VenueFullAddress
        
        if Int(self.venue.NoOfUserGiveVenueRating) ?? 0 > 0 {
            self.labelRateCount.text = "(" + self.venue.NoOfUserGiveVenueRating + ")"
        } else {
            self.labelRateCount.text = ""
        }
        self.labelPrice.text = self.venue.Price
        
        self.labelOpenTime.text = ""
        self.labelOpenNowStatus.text = ""
        
        //let filterID = self.searchedVenueData.selectedfilters.filter({$0.filterId == WUSearchFilterID.openNow.rawValue})
        //if filterID.count > 0 || self.venue.IsVenueOpen.toBool() == true {
            
            if self.venue.VenueAtOpen == "" && self.venue.VenueAtClose == "" {
                //self.labelOpenNowStatus.textColor = .RedColor
                self.labelOpenNowStatus.text = ""//Text.Label.text_Closed
                
            } else {
                // if Venue Open
                if self.venue.IsVenueOpen.toBool() == true {
                    self.labelOpenNowStatus.textColor = .OpenNowGreenColor
                    self.labelOpenNowStatus.text = Text.Label.text_Open
                } else {
                    self.labelOpenNowStatus.textColor = .RedColor
                    self.labelOpenNowStatus.text = Text.Label.text_Closed
                }
                
                if self.venue.VenueAtOpen.first == "0" {
                    self.venue.VenueAtOpen.removeFirst()
                }
                
                if self.venue.VenueAtClose.first == "0" {
                    self.venue.VenueAtClose.removeFirst()
                }
                
                self.labelOpenTime.text = "\(self.venue.VenueAtOpen) - \(venue.VenueAtClose)"
            }
      //  }
//        else {
//            self.labelOpenNowStatus.textColor = .RedColor
//            self.labelOpenNowStatus.text = Text.Label.text_Close
//        }
        
        print(Utill.getMapUrl(pinImageUrl: venue.MapPinImageUrl, latitute: venue.VenueLattitude, longtitude: venue.VenueLongitude))
        
        var strUrl = Utill.getMapUrl(pinImageUrl: venue.MapPinImageUrl, latitute: venue.VenueLattitude, longtitude: venue.VenueLongitude)
        
        if URL(string: strUrl) == nil {
            strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        self.imageViewMap.sd_setShowActivityIndicatorView(true)
        self.imageViewMap.sd_setIndicatorStyle(.white)
        self.imageViewMap.sd_setImage(with: URL(string: strUrl ?? ""),
                                      placeholderImage:#imageLiteral(resourceName: "placeholder"),
                                      options: [SDWebImageOptions.cacheMemoryOnly])
        
//        self.viewClaimABusinessAlert.isHidden = true
//        if self.venue.IsSponseredVenues.toBool() == false && self.venue.IsClaimVenue.toBool() == false
//        {
//            self.viewClaimABusinessAlert.isHidden = false
//        }
    }
    
    //MARK: - Action Methods
    @objc func didChangeRating(_newRating: NSNumber?) {
        Utill.printInTOConsole(printData:"didChangeRating: \(_newRating ?? 0)")
    }
    
    @IBAction func buttonVideoAction(_ sender: Any) {
        if let delegate = self.delegate{
            delegate.searchResultTableCellLiveCamButtonClicked(cell: self, withVenueCategory: self.venue)
        }
    }
    
    @IBAction func buttonCallAction(_ sender: Any) {
        //print("PHONE \(self.venue.VenueName)  \(self.venue.VenuePhone)")

        if self.venue.VenuePhone.count == 0 {
            let defaultNumberPhone = "10123456789"
            guard let url = URL(string: "tel://\(defaultNumberPhone)"),
                UIApplication.shared.canOpenURL(url) else {
               Utill.showAlertViewOnWindow(message:Text.Message.msg_Call)
                return
            }
            self.callWS_getVenueProfileDetail()
        } else {
            self.manageCall(self.venue.VenuePhone)
        }
    }
    
    @IBAction func buttonMoreAction(_ sender: UIButton)
    {
        self.buttonMore.isSelected = true
        self.buttonMore.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_MoreButton, color: .btnMoreBlueSelectedColor ), for: .normal)
        
        if let delegate = self.delegate{
            delegate.didSelectMoreButton(searchResultCell: self)
        }
    }
    
//    @IBAction func buttonClaimThisBusinessAction(_ sender: Any) {
//        if let delegate = self.delegate {
//            delegate.goToClaimBussinessScreenWithVenue(self.venue)
//        }
//    }
    
    private func manageCall(_ phoneNumber : String)
    {
        if let url = URL(string: "tel://\(Utill.formatNumber(phoneNumber)!)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            Utill.showAlertViewOnWindow(message:Text.Message.msg_Call)
        }
    }
    
   private func callWS_getVenueProfileDetail(){

    WEB_API.call_api_GetVenueProfileDetail(user: GlobalShared.user,
                                           fourSquareVenueId: self.venue.FourSquareVenueID,
                                           sponsoredVenuID: self.venue.SponsoredVenuID,
                                           venueLatitude: GlobalShared.geolocationFilterData.Latitude,
                                           venueLongitude: GlobalShared.geolocationFilterData.Longitude) { (response, success, message) in
        
        Utill.printInTOConsole(printData:"response \(response ?? "")")
        if success == true{
            let data = try! JSONSerialization.data(withJSONObject: response?["VenueDetail"].dictionaryObject ?? [:], options: [])
            self.venueProfileDetail = try! JSONDecoder().decode(WUVenueDetail.self, from: data)
            if self.venueProfileDetail.VenuePhone.count > 0 {
                self.manageCall(self.venueProfileDetail.VenuePhone)
            }else{
                Utill.showAlertViewOnWindow(message:Text.Message.msg_Call_NotFound)
            }
        } else {
          
            if message != "no records exist!" {
                Utill.showNoInternetView()
            }else{
                Utill.showErrorView()
            }
            //Utill.showAlertViewOnWindow(message: Text.Message.noInternet)
        }
    }
    }
    
    
}
