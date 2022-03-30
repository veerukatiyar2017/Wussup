//
//  WUClaimABusinessDetailViewController.swift
//  Wussup
//
//  Created by MAC219 on 10/29/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class WUClaimABusinessDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private var viewMain                              : UIView!
    @IBOutlet private weak var buttonNoResults                  : UIButton!
    
    @IBOutlet private weak var tableViewClaimABusinessDetail    : UITableView!
    @IBOutlet private weak var buttonBack                       : UIButton!
    @IBOutlet  weak var labelNavigationTitle                    : UILabel!
    @IBOutlet private weak var imageViewOfSearchResult          : UIImageView!
    @IBOutlet private weak var imageViewMap                     : UIImageView!
    @IBOutlet private weak var buttonDistance                   : UIButton!
    @IBOutlet private weak var labelTitle                       : UILabel!
    @IBOutlet private weak var labelTitleAddress                : UILabel!
    @IBOutlet private weak var buttonCall                       : UIButton!
    @IBOutlet private weak var buttonVideo                      : UIButton!
    
    @IBOutlet private weak var collectionBanners                : UICollectionView!
    @IBOutlet private weak var cnstCollectionViewHeight         : NSLayoutConstraint!
    
    @IBOutlet private weak var imageViewClaimAPrompt            : UIImageView!
    @IBOutlet private weak var labelCaptionSays                 : UILabel!
    @IBOutlet private weak var labelBusinessName                : UILabel!
    @IBOutlet private weak var labelNotBeenClaimed              : UILabel!
    @IBOutlet private weak var labelClickHere                   : UILabel!
    @IBOutlet private weak var labelAddClaimBusiness            : UILabel!
    @IBOutlet private weak var imageViewClaimFinger             : UIImageView!
    
    @IBOutlet private weak var labelPrice                       : UILabel!
    @IBOutlet private weak var viewStarRating                   : DXStarRatingView!
    @IBOutlet private weak var labelRateCount                   : UILabel!
    @IBOutlet private weak var labelOpenNowStatus               : UILabel!
    @IBOutlet private weak var labelOpenTime                    : UILabel!
    @IBOutlet private weak var buttonMore                       : UIButton!
    @IBOutlet private weak var noVenuePlaceholder               : UIImageView!
    @IBOutlet private weak var buttonTimeSheetWithStatus        : UIButton!
    
    @IBOutlet private weak var viewTimeSheet                    : UIView!
    @IBOutlet private weak var heightViewTimeSheet              : NSLayoutConstraint!
    @IBOutlet private weak var tableViewTimeSheet               : UITableView!
    @IBOutlet private weak var arrowImageView                   : UIImageView!
    @IBOutlet private weak var categoryNameLabel                : UILabel!

