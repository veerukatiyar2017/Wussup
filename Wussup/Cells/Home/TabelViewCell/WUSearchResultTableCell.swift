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
//    @IBOutlet private weak var buttonCallWidthConst     : NSLayoutConstraint!
    
//    @IBOutlet weak var viewClaimABusinessAlert: UIView!
//    @IBOutlet weak var viewBlackDetail: UIView!
//    @IBOutlet weak var buttonClaimThisBusiness: UIButton!
    
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
//        if self.viewClaimABusinessAlert.isHidden == false{
//            self.buttonClaimThisBusiness.tintColor = .LoalPromosColor
//            self.buttonClaimThisBusiness.backgroundColor = .ClaimThisBusinessColor
//            self.buttonClaimThisBusiness.layer.borderColor = UIColor.LoalPromosColor.cgColor
//            self.viewClaimABusinessAlert.layer.borderColor = UIColor.LoalPromosColor.cgColor
//
//        }
    }
    
    private func setCellDetail(){

        self.viewStarRating.isHidden        = false
        self.labelPrice.isHidden            = false
        self.labelOpenTime.isHidden         = false
        self.labelOpenNowStatus.isHidden    = false
        self.buttonMore.isHidden            = false
        
        if self.venue.VenueStatusID == 1{
            self.viewContainer.backgroundColor  = UIColor.LiveCamYellowColor
        }else {
            self.viewContainer.backgroundColor  = UIColor.white
            self.viewStarRating.isHidden        = true
            self.labelPrice.isHidden            = true
            self.labelOpenTime.isHidden         = true
            self.labelOpenNowStatus.isHidden    = true
            self.buttonMore.isHidden            = true
        }
        
        
//        self.buttonCall.isHidden = false
        
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
//        self.imageViewOfSearchResult.sd_setShowActivityIndicatorView(true)
//        self.imageViewOfSearchResult.sd_setIndicatorStyle(.white)
        self.imageViewOfSearchResult.sd_imageIndicator = SDWebImageActivityIndicator.white
        let coverImage = self.venue.VenueImages.filter({$0.IsConverPhoto.toBool() == true})
        if coverImage.count > 0 {
            self.imageViewOfSearchResult.sd_setImage(with: URL(string: coverImage[0].SquareImage), placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto") , options: .refreshCached)
        }else {
            self.imageViewOfSearchResult.image = #imageLiteral(resourceName: "NullState_CoverPhoto")
        }
//        self.imageViewOfSearchResult.sd_setImage(with: URL(string: self.venue.VenueImages.count > 0 ? self.venue.VenueImages[0].SquareImage : ""), placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto"), options: [SDWebImageOptions.cacheMemoryOnly])
        self.buttonDistance.setTitle(NSString(format: "%0.2f Mi", Float(venue.VenueDistance) ?? 0) as String, for:.normal)
        self.buttonDistance.backgroundColor = UIColor.buttonDistanceColor
        self.viewStarRating.setStars(Int32(Float(self.venue.VenueRating) ?? 0) , target: self, callbackAction:  #selector(didChangeRating(_newRating:)))
        self.viewStarRating.isUserInteractionEnabled = false
        self.labelTitle.text = venue.VenueName
        
        self.labelTitleAddress.text = self.venue.VenueFullAddress
        
        self.labelRateCount.text = ""
        self.labelPrice.text = self.venue.Price
        
        self.labelOpenTime.text = ""
        self.labelOpenNowStatus.text = ""
        
        let filterID = self.searchedVenueData.selectedfilters.filter({$0.filterId == WUSearchFilterID.openNow.rawValue})
        if filterID.count > 0 || self.venue.IsVenueOpen.toBool() == true {
            if self.venue.VenueAtOpen == "" || self.venue.VenueAtClose == ""{
                self.labelOpenNowStatus.textColor = .OpenNowGreenColor
                self.labelOpenNowStatus.text = Text.Label.text_Open
            }else {
                self.labelOpenNowStatus.textColor = .OpenNowGreenColor
                self.labelOpenNowStatus.text = Text.Label.text_OpenNow
                self.labelOpenTime.text = "\(self.venue.VenueAtOpen) - \(venue.VenueAtClose)"
            }
        }
        
        print(Utill.getMapUrl(pinImageUrl: venue.MapPinImageUrl, latitute: venue.VenueLattitude, longtitude: venue.VenueLongitude))
        
        var strUrl = Utill.getMapUrl(pinImageUrl: venue.MapPinImageUrl, latitute: venue.VenueLattitude, longtitude: venue.VenueLongitude)
        
        if URL(string: strUrl) == nil {
            strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
//        self.imageViewMap.sd_setShowActivityIndicatorView(true)
//        self.imageViewMap.sd_setIndicatorStyle(.white)
        self.imageViewMap.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.imageViewMap.sd_setImage(with: URL(string: strUrl ?? ""), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: .refreshCached)
        
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
        
        if self.venue.VenuePhone.count == 0 {
            guard let url = URL(string: "tel://\(0123456789)"), UIApplication.shared.canOpenURL(url) else {
               Utill.showAlertViewOnWindow(message:Text.Message.msg_Call)
                return
            }
            self.callWS_getVenueProfileDetail()
        }
        else {
            self.manageCall(self.venue.VenuePhone)
        }
        
    }
    
    @IBAction func buttonMoreAction(_ sender: UIButton) {
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

    
    private func manageCall(_ phoneNumber : String){
        let phoneNumber =  Utill.formatNumber(phoneNumber)!
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }else {
            Utill.showAlertViewOnWindow(message:Text.Message.msg_Call)
        }
    }
    
   private func callWS_getVenueProfileDetail(){
        
        WEB_API.call_api_GetVenueProfileDetail(user: GlobalShared.user, fourSquareVenueId: self.venue.FourSquareVenueID, sponsoredVenuID: self.venue.SponsoredVenuID ) { (response, success, message) in
            
            Utill.printInTOConsole(printData:"response \(response ?? "")")
            if success == true{
                let data = try! JSONSerialization.data(withJSONObject: response?["VenueDetail"].dictionaryObject ?? [:], options: [])
                self.venueProfileDetail = try! JSONDecoder().decode(WUVenueDetail.self, from: data)
                if self.venueProfileDetail.VenuePhone.count > 0 {
                    self.manageCall(self.venueProfileDetail.VenuePhone)
                }else{
                    Utill.showAlertViewOnWindow(message:Text.Message.msg_Call_NotFound)
                }
            }else{
                     Utill.showAlertViewOnWindow(message: Text.Message.noInternet)
            }
        }
    }
    
    
}