//    @IBOutlet private weak var cntImageViewClaimAPromptHeight   : NSLayoutConstraint!
//    @IBOutlet private weak var cntImageViewClaimFingerHeight    : NSLayoutConstraint!
    
    // MARK: - Variables
    private var homeVenueAllData      : HomeVenueData!
    var venuePromotions               : [WUVenueLocalPromotions] = []

    private var venueProfileDetail    : WUVenueDetail!
    var tapGesture                    = UITapGestureRecognizer()
    var venue : Any!
    private var currentVisibleIndex   = 0
    private var timerAnimation        : Timer?
    
    var fourSquareVenueId             = ""
    var sponsoredVenuID               = ""
    var longitude                     = ""
    var latitude                      = ""
    var isScreenFromThankYouOfCAB     : Bool = false
    var  geolocationFilterData        : WUGeolocationFilterData!
    //MARK: - Load Methods
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.manageFlowFromThankYouScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isScreenFromThankYouOfCAB == true {
            
        } else {
            if self.venuePromotions.count > 1 {
                self.stopTimer()
            }
        }
    }

    // MARK: - Initial Setup
    private func initialData()
    {
        self.tableViewTimeSheet.delegate = self
        self.tableViewTimeSheet.dataSource = self
        
        self.collectionBanners.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), bundle: nil),
                                        forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()))
        
        if self.venue is WUVenueLocalPromotions {
            self.labelBusinessName.attributedText = self.setTextToLabelBusinessName((self.venue as! WUVenueLocalPromotions).VenueName)
            self.fourSquareVenueId          = (self.venue as! WUVenueLocalPromotions).VenueFourSquareID
            self.sponsoredVenuID            = (self.venue as! WUVenueLocalPromotions).VenueID
            
        } else if self.venue is WUVenueDetail {
            self.labelBusinessName.attributedText = self.setTextToLabelBusinessName((self.venue as! WUVenueDetail).VenueName)
            self.fourSquareVenueId          = (self.venue as! WUVenueDetail).FourSquareVenueID
            self.sponsoredVenuID            = (self.venue as! WUVenueDetail).SponsoredVenuID
            self.latitude                   = (self.venue as! WUVenueDetail).VenueLattitude
            self.longitude                  = (self.venue as! WUVenueDetail).VenueLongitude
            
        } else if self.venue is WUVenue {
            self.labelBusinessName.attributedText = self.setTextToLabelBusinessName((self.venue as! WUVenue).VenueName)
            self.fourSquareVenueId          = (self.venue as! WUVenue).FourSquareVenueID
            self.sponsoredVenuID            = (self.venue as! WUVenue).SponsoredVenuID
            self.latitude                   = (self.venue as! WUVenue).VenueLattitude
            self.longitude                  = (self.venue as! WUVenue).VenueLongitude
            
        } else if self.venue is WUHomeBannerList {
            self.labelBusinessName.attributedText = self.setTextToLabelBusinessName((self.venue as! WUHomeBannerList).Title)
            self.fourSquareVenueId          = (self.venue as! WUHomeBannerList).VenueFourSquareID
            self.sponsoredVenuID            = (self.venue as! WUHomeBannerList).VenueID
        }
        
        self.callWS_getVenueProfileDetail()
        
        if self.isScreenFromThankYouOfCAB == false {
            
            if let venuePromotions = GlobalShared.localPromotions?.VenuePromotions {
                self.venuePromotions = venuePromotions
            }
            if self.venuePromotions.count == 0 {
                self.call_api_GetLatLongDetails()
            } else {
                //                if UIScreen.main.bounds.size.height >= CGFloat(IPHONE6_HEIGHT) {
                //                    self.manageTabelViewHeaderViewHeight(isBannerHide: false)
                //                }
                self.noVenuePlaceholder.isHidden = true
                self.collectionBanners.reloadData()
            }
        }
        
        self.buttonNoResults.setTitle(Text.Message.noDataFound, for: .normal)
        
        self.tableViewClaimABusinessDetail.reloadData()
        self.tableViewTimeSheet.reloadData()

        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelAddClaimABusinessAction(_:)))
        self.tapGesture.numberOfTapsRequired = 1
        self.labelAddClaimBusiness.isUserInteractionEnabled = true
        self.labelAddClaimBusiness.addGestureRecognizer(self.tapGesture)
        
        self.viewTimeSheet.isHidden = true
        self.viewTimeSheet.layer.shadowColor = UIColor.gray.cgColor
        self.viewTimeSheet.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.viewTimeSheet.layer.shadowOpacity = 1
        self.viewTimeSheet.layer.shadowRadius = 1.0
        self.viewTimeSheet.layer.masksToBounds = false
        
        self.tableViewTimeSheet.contentInset = UIEdgeInsets(top: 5.0, left: 0, bottom: 5.0, right: 0)
        self.tableViewTimeSheet.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUTimeSheetTableCell()), bundle: nil),
                                         forCellReuseIdentifier:  Utill.getClassNameFor(classType: WUTimeSheetTableCell()))
        
    }
    
    private func setTextToLabelBusinessName(_ name: String) -> NSAttributedString
    {
        let name = "[ " + name + " ]"
        
        let businessName = NSAttributedString(string:name,
                                              attributes:[.font: UIFont.ProximaNovaMedium(20.0.propotional) as Any])
        
        return businessName
    }
    
    // MARK: - Action Methods

    @IBAction func buttonMoreAction(_ sender: UIButton)
    {
        self.buttonMore.isSelected = true
        self.buttonMore.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_MoreButton, color: .btnMoreBlueSelectedColor ), for: .normal)
//        if let delegate = self.delegate{
//            delegate.didSelectMoreButton(searchResultCell: self)
//        }
    }
    
    @IBAction func buttonTimeSheetWithStatusAction(_ sender: Any)
    {
        if self.viewTimeSheet.isHidden == true {

            self.tableViewTimeSheet.reloadData()
            self.viewTimeSheet.isHidden = false
        } else {
            self.viewTimeSheet.isHidden = true
        }
    }
    
    @objc func didChangeRating(_newRating: NSNumber?) {
        Utill.printInTOConsole(printData:"didChangeRating: \(_newRating ?? 0)")
    }
    
    @IBAction func buttonBackAction(_ sender: Any) {
        if self.isScreenFromThankYouOfCAB == true {
            self.manageBackButtonFlow()
        }else {
            self.view.endEditing(true)
            self.buttonBack.isSelected = true
            self.buttonBack.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Back,
                                                                                      color: .GreenColor ), for: .selected)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func buttonMapAction(_ sender: UIButton)
    {
        if self.venueProfileDetail.VenueLattitude == "" || Float(self.venueProfileDetail.VenueLattitude) == 0.0 && self.venueProfileDetail.VenueLongitude == "" || Float(self.venueProfileDetail.VenueLongitude) == 0.0 {
            
            Utill.showAlertView(viewController: self, message: Text.Message.venueLocationNotFound)
        } else {
            self.performSegue(withIdentifier: Text.Segue.venueProfileListToVenueMap, sender: nil)
        }
    }
    
    @objc func labelAddClaimABusinessAction(_ sender : UITapGestureRecognizer)
    {
        if let vc = UIStoryboard.home.get(WUClaimABusinessAcceptViewController.self){
            vc.claimVenue = self.venue
            vc.typeTransition = .foursquare
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
//        if let vc = UIStoryboard.home.get(WUClaimABusinessViewController.self) {
//            vc.claimVenue = self.venue
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @IBAction func buttonVideoAction(_ sender: Any) {
        Utill.goToLivecamProfile(viewController: self, withLivecamM: self.venueProfileDetail.LiveCams.LocalLiveCams[0])
    }
    
    @IBAction func buttonCallAction(_ sender: Any) {
        
        if self.venueProfileDetail.VenuePhone.count == 0 {
            let defaultNumberPhone = "10123456789"
            guard let url = URL(string: "tel://" + defaultNumberPhone),
                UIApplication.shared.canOpenURL(url) else {
                Utill.showAlertViewOnWindow(message:Text.Message.msg_Call)
                return
            }
        } else {
            self.manageCall(self.venueProfileDetail.VenuePhone)
        }
    }
    
    @IBAction func buttonNoResultsAction(_ sender: Any) {
        self.callWS_getVenueProfileDetail()
    }
    
    private func manageBackButtonFlow(){
        for controller in self.navigationController!.viewControllers.reversed() as Array {
            if controller.isKind(of: WUHomeSearchViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            else if controller.isKind(of: WUHomeViewAllViewController.self)
            {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            else if controller.isKind(of: WUHomeViewController.self){
                self.navigationController!.popToViewController(controller, animated: true)
                break
            } else if controller.isKind(of: WUFavoriteHomeViewController.self){
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func manageCall(_ phoneNumber : String){
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
    
    private func manageTabelViewHeaderViewHeight(isBannerHide : Bool) {
        
        if isBannerHide == true {
            self.cnstCollectionViewHeight.constant = 0.0
            self.tableViewClaimABusinessDetail.tableHeaderView?.frame = CGRect(x: 0,
                                                                               y: 0,
                                                                               width: self.tableViewClaimABusinessDetail.frame.width,
                                                                               height: 210.0)
            
            self.tableViewClaimABusinessDetail.tableFooterView?.frame = CGRect(x: 0,
                                                                               y: 0,
                                                                               width: self.tableViewClaimABusinessDetail.frame.width,
                                                                               height: (UIScreen.main.bounds.size.height - 177))//287))
        } else {
            self.cnstCollectionViewHeight.constant = 100.0
            self.tableViewClaimABusinessDetail.tableHeaderView?.frame = CGRect(x: 0,
                                                                               y: 0,
                                                                               width: self.tableViewClaimABusinessDetail.frame.width,
                                                                               height: 0)//310.0)
            
            self.tableViewClaimABusinessDetail.tableFooterView?.frame = CGRect(x: 0,
                                                                               y: 0,
                                                                               width: self.tableViewClaimABusinessDetail.frame.width,
                                                                               height: 450)//(UIScreen.main.bounds.size.height - 320))//387))
        }
        
    }
    
    private func prepareVenueViewOfDetail() {
        
        let openHours = self.venueProfileDetail.VenueOpenHours
        _ = self.venueProfileDetail.VenuePhone.count == 0 ? (self.buttonCall.isHidden = true) : (self.buttonCall.isHidden = false)

        self.categoryNameLabel.text = self.venueProfileDetail.CategoryName
        self.labelPrice.text = self.venueProfileDetail.Price
        
        let userVenueRating = Int(self.venueProfileDetail.NoOfUserGiveVenueRating) ?? 0
        if userVenueRating > 0 {
            self.labelRateCount.text = "(" + String(userVenueRating) + ")"
        } else {
            self.labelRateCount.text = ""
        }
        
        //  Foursquare is using a 0 to 10 rating so we take their numbers and divide by 2 to get our 5 start value
        let rating = (Float(self.venueProfileDetail.VenueRating) ?? 0) // / 2
        self.viewStarRating.setStars(Int32(rating),
                                     target: self,
                                     callbackAction: #selector(didChangeRating(_newRating:)))
        self.viewStarRating.isUserInteractionEnabled = false
        
        self.buttonMore.isHidden = true
        self.buttonMore.isSelected = false
        self.buttonMore.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_MoreButton,
                                                                                  color: .BlueColor ), for: .normal)
        
        
        self.buttonTimeSheetWithStatus.isUserInteractionEnabled = false

        //        if self.venueProfileDetail.IsVenueOpen.toBool() == true {

        if (self.venueProfileDetail.VenueAtOpen == "" || self.venueProfileDetail.VenueAtClose == "") {
            //&& self.venueProfileDetail.VenueOpenHours.count == 0 {
            
            self.buttonTimeSheetWithStatus.isUserInteractionEnabled = false
            self.arrowImageView.isHidden = true
            //self.labelOpenNowStatus.textColor = .RedColor
            //self.labelOpenNowStatus.text = Text.Label.text_Closed
            
        } else {
            
            // if Venue Open
            if self.venueProfileDetail.IsVenueOpen.toBool() == true {
                self.labelOpenNowStatus.textColor = .OpenNowGreenColor
                self.labelOpenNowStatus.text = Text.Label.text_Open
            } else {
                self.labelOpenNowStatus.textColor = .RedColor
                self.labelOpenNowStatus.text = Text.Label.text_Closed 
            }
            
            self.buttonTimeSheetWithStatus.isUserInteractionEnabled = true
            
            if self.venueProfileDetail.VenueAtOpen.first == "0" {
                self.venueProfileDetail.VenueAtOpen.removeFirst()
            }
            
            if self.venueProfileDetail.VenueAtClose.first == "0" {
                self.venueProfileDetail.VenueAtClose.removeFirst()
            }
            
            self.labelOpenTime.text = "\(self.venueProfileDetail.VenueAtOpen) - \(self.venueProfileDetail.VenueAtClose)"
            self.arrowImageView.isHidden = false
        }
 //   }
        
        if self.venueProfileDetail.VenueOpenHours.count == 5 {
            self.heightViewTimeSheet.constant = 125
        }
        
        self.labelNavigationTitle.text = self.venueProfileDetail.VenueName
        self.labelTitle.text = self.venueProfileDetail.VenueName
        self.labelTitleAddress.text = self.venueProfileDetail.VenueFullAddress
        
        if self.venueProfileDetail.LiveCams.LocalLiveCams.count > 0 {
            self.buttonVideo.isHidden = false
        }
        
        self.imageViewOfSearchResult.sd_setShowActivityIndicatorView(true)
        self.imageViewOfSearchResult.sd_setIndicatorStyle(.white)
        self.imageViewOfSearchResult.sd_setImage(with: URL(string:self.venueProfileDetail.VenueCoverPhoto.SquareImage),
                                                 placeholderImage:#imageLiteral(resourceName: "NullState_VenuePhoto"),
                                                          options: [SDWebImageOptions.cacheMemoryOnly])
        
        //print("VenueDistance! in WUClaimABusinessDetailViewController \(self.venueProfileDetail.VenueDistance)")

        self.buttonDistance.setTitle(NSString(format: "%0.2f Mi", Float(self.venueProfileDetail.VenueDistance) ?? 0) as String, for:.normal)
        self.buttonDistance.backgroundColor = UIColor.buttonDistanceColor
        
        var strUrl = Utill.getMapUrl(pinImageUrl: self.venueProfileDetail.MapPinImageUrl, latitute: self.venueProfileDetail.VenueLattitude, longtitude: self.venueProfileDetail.VenueLongitude)
        
        if URL(string: strUrl) == nil {
            strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        self.imageViewMap.sd_setShowActivityIndicatorView(true)
        self.imageViewMap.sd_setIndicatorStyle(.white)
        self.imageViewMap.sd_setImage(with: URL(string: strUrl),
                                      placeholderImage:#imageLiteral(resourceName: "placeholder"),
                                      options: [SDWebImageOptions.cacheMemoryOnly])
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonMapAction(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.imageViewMap.isUserInteractionEnabled = true
        self.imageViewMap.addGestureRecognizer(tapGesture)
    }
    
    private func manageFlowFromThankYouScreen (){
        if self.isScreenFromThankYouOfCAB == true {
            self.viewMain.backgroundColor = UIColor.mainViewBackGroundColor
//            self.cntImageViewClaimFingerHeight.constant = 0.0
//            self.cntImageViewClaimAPromptHeight.constant = 0.0
            
            self.imageViewClaimAPrompt.isHidden     = true
            self.labelCaptionSays.isHidden          = true
            self.labelBusinessName.isHidden         = true
            self.labelNotBeenClaimed.isHidden       = true
            self.labelClickHere.isHidden            = true
            self.labelAddClaimBusiness.isHidden     = true
            self.imageViewClaimFinger.isHidden      = true
            
//            self.tableViewClaimABusinessDetail.tableFooterView?.frame = CGRect(x: 0,
//                                                                               y: 0,
//                                                                               width: self.tableViewClaimABusinessDetail.frame.width,
//                                                                               height: 0)
            self.callWS_getVenueProfileDetail()
            self.tableViewClaimABusinessDetail.reloadData()
            self.tableViewTimeSheet.reloadData()

        } else {
            
            self.viewMain.backgroundColor = UIColor.CABBGColor
            
            self.imageViewClaimAPrompt.isHidden     = false
            self.labelCaptionSays.isHidden          = false
            self.labelBusinessName.isHidden         = false
            self.labelNotBeenClaimed.isHidden       = false
            self.labelClickHere.isHidden            = false
            self.imageViewClaimFinger.isHidden      = false
            self.labelAddClaimBusiness.isHidden     = false

            self.configureLabels()
            
            if self.venuePromotions.count > 1 {
                self.startTimerForchangeImageAnimation()
            }
        }
    }
    
    private func configureLabels()
    {
        let addClaimBusiness = NSMutableAttributedString(string:"Begin Promoting\nThis Business",
                                                         attributes:[.font: UIFont.ProximaNovaBold(20.0.propotional) as Any,
                                                                     .foregroundColor: UIColor.btnForgotPwdGreenColor,
                                                                     .underlineStyle: 1])
        
        self.labelAddClaimBusiness.attributedText = addClaimBusiness
        
        
        let clickHere = NSMutableAttributedString(string:"Click here to",
                                                  attributes:[.font: UIFont.ProximaNovaMedium(17.0.propotional) as Any,
                                                              .foregroundColor: UIColor.btnForgotPwdGreenColor,
                                                              .underlineStyle: 1])
        
        self.labelClickHere.attributedText = clickHere
    }
    
    // MARK: - Webservice calls
    
    func call_api_GetLatLongDetails(){
        WEB_API.call_api_GetLatLongDetails(user:  Utill.getUserModel()!) { (response, status, message) in
            let data = try! JSONSerialization.data(withJSONObject: response?.dictionaryObject ?? [:], options: [])
            self.geolocationFilterData = try! JSONDecoder().decode(WUGeolocationFilterData.self, from: data)
           
            self.callWS_getHomeVenueList()
        }
    }

    // getHomeVenueList
    func callWS_getHomeVenueList(){ //call_api_GetLatLongDetails
        WEB_API.call_api_GetHomeVenuesList(user: Utill.getUserModel()!,
                                           geolocationFilterData: self.geolocationFilterData,
                                           withCompletionHandler:
            { (response, status, message) in
                if status == true {
                    //self.arrHomeVenueDataList.removeAll()
                    let data = try! JSONSerialization.data(withJSONObject: response?.dictionaryObject ?? [:], options: [])
                    self.homeVenueAllData = try! JSONDecoder().decode(HomeVenueData.self, from: data)
                    
                    self.venuePromotions = self.homeVenueAllData.LocalPromotions.VenuePromotions
                    
                    if self.venuePromotions.count == 0 {
                        self.noVenuePlaceholder.isHidden = false
                        
                        //  LocalPromotion noVenuePlaceholder
                        if let url = URL(string: (self.homeVenueAllData.PlaceholderLocalPromotionAds.Url)) {
                            self.noVenuePlaceholder.sd_setImage(with: url, completed: nil)
                        } else {
                            //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                        }
                    } else if self.venuePromotions.count > 1 {
                        self.noVenuePlaceholder.isHidden = true
                        self.venuePromotions = self.venuePromotions.repeated(count: sliderRepeatCount)
                        self.collectionBanners.reloadData()
                        self.startTimerForchangeImageAnimation()
                    } else {
                        self.noVenuePlaceholder.isHidden = true
                        self.collectionBanners.reloadData()
                    }
                    Utill.printInTOConsole(printData:"///\(String(describing: self.homeVenueAllData))")
                }
        })
    }
    private func callWS_getVenueProfileDetail(){
        
        self.buttonVideo.isHidden = true

        WEB_API.call_api_GetVenueProfileDetail(user: GlobalShared.user,
                                               fourSquareVenueId: self.fourSquareVenueId,
                                               sponsoredVenuID: self.sponsoredVenuID,
                                               venueLatitude:  GlobalShared.geolocationFilterData.Latitude,
                                               venueLongitude: GlobalShared.geolocationFilterData.Longitude) { (response, success, message) in
                                                
            Utill.printInTOConsole(printData:"response\(response ?? "")")

            if success == true {
                let data = try! JSONSerialization.data(withJSONObject: response?["VenueDetail"].dictionaryObject ?? [:], options: [])
                self.venueProfileDetail = try! JSONDecoder().decode(WUVenueDetail.self, from: data)
                self.prepareVenueViewOfDetail()
            } else{
                if self.isScreenFromThankYouOfCAB == true {
                    self.tableViewClaimABusinessDetail.isHidden = true
                    self.buttonNoResults.isHidden = false
                }else{
                    self.tableViewClaimABusinessDetail.isHidden = false
                    self.buttonNoResults.isHidden = true
                }
                
                
                if message != "no records exist!" {
                    Utill.showNoInternetView()
                }else{
                    Utill.showErrorView()
                }
                //Utill.showAlertViewOnWindow(message: Text.Message.noInternet)
            }
        }
    }
    
    // MARK: - Banner Animation methods
    //To change images contiouesly in header slider
    private func startTimerForchangeImageAnimation(){
        if self.timerAnimation == nil  {
            self.timerAnimation = Timer.scheduledTimer(timeInterval: 03.0,target: self, selector: #selector(self.updateImage), userInfo: nil, repeats: true)
        }
    }
    
    private func stopTimer() {
        if self.timerAnimation != nil {
            self.timerAnimation?.invalidate()
            self.timerAnimation = nil
        }
    }
    
    @objc func updateImage() {
        
        if self.venuePromotions.count > 0 {
            self.currentVisibleIndex = self.currentVisibleIndex + 1
            if self.currentVisibleIndex >= self.venuePromotions.count {
                self.currentVisibleIndex = 0
            }
            if self.currentVisibleIndex < self.venuePromotions.count{
                DispatchQueue.main.async {
                    if self.currentVisibleIndex == 0 {
                        self.collectionBanners.scrollToItem(at:IndexPath(row: self.currentVisibleIndex, section: 0), at: UICollectionViewScrollPosition.right, animated: false)
                    }
                    else{
                        self.collectionBanners.scrollToItem(at:IndexPath(row: self.currentVisibleIndex, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier ==  Text.Segue.venueProfileListToVenueMap {
            let venueMapVc = segue.destination as! WUVenueMapViewController
            venueMapVc.venueMapDetail = self.venueProfileDetail
        }
    }
    
}

//MARK: - CollectionView
extension WUClaimABusinessDetailViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.venuePromotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), for: indexPath)as! WUHomeSliderCollectionCell
        cell.venueLocalPromotion = self.venuePromotions[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.venuePromotions[indexPath.row].VenueStatusID == 1 {
            //FEXED
            //FirebaseManager.sharedInstance.ad_herobanner_GUID_ios(parameter:nil, homeBanner:self.placeholderLocalPromotions?[indexPath.row])
            if let vc : WUVenueProfileViewController = UIStoryboard.venue.get(WUVenueProfileViewController.self) {
                vc.sponsoredVenuID = self.venuePromotions[indexPath.row].VenueID
                vc.fourSquareVenueId = self.venuePromotions[indexPath.row].VenueFourSquareID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            Utill.goToClaimBussinessScreenWithVenue(viewController: self, venue:self.venuePromotions[indexPath.row] )
        }
    }
    
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        if collectionView == self.collectionViewImageAnimate{
    //             Utill.printInTOConsole(printData:"  collectionView willDisplay")
    //            if indexPath.row > 0 {
    //                self.stopTimer()
    //            }
    //        }
    //    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //Utill.printInTOConsole(printData:"  collectionView didEndDisplaying")
        if collectionView == self.collectionBanners {
            if self.venuePromotions.count > 1 {
                self.stopTimer()
                let currentPage = self.collectionBanners.contentOffset.x / self.collectionBanners.frame.size.width
                self.currentVisibleIndex = Int(currentPage)
                //Utill.printInTOConsole(printData:"current index : \(currentPage)")
                self.startTimerForchangeImageAnimation()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:self.collectionBanners.frame.size.width, height: 100.0)
    }
}

//MARK: - WUTimeSheetTableCellDelegate to close TimeSheet
extension WUClaimABusinessDetailViewController : WUTimeSheetTableCellDelegate {
    
    func timeSheetTableCell(cell: WUTimeSheetTableCell, buttonCloseTimeSheet button: UIButton) {
        self.viewTimeSheet.isHidden = true
    }
}


//MARK: - TableView
extension WUClaimABusinessDetailViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tableViewTimeSheet {
            return (self.venueProfileDetail != nil) ? self.venueProfileDetail.VenueOpenHours.count : 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewTimeSheet {
            
           let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUTimeSheetTableCell()),
                                                    for: indexPath)as! WUTimeSheetTableCell
            
            if indexPath.row == self.venueProfileDetail.VenueOpenHours.count - 1 {
                cell.buttonCloseTimeSheet.isHidden = false
            } else {
                cell.buttonCloseTimeSheet.isHidden = true
            }
            cell.delegate = self
            cell.labelWeekDayName.font = UIFont.ProximaNovaMedium(15.0)
            cell.labelWeekDayName.text = "\(self.venueProfileDetail.VenueOpenHours[indexPath.row].Days)"

            // removeZeroFromTime
            var time = self.venueProfileDetail.VenueOpenHours[indexPath.row].Time[0]
            if self.venueProfileDetail.VenueOpenHours[indexPath.row].Time.count == 2 {
                let theCloseTime = self.venueProfileDetail.VenueOpenHours[indexPath.row].Time[1]
                let openTimeArray = time.components(separatedBy: "-")
                let closeTimeArray = theCloseTime.components(separatedBy: "-")
                let open = openTimeArray[0]
                let close = closeTimeArray[1]
                time = open + "-" + close
            }
            
            if time.first == "0" {
                time.removeFirst()
            }
            time = time.replacingOccurrences(of: "- 0", with: "- ")

            cell.labelTime.text = time

            if self.venueProfileDetail.VenueOpenHours[indexPath.row].includeToday.toBool() == true {
                cell.labelWeekDayName.font = UIFont.ProximaNovaBold(15.0)
                cell.labelWeekDayName.text = (self.venueProfileDetail.VenueOpenHours[indexPath.row].Days).uppercased()
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("////indexPath -- \(indexPath.row)")
    }
}
