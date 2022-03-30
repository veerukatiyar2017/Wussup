//
//  WUVenueProfileViewController.swift
//  Wussup
//
//  Created by MAC219 on 4/24/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import Foundation
import AVKit
import SDWebImage
import MapKit
import Social
import EventKitUI
import Photos
//import FBSDKLoginKit
//import FBSDKShareKit

// MARK: - Delegate
protocol WUVenueProfileViewControllerDelegate: class {
    func venueProfileUpdateRating_Favorite(venueProfile obj : WUVenueDetail)
    func updateNewPromosValues(venueProfile Obj : WUVenueDetail)
}

extension WUVenueProfileViewControllerDelegate {
    func venueProfileUpdateRating_Favorite(venueProfile obj : WUVenueDetail){
        
    }
    func updateNewPromosValues(venueProfile Obj : WUVenueDetail){
        
    }
}
// MARK: - Class : WUVenueProfileViewController
class WUVenueProfileViewController: UIViewController {
    let viewheaderHeightForPromotion = CGFloat(835.0)
    let viewheaderHeightForNonPromotion = CGFloat(735.0)
    let venueOpenNowTag = 111
    var viewheaderFinalHeight : CGFloat = 0.0
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var viewTimeSheetHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAnimatedImageHeight: NSLayoutConstraint!
    
    // MARK: - IBOutlets
    @IBOutlet private weak var buttonGoToTop                        : UIButton!
    @IBOutlet private weak var tableViewVenueProfile                : UITableView!
    @IBOutlet weak var imageviewVenueFeaturedImage                  : UIImageView!
    @IBOutlet private weak var viewHeader                           : HeaderContainerView!
    @IBOutlet private weak var viewHeaderContainer                  : UIView!
    @IBOutlet private weak var viewVideoContainer                   : UIView!
    @IBOutlet private weak var viewHeaderTop                        : HeaderTopContainerView!
    @IBOutlet private weak var constraintTopHeaderHeight            : NSLayoutConstraint!
    @IBOutlet private weak var constraintBlackTopBarHeight          : NSLayoutConstraint!
    @IBOutlet private weak var constraintTopHeaderTop               : NSLayoutConstraint!
    
    @IBOutlet weak var constraintDescViewHeight                     : NSLayoutConstraint!
    @IBOutlet weak var constrasintTitleAddreVwHeight: NSLayoutConstraint!
    @IBOutlet private weak var viewBlackTopBar                      : HeaderTopContainerView!
    @IBOutlet  weak var collectionCategory                          : UICollectionView!
    @IBOutlet private weak var imageViewVenueCoverPhoto                  : UIImageView!
    @IBOutlet private weak var viewStarRating                       : DXStarRatingView!
    @IBOutlet private weak var labelNumberOfUsersRating             : UILabel!
    @IBOutlet private weak var buttonDistance                       : UIButton!
    @IBOutlet private weak var labelMainTitle                       : UILabel!
    @IBOutlet private weak var labelSubTitleAddress                 : UILabel!
    @IBOutlet private weak var labelPrice                           : UILabel!
    @IBOutlet private weak var labelDiscription                     : UILabel!
    @IBOutlet private weak var buttonReadMore                       : UIButton!
    @IBOutlet private weak var buttonOpenTimeSheet                  : UIButton!
    @IBOutlet private weak var viewTimeSheet                        : UIView!
    @IBOutlet private weak var tableViewTimeSheet                   : UITableView!
    @IBOutlet private weak var buttonStarFavourite                  : UIButton!
    @IBOutlet weak var viewAnimatedImage                            : UIView!
    @IBOutlet private weak var imageViewMap                         : UIImageView!
    @IBOutlet private weak var labelTime                            : UILabel!
    @IBOutlet private weak var labelOpenWith                        : UILabel!
    @IBOutlet private weak var labelFavoriteCount                   : UILabel!
    @IBOutlet private weak var textFieldSearchText                  : UITextField!
    @IBOutlet private weak var buttonSearch                         : UIButton!
    @IBOutlet private weak var buttonShare                          : UIButton!
    @IBOutlet private weak var imageViewWeather                     : UIImageView!
    @IBOutlet private weak var labelWeather                         : UILabel!
    @IBOutlet private weak var labelWeatherCity                     : UILabel!
    @IBOutlet weak var imageViewSearchTextBorder                    : UIImageView!
    @IBOutlet private weak var buttonTimeSheetWithStatus            : UIButton!
    @IBOutlet private weak var viewFooter                           : UIView!
    @IBOutlet private weak var viewDetail                           : UIView!
    @IBOutlet private weak var collectionViewImageAnimate           : UICollectionView!
    @IBOutlet private weak var imageviewOverLayVenueFeaturedImage   : UIImageView!
    @IBOutlet private weak var imageviewOverLayVenueCoverPhoto      : UIImageView!
    @IBOutlet private weak var buttonNoResults                      : UIButton!
    @IBOutlet private weak var viewWithlabelNameAndAddress          : UIView!
    
    weak var delegate : WUVenueProfileViewControllerDelegate?
    private var currentVisibleImageIndex = 0
    private var currentPlayingVideoIndex = 0
    private var timerAnimation :Timer?
    private var arrVenueProfilePropertyList : [Any]! = []
    private var arrShareOptions : [WUShareOptions] = []
    private var arrSlider : [WUVenueLocalPromotions] = []
    private var currentShareOptionIndex = 0
    
    var isFavoriteVenue = false
    var venue : Any!
    var venueProfileDetail : WUVenueDetail!
    var fourSquareVenueId = ""
    var sponsoredVenuID = ""
    var isScreenFromFavoriteTab : Bool = false
    var isScreenFromThankYouOfCAB : Bool = false
    var claimVenue : Any!
     var tapGesture                  = UITapGestureRecognizer()
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialInterfaceSetUp()
        initialDataSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.buttonSearch.isSelected = false
        self.buttonShare.isSelected = false
        self.textFieldSearchText.text = nil
        self.collectionCategory.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.arrSlider.count > 1{
            self.stopTimer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        
        // self.mainView.backgroundColor = UIColor(red: 240.0, green: 240.0, blue: 240.0, alpha: 1.0)// == mainViewBackGroundColor
        self.tableViewVenueProfile.isHidden = true
        self.buttonNoResults.setTitle(Text.Message.noDataFound, for: .normal)
        self.buttonGoToTop.isHidden = true
        self.viewHeaderContainer.dropShadow()
        self.viewBlackTopBar.dropBlcakShadow()
        self.viewBlackTopBar.isHidden = true
        self.constraintTopHeaderHeight.constant = viewHeaderTop.height
        self.constraintBlackTopBarHeight.constant = viewBlackTopBar.height
        self.viewHeader.frame = CGRect(x: 0, y: 0, width: self.tableViewVenueProfile.frame.size.width, height: self.viewHeader.height)
        self.viewVideoContainer.dropShadow()
        self.tableViewVenueProfile.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.tableViewVenueProfile.frame.width, height: self.viewheaderHeightForNonPromotion)
        self.viewTimeSheet.isHidden = true
 
        self.viewStarRating.isUserInteractionEnabled = false
        self.labelMainTitle.text = ""
        self.labelSubTitleAddress.text = ""
        self.labelDiscription.text = ""
        self.tableViewTimeSheet.contentInset = UIEdgeInsets(top: 5.0, left: 0, bottom: 5.0, right: 0)
        self.tableViewVenueProfile.contentInset = UIEdgeInsetsMake(00, 0, 0, 0);
        
        self.viewTimeSheet.layer.shadowColor = UIColor.gray.cgColor
        self.viewTimeSheet.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.viewTimeSheet.layer.shadowOpacity = 1
        self.viewTimeSheet.layer.shadowRadius = 1.0
        self.viewTimeSheet.layer.masksToBounds = false
        
        
        
        self.tableViewVenueProfile.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUExpandableImageTableCell()), bundle: nil), forCellReuseIdentifier:  Utill.getClassNameFor(classType: WUExpandableImageTableCell()))
        self.tableViewTimeSheet.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUTimeSheetTableCell()), bundle: nil), forCellReuseIdentifier:  Utill.getClassNameFor(classType: WUTimeSheetTableCell()))
        
        let headerNib = UINib.init(nibName:Utill.getClassNameFor(classType: WUExpandableSectionHeaderView()), bundle: Bundle.main)
        self.tableViewVenueProfile.register(headerNib, forHeaderFooterViewReuseIdentifier: Utill.getClassNameFor(classType: WUExpandableSectionHeaderView()))
        
        self.collectionViewImageAnimate.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()))
    }
    
    private func initialDataSetup() {
        if self.venueProfileDetail == nil {
            self.callWS_getVenueProfileDetail(isFromFavorite: false)
        }else{
            self.setUpForVenueProfileDetail()
            self.callWS_MarkNotificationAsRead()
        }
//        self.call_api_GetLocationKeyOfCity()
    }
    
    private func createShareOptionArray(){
        
        if self.venueProfileDetail.VenuePhone != ""{
            let shareOption1 = WUShareOptions(title: Text.Label.text_Call, normalImage:  #imageLiteral(resourceName: "CallIconNormal"), selectedImage:  #imageLiteral(resourceName: "CallIconActive"),shareOptionType:.call)
            self.arrShareOptions.append(shareOption1)
        }
        
        let shareOption2 = WUShareOptions(title: Text.Label.text_Share, normalImage:  #imageLiteral(resourceName: "ShareIconNormal"), selectedImage:  #imageLiteral(resourceName: "ShareIconActive"),shareOptionType:.share)
        self.arrShareOptions.append(shareOption2)
        
        let shareOption3 = WUShareOptions(title: Text.Label.text_Favorite, normalImage:  #imageLiteral(resourceName: "FavoriteIconNormal"), selectedImage:  #imageLiteral(resourceName: "FavoriteIconActive"),shareOptionType:.favorite)
        if self.venueProfileDetail.IsUserFavoriteVenue != ""{
            shareOption3.isSelected = self.venueProfileDetail.IsUserFavoriteVenue.toBool()!
            self.labelFavoriteCount.text = "(\(self.venueProfileDetail.VenueFavoriteCount))"        }
        self.arrShareOptions.append(shareOption3)
        
        if self.venueProfileDetail.LiveCams.LocalLiveCams.count > 0 {
            let shareOption4 = WUShareOptions(title: Text.Label.text_LiveCam, normalImage: #imageLiteral(resourceName: "LiveCamIconNormal"), selectedImage:  #imageLiteral(resourceName: "LiveCamIconActive"),shareOptionType:.liveCam)
            self.arrShareOptions.append(shareOption4)
        }
        
        if self.venueProfileDetail.VenueURL != "" {
            let shareOption5 = WUShareOptions(title: Text.Label.text_Website, normalImage:  #imageLiteral(resourceName: "WebSiteIconNormal"), selectedImage:  #imageLiteral(resourceName: "WebSiteIconActive"),shareOptionType:.website)
            self.arrShareOptions.append(shareOption5)
        }
        
        let shareOption6 = WUShareOptions(title: Text.Label.text_AddToCalender, normalImage:  #imageLiteral(resourceName: "CalendarIconNormal"), selectedImage:  #imageLiteral(resourceName: "CalendarIconActive"),shareOptionType:.addToCalendar)
        self.arrShareOptions.append(shareOption6)
        
        //        let shareOption7 = WUShareOptions(title: Text.Label.text_Follow, normalImage: #imageLiteral(resourceName: "FollowIconNormal"), selectedImage:  #imageLiteral(resourceName: "FollowIconActive"),shareOptionType:.follow)
        //        self.arrShareOptions.append(shareOption7)
        
        let shareOption8 = WUShareOptions(title: Text.Label.text_Rate, normalImage:  #imageLiteral(resourceName: "RateIconNormal"), selectedImage:  #imageLiteral(resourceName: "RateIconActive") ,shareOptionType:.rate)
        self.arrShareOptions.append(shareOption8)
        
        if self.venueProfileDetail.Facebook != "" {
            let shareOption9 = WUShareOptions(title: Text.Label.text_Facebook, normalImage:  #imageLiteral(resourceName: "FaceBookIconNormal"), selectedImage:  #imageLiteral(resourceName: "FaceBookIconActive"),shareOptionType:.facebook)
            self.arrShareOptions.append(shareOption9)
        }
        
        if self.venueProfileDetail.Twitter != "" {
            let shareOption10 = WUShareOptions(title: Text.Label.text_Twitter, normalImage:  #imageLiteral(resourceName: "TwitterIconNormal"), selectedImage:  #imageLiteral(resourceName: "TwitterIconActive"),shareOptionType:.twitter)
            self.arrShareOptions.append(shareOption10)
        }
        
        if self.venueProfileDetail.Instragram != "" {
            let shareOption11 = WUShareOptions(title: Text.Label.text_Insta, normalImage:  #imageLiteral(resourceName: "InstagramIconNormal"), selectedImage:  #imageLiteral(resourceName: "InstagramIconActive"),shareOptionType:.instagram)
            self.arrShareOptions.append(shareOption11)
        }
        
        self.collectionCategory.reloadData()
        self.setupForFavoriteForVenue()
        self.setupForRatingForVenue()
    }
    
    
    private func prepareViewForVenueProfileDetail() {
        
//        self.imageviewVenueFeaturedImage.sd_setShowActivityIndicatorView(true)
//        self.imageviewVenueFeaturedImage.sd_setIndicatorStyle(.white)
        self.imageviewVenueFeaturedImage.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.imageviewVenueFeaturedImage.sd_setImage(with: URL(string: self.venueProfileDetail.VenueFeaturedImage),
                                                     placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto"),
                                                     options: .refreshCached)
        
        self.imageviewOverLayVenueFeaturedImage.sd_setImage(with: URL(string: self.venueProfileDetail.OverlayImageURL),
                                                            placeholderImage:UIImage(named: ""),
                                                            options: .refreshCached)
        self.imageViewVenueCoverPhoto.sd_imageIndicator = SDWebImageActivityIndicator.white
//        self.imageViewVenueCoverPhoto.sd_setShowActivityIndicatorView(true)
//        self.imageViewVenueCoverPhoto.sd_setIndicatorStyle(.white)
        
        self.imageViewVenueCoverPhoto.sd_setImage(with: URL(string:self.venueProfileDetail.VenueCoverPhoto.SquareImage),
                                                  placeholderImage:#imageLiteral(resourceName: "NullState_VenuePhoto"),
                                                  options: .refreshCached)
        
        //        if self.venueProfileDetail.VenuePhotos.VenueImages.count > 0 {
        //            for venueimage in self.venueProfileDetail.VenuePhotos.VenueImages{
        //                if self.venueProfileDetail.VenueCoverPhoto.SquareImage != venueimage.SquareImage{
        //                    self.imageViewVenuePhoto.sd_setImage(with: URL(string: venueimage.SquareImage), placeholderImage:#imageLiteral(resourceName: "NullState_VenuePhoto") , options: [SDWebImageOptions.cacheMemoryOnly])
        //                    break
        //                }else {
        //                    self.imageViewVenuePhoto.image = #imageLiteral(resourceName: "NullState_VenuePhoto")
        //                }
        //            }
        //        }else {
        //            self.imageViewVenuePhoto.image = #imageLiteral(resourceName: "NullState_VenuePhoto")
        //        }
        
        
        self.buttonDistance.setTitle(NSString(format: "%0.2f Mi", Float(self.venueProfileDetail.VenueDistance) ?? 0) as String, for:.normal)
        self.buttonDistance.backgroundColor = UIColor.buttonDistanceColor
        
        var strUrl = Utill.getMapUrl(pinImageUrl: self.venueProfileDetail.MapPinImageUrl, latitute: self.venueProfileDetail.VenueLattitude, longtitude: self.venueProfileDetail.VenueLongitude)
        
        if URL(string: strUrl) == nil {
            strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        
        
//        self.imageViewMap.sd_setShowActivityIndicatorView(true)
//        self.imageViewMap.sd_setIndicatorStyle(.white)
        self.imageViewMap.sd_setImage(with: URL(string: strUrl),
                                      placeholderImage:#imageLiteral(resourceName: "placeholder") ,
                                      options: .refreshCached)
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonMapAction(_:)))
        self.tapGesture.numberOfTapsRequired = 1
        self.imageViewMap.isUserInteractionEnabled = true
        self.imageViewMap.addGestureRecognizer(self.tapGesture)
        
       
        self.viewWithlabelNameAndAddress.backgroundColor  = UIColor.LiveCamYellowColor
        self.labelMainTitle.text = self.venueProfileDetail.VenueName
        
        self.labelSubTitleAddress.text = self.venueProfileDetail.VenueFullAddress

        self.labelPrice.text = self.venueProfileDetail.Price
        self.labelDiscription.text = self.venueProfileDetail.VenueDescription
        self.labelFavoriteCount.text = "(\(self.venueProfileDetail.VenueFavoriteCount))"
        
        self.labelOpenWith.text = ""
        self.labelTime.text = ""
        self.buttonTimeSheetWithStatus.isUserInteractionEnabled = false
        
//        if self.venueProfileDetail.IsVenueOpen.toBool() == true {
            if (self.venueProfileDetail.VenueAtOpen == "" || self.venueProfileDetail.VenueAtClose == "") && self.venueProfileDetail.VenueOpenHours.count > 0{
                self.buttonTimeSheetWithStatus.isUserInteractionEnabled = true
                self.labelOpenWith.textColor = .RedColor
                self.labelOpenWith.text = Text.Label.text_Closed
            }else if (self.venueProfileDetail.VenueAtOpen != "" && self.venueProfileDetail.VenueAtClose != ""){
                self.buttonTimeSheetWithStatus.isUserInteractionEnabled = true
                self.labelOpenWith.textColor = .OpenNowGreenColor
                self.labelOpenWith.text = Text.Label.text_OpenNow
                self.labelTime.text = "\(self.venueProfileDetail.VenueAtOpen) - \(self.venueProfileDetail.VenueAtClose)"
            }
//        }
//        else {
//            self.labelOpenWith.textColor = .RedColor
//            self.labelOpenWith.text = Text.Label.text_Closed
//            if self.venueProfileDetail.VenueOpenHours.count == 0
//            {
//                self.buttonTimeSheetWithStatus.isUserInteractionEnabled = false
//            }
//        }
        
        
        self.preparePromotionView()
        //        FirebaseManager.sharedInstance.VenueProfileShow(parameter: nil, venueDetailM: self.venueProfileDetail)
    }
    
    private func preparePromotionView(){
        if self.venueProfileDetail.Promotions.VenuePromotions.count > 0{
            self.showPromotionView(isHidden: false)
            
            if self.venueProfileDetail.Promotions.VenuePromotions.count  > 1 {
                self.arrSlider = self.venueProfileDetail.Promotions.VenuePromotions.repeated(count : sliderRepeatCount)
                self.collectionViewImageAnimate.reloadData()
                self.startTimerForchangeImageAnimation()
            }else {
                self.arrSlider = self.venueProfileDetail.Promotions.VenuePromotions
                self.collectionViewImageAnimate.reloadData()
            }
        }else{
            self.showPromotionView(isHidden: true)
        }
        self.setVenueProfileDetail()
    }
    
    private func prepareArrayVenueProfileProperties(){
        if self.venueProfileDetail.VenuePhotos.VenueImages.count > 0 {
            self.arrVenueProfilePropertyList.append(self.venueProfileDetail.VenuePhotos)
        }
        if self.venueProfileDetail.Promotions.VenuePromotions.count > 0 {
            self.arrVenueProfilePropertyList.append(self.venueProfileDetail.Promotions)
            self.collectionViewImageAnimate.reloadData()
        }
        if self.venueProfileDetail.Specials.VenueSpecials.count > 0 {
            self.arrVenueProfilePropertyList.append(self.venueProfileDetail.Specials)
        }
        if self.venueProfileDetail.LiveCams.LocalLiveCams.count > 0 {
            self.arrVenueProfilePropertyList.append(self.venueProfileDetail.LiveCams)
        }
        if self.venueProfileDetail.VenueHappyHours.HappyHours.count > 0 {
            self.arrVenueProfilePropertyList.append(self.venueProfileDetail.VenueHappyHours)
        }
        if self.venueProfileDetail.Menus.VenueMenus.count > 0  {
            self.arrVenueProfilePropertyList.append(self.venueProfileDetail.Menus)
        }
        if self.venueProfileDetail.LiveMusic.VenueLiveMusics.count > 0  {
            self.arrVenueProfilePropertyList.append(self.venueProfileDetail.LiveMusic)
        }
        if self.venueProfileDetail.SpecialEvents.VenueSpecialEvents.count > 0  {
            self.arrVenueProfilePropertyList.append(self.venueProfileDetail.SpecialEvents)
        }
        self.tableViewVenueProfile.reloadData()
        self.tableViewTimeSheet.reloadData()
        
        self.buttonOpenTimeSheet.isHidden = false
        if self.venueProfileDetail.VenueOpenHours.count  == 0 {
            self.buttonOpenTimeSheet.isHidden = true
        }
    }
    
    // MARK: - Webservice calls
    
    private func call_api_GetGeoPositionSearch() {
        
        WEB_API.call_api_GetLocationKeyOfCity()
            { (response, status, message) in
                if response != nil {
                    let arr = response?.array
                    if arr != nil , (arr?.count)! > 0 {
                        if let locationKey =  arr![0]["Key"].string {
                            
                            WEB_API.call_api_GetCurrnetConditionWeather (strLocationKey: locationKey,
                                                                         withCompletionHandler:
                                { (responseWeather,statusWeather,messageWeather) in
                                    
                                    Utill.printInTOConsole(printData:"response \(responseWeather ?? "")")
                                    let arrWeather = responseWeather?.array
                                    if arrWeather != nil , (arrWeather?.count)! > 0 {
                                        if let dicWeather = arrWeather![0].dictionary {
                                            let weatherIconNo =  dicWeather["WeatherIcon"]?.int64
                                            let weatherIcon = "https://developer.accuweather.com/sites/default/files/\(String(format: "%02d", weatherIconNo!))-s.png"
                                            self.imageViewWeather.sd_setImage(with: URL(string: weatherIcon), completed: nil)
                                            self.labelWeather.attributedText = "\((dicWeather["Temperature"]!["Imperial"]["Value"].int64)!) {o}F".customText()
                                            let arrGeoPosition = response?.array
                                            if arrGeoPosition != nil , (arrGeoPosition?.count)! > 0 {
                                                if let dicGeoPosition = arrGeoPosition![0].dictionary {
                                                    self.labelWeatherCity.text = "\(dicGeoPosition["LocalizedName"]!.stringValue)".uppercased()
                                                }
                                            }
                                        }
                                    }
                            })
                        }
                    }
                }
        }
    }
    
    //    private func callWS_favoriteVenue(isFavorite : Bool, withCompletion completion: @escaping (Bool)-> Void){
    //        WEB_API.call_api_FavouriteVenue(user: GlobalShared.user, venueDetail: self.venueProfileDetail, isFavorite: isFavorite) { (response, success, message) in
    //            if success == true{
    //                if let count = response!["VenueFavoriteCount"].string {
    //                    self.venueProfileDetail.VenueFavoriteCount = count
    //                }
    //            }
    //            completion(success)
    //        }
    //    }
    
    private func callWS_MarkNotificationAsRead(){
        if self.venueProfileDetail != nil {
            WEB_API.call_api_MarkNotificationAsRead(user: Utill.getUserModel()!, venueID: self.venueProfileDetail.SponsoredVenuID) { (response, success, message) in
                if success == true {
                    print("Sucess callWS_MarkNotificationAsRead")
                    if GlobalShared.notifciationCount > 0 {
                        GlobalShared.notifciationCount = response!["TotalUnreadCount"].intValue
                        //                        UIApplication.shared.applicationIconBadgeNumber = GlobalShared.notifciationCount
                        if GlobalShared.notifciationCount == 0 {
                            GlobalShared.appTabbarController?.buttonNotificationCount.isHidden = true
                            GlobalShared.appTabbarController?.buttonNotificationCount.setTitle("\(GlobalShared.notifciationCount)", for: .normal)
                        }else{
                            GlobalShared.appTabbarController?.buttonNotificationCount.isHidden = false
                            GlobalShared.appTabbarController?.buttonNotificationCount.setTitle("\(GlobalShared.notifciationCount)", for: .normal)
                        }
                    }
                    
                }else {
                    print(" Not Sucess callWS_MarkNotificationAsRead")
                }
            }
        }
    }
    
    
    
    func callWS_getVenueProfileDetail(isFromFavorite : Bool){
        
        //        var fourSquareVenueId = ""
        //        var sponsoredVenuID = ""
        
        if self.fourSquareVenueId == "" || self.sponsoredVenuID == ""{
            if venue is WUVenue {
                fourSquareVenueId = (venue as! WUVenue).FourSquareVenueID
                sponsoredVenuID = (venue as! WUVenue).SponsoredVenuID
            }else if venue is WUVenueLocalPromotions{
                fourSquareVenueId = (venue as! WUVenueLocalPromotions).VenueFourSquareID
                sponsoredVenuID = (venue as! WUVenueLocalPromotions).VenueID
            }else if venue is WUVenueLiveCams {
                fourSquareVenueId = (venue as! WUVenueLiveCams).VenueFourSquareID
                sponsoredVenuID = (venue as! WUVenueLiveCams).VenueID
            }else{
                if self.venueProfileDetail != nil {
                    fourSquareVenueId = self.venueProfileDetail.FourSquareVenueID
                    sponsoredVenuID = self.venueProfileDetail.SponsoredVenuID
                }
            }
        }
        
        self.viewTimeSheet.isHidden = true
        WEB_API.call_api_GetVenueProfileDetail(user: GlobalShared.user, fourSquareVenueId: fourSquareVenueId, sponsoredVenuID: sponsoredVenuID ) { (response, success, message) in
            
            Utill.printInTOConsole(printData:"response \(response ?? "")")
            if success == true{
                //self.mainView.backgroundColor = UIColor(red: 151.0, green: 151.0, blue: 151.0, alpha: 1.0)
                //                self.mainView.backgroundColor = .black
                let data = try! JSONSerialization.data(withJSONObject: response?["VenueDetail"].dictionaryObject ?? [:], options: [])
                
                //save Livecam Banner
                let livecamBannerData = try! JSONSerialization.data(withJSONObject: response?["LiveCamBanners"].arrayObject ?? [], options: [])
                let livecamBannerList = try! JSONDecoder().decode([WUHomeBannerList].self, from: livecamBannerData)
                Utill.saveHomeBannerModel(livecamBannerList)
                
                if isFromFavorite == true{
                    let venueFavorite = try! JSONDecoder().decode(WUVenueDetail.self, from: data)
                    
                    if venueFavorite.IsUserFavoriteVenue.isEmpty != false {
                        self.venueProfileDetail.IsUserFavoriteVenue = venueFavorite.IsUserFavoriteVenue
                    }
                    self.venueProfileDetail.VenueFavoriteCount = venueFavorite.VenueFavoriteCount
                    self.arrShareOptions.removeAll()
                    self.createShareOptionArray()
                    
                }
                else{
                    self.venueProfileDetail = try! JSONDecoder().decode(WUVenueDetail.self, from: data)
                    self.setUpForVenueProfileDetail()
                }
                //                print(self.venueProfileDetail ?? "")
                self.call_api_GetGeoPositionSearch()
            }else{
                self.manageViewBlackTopbar(isShow: true)
                //self.mainView.backgroundColor = UIColor(red: 240.0, green: 240.0, blue: 240.0, alpha: 1.0)
                self.buttonNoResults.isHidden = false
                self.tableViewVenueProfile.isHidden = true
                self.buttonGoToTop.isHidden = true
            }
        }
    }
    
    private func setUpForVenueProfileDetail(){
        self.tableViewVenueProfile.isHidden = false
        self.buttonNoResults.isHidden = true
        self.buttonGoToTop.isHidden = false
        self.arrVenueProfilePropertyList.removeAll()
        self.prepareViewForVenueProfileDetail()
        self.prepareArrayVenueProfileProperties()
        self.createShareOptionArray()
    }
    
    private func setupForFavoriteForVenue(){
        self.isFavoriteVenue = self.venueProfileDetail.IsUserFavoriteVenue.toBool() ?? false
        if isFavoriteVenue == true {
            self.buttonStarFavourite.isSelected = true
            self.hightLightFavouriteIcon()
        }else{
            self.buttonStarFavourite.isSelected = false
        }
    }
    
    private func setupForRatingForVenue(){
        self.viewStarRating.setStars(Int32(Float(self.venueProfileDetail.VenueRating) ?? 0) , target: self, callbackAction:  #selector(didChangeRating(_:)))
        self.labelNumberOfUsersRating.text = "(\(String(describing: Int(Float(self.venueProfileDetail.NoOfUserGiveVenueRating) ?? 0))))"
        if Int(self.venueProfileDetail.UserVenueRating) ?? 0 > 0{
            self.hightLightRateIcon()
        }
    }
    
    
    private func callWS_favoriteVenue(isFavorite : Bool, withCompletion completion: @escaping (Bool)-> Void){
        WEB_API.call_api_FavouriteVenue(user: GlobalShared.user, venueDetail: self.venueProfileDetail, isFavorite: isFavorite) { (response, success, message) in
            if success == true{
                if let count = response!["VenueFavoriteCount"].string {
                    self.venueProfileDetail.VenueFavoriteCount = count
                }
            }
            completion(success)
        }
    }
    
    // MARK: - Rating Method
    @objc func didChangeRating(_ newRating: NSNumber?) {
        if let aRating = newRating {
            Utill.printInTOConsole(printData:"didChangeRating: \(aRating)")
        }
    }
    
    // MARK: - Resize header methods
    
    private func showPromotionView(isHidden : Bool){
        if isHidden == true{
            self.viewheaderFinalHeight = self.viewheaderHeightForNonPromotion
            self.viewAnimatedImageHeight.constant = 0
            self.viewAnimatedImage.isHidden = true
        }else{
            self.viewheaderFinalHeight = self.viewheaderHeightForPromotion
            self.viewAnimatedImageHeight.constant = 100
            self.viewAnimatedImage.isHidden = false
        }
    }
    
    private func setVenueProfileDetail()
    {
        if self.venueProfileDetail.VenueName != ""{
            let titleTextHeight = Utill.findHeightForText(text: venueProfileDetail.VenueName, havingWidth: self.labelMainTitle.frame.size.width, andFont: self.labelMainTitle.font)
            self.constrasintTitleAddreVwHeight.constant = 12 + titleTextHeight
            self.viewheaderFinalHeight = self.viewheaderFinalHeight + titleTextHeight
        }
        if self.venueProfileDetail.VenueFullAddress != ""{
            let adressTextHeight = Utill.findHeightForText(text: self.labelSubTitleAddress.text!, havingWidth: self.labelSubTitleAddress.frame.size.width, andFont: self.labelSubTitleAddress.font)
            self.constrasintTitleAddreVwHeight.constant = self.constrasintTitleAddreVwHeight.constant + adressTextHeight
            self.viewheaderFinalHeight = self.viewheaderFinalHeight + adressTextHeight
        }
        
        let textsize = Utill.findHeightForText(text:  self.labelDiscription.text!, havingWidth:  self.labelDiscription.frame.size.width, andFont:self.labelDiscription.font)
        let height = Utill.findHeightForText(text:  "Aaa  \n Azz ", havingWidth:  self.labelDiscription.frame.size.width, andFont:self.labelDiscription.font)
        
        //|| textsize <= height
        if self.venueProfileDetail.VenueDescription == ""  {
            self.buttonReadMore.isHidden = true
        }else if textsize <= height
        {
            self.constraintDescViewHeight.constant = textsize + 35 + 5
            self.viewheaderFinalHeight = self.viewheaderFinalHeight + textsize
            self.buttonReadMore.isHidden = true
        }
        else{
            self.constraintDescViewHeight.constant = height + 35 + 5
            self.viewheaderFinalHeight = self.viewheaderFinalHeight + height
        }
        
        self.resetHeaderViewForRevisedHeight()
    }
    
    private func resetHeaderViewForRevisedHeight(){
        self.viewHeader.frame = CGRect(x: 0, y: 0, width: self.tableViewVenueProfile.frame.size.width, height: self.viewheaderFinalHeight)
        self.tableViewVenueProfile.reloadData()
    }
    
    // MARK: - Image change animation methods
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
        if self.arrSlider.count > 0{
            //            self.showPromotionView(isHidden: false)
            
            self.currentVisibleImageIndex = self.currentVisibleImageIndex + 1
            if self.currentVisibleImageIndex >= self.arrSlider.count {
                self.currentVisibleImageIndex = 0
            }
            
            if self.currentVisibleImageIndex < self.arrSlider.count{
                DispatchQueue.main.async {
                    if self.currentVisibleImageIndex == 0{
                        self.collectionViewImageAnimate.scrollToItem(at:IndexPath(row: self.currentVisibleImageIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
                    }else{
                        self.collectionViewImageAnimate.scrollToItem(at:IndexPath(row: self.currentVisibleImageIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
                    }
                }
            }           
        }
        //        else{
        //            self.stopTimer()
        ////            self.showPromotionView(isHidden: true)
        //        }
    }
    
    // MARK: - Action Methods
    @IBAction func buttonNoResultsAction(_ sender: Any) {
        self.initialDataSetup()
    }
    @IBAction func buttonBackArrowAction(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.venueProfileUpdateRating_Favorite(venueProfile: self.venueProfileDetail)
        }
        
        if isScreenFromFavoriteTab == true {
            if let delegate = self.delegate {
                delegate.updateNewPromosValues(venueProfile: self.venueProfileDetail)
            }
        }
        
        if self.isScreenFromThankYouOfCAB == true{
            self.manageBackButtonFlow()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonBackArrowBlackAction(_ sender: Any) {
        
        if let delegate = self.delegate , self.venueProfileDetail != nil {
            delegate.venueProfileUpdateRating_Favorite(venueProfile: self.venueProfileDetail)
        }
        
        if isScreenFromFavoriteTab == true {
            if let delegate = self.delegate {
                delegate.updateNewPromosValues(venueProfile: self.venueProfileDetail)
            }
        }
        
        if self.isScreenFromThankYouOfCAB == true{
            self.manageBackButtonFlow()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func manageBackButtonFlow(){
        for controller in self.navigationController!.viewControllers.reversed() as Array {
            if controller.isKind(of: WUHomeSearchViewController.self) {
//                if self.claimVenue != nil
//                {
//                    let vc = controller as! WUHomeSearchViewController
//                    vc.updateClaimBusinessDataWithVenue(self.claimVenue!)
//                }
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            else if controller.isKind(of: WUHomeViewAllViewController.self)
            {
//                let vc = controller as! WUHomeViewAllViewController
//                vc.updateClaimBusineesValueWithVenueName(self.venueProfileDetail.VenueName)
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            else if controller.isKind(of: WUHomeViewController.self){
//                let vc = controller as! WUHomeViewController
//                vc.callWS_getHomeVenueList()
                self.navigationController!.popToViewController(controller, animated: true)
                break
            } else if controller.isKind(of: WUFavoriteHomeViewController.self){
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func buttonWeatherAction(_ sender: UIButton) {
    }
    
    @IBAction func buttonSearchBlackAction(_ sender: UIButton) {
        self.buttonSearch.isSelected = true
        if let vc = UIStoryboard.home.get(WUHomeSearchViewController.self){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func buttonSearchAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let vc = UIStoryboard.home.get(WUHomeSearchViewController.self){
            vc.isTextFromHomeSearch = self.textFieldSearchText.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func buttonShareAction(_ sender: UIButton) {
        self.buttonShare.isSelected = true
        self.performSegue(withIdentifier: Text.Segue.venueProfileListToVenueShare, sender: nil)
    }
    
    @IBAction func buttonTimeSheetWithStatusAction(_ sender: Any) {
        if self.viewTimeSheet.isHidden == true{
            if let viewOpenTime = self.viewDetail.viewWithTag(venueOpenNowTag)//timesheet will not be visible if opened
            {
                let viewOpenTimeYOffset = ((self.viewDetail.frame.origin.y + viewOpenTime.frame.size.height - 25) - self.view.frame.size.height + self.viewTimeSheet.frame.size.height )
                if self.tableViewVenueProfile.contentOffset.y < viewOpenTimeYOffset{
                    self.tableViewVenueProfile.contentOffset = CGPoint(x: self.tableViewVenueProfile.contentOffset.x, y:viewOpenTimeYOffset)
                }
            }
            self.viewTimeSheetHeight.constant = self.tableViewTimeSheet.contentSize.height + 10.0
            self.viewTimeSheet.isHidden = false
        }else {
            self.viewTimeSheet.isHidden = true
        }
    }
    
    @IBAction func buttonReadMoreAction(_ sender: UIButton) {
        if sender.isSelected == false{
            sender.isSelected = true
            let textsize = Utill.findHeightForText(text:  self.labelDiscription.text!, havingWidth:  self.labelDiscription.frame.size.width, andFont:self.labelDiscription.font)
            
            self.viewHeader.frame = CGRect(x: 0, y: 0, width: self.tableViewVenueProfile.frame.size.width, height: self.viewheaderFinalHeight + textsize - 35 )
            self.constraintDescViewHeight.constant = 40 + textsize
            
        }else {
            sender.isSelected = false
            let height = Utill.findHeightForText(text:  "Aaa  \n Azz ", havingWidth:  self.labelDiscription.frame.size.width, andFont:self.labelDiscription.font)
            
            self.viewHeader.frame = CGRect(x: 0, y: 0, width: self.tableViewVenueProfile.frame.size.width, height: self.viewheaderFinalHeight)
            self.constraintDescViewHeight.constant = 40 + height
        }
        self.tableViewVenueProfile.reloadData()
    }
    
    @IBAction func buttonStarFavouriteAction(_ sender: UIButton) {
        if sender.isSelected == true{
            sender.isSelected = false
        }else {
            sender.isSelected = true
        }
    }
    
    @IBAction func buttonMapAction(_ sender: UIButton) {
        if self.venueProfileDetail.VenueLattitude == "" || Float(self.venueProfileDetail.VenueLattitude) == 0.0 && self.venueProfileDetail.VenueLongitude == "" || Float(self.venueProfileDetail.VenueLongitude) == 0.0{
            Utill.showAlertView(viewController: self, message: Text.Message.venueLocationNotFound)
        }else{
            self.performSegue(withIdentifier: Text.Segue.venueProfileListToVenueMap, sender: nil)
        }
    }
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.tableViewVenueProfile.setContentOffset(CGPoint.zero, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  Text.Segue.venueProfileListToVenueMap {
            let venueMapVc = segue.destination as! WUVenueMapViewController
            venueMapVc.venueMapDetail = self.venueProfileDetail
        }
        if segue.identifier == Text.Segue.venueProfileListToVenueShare{
            let venueShareVc = segue.destination as! WUVenueShareViewController
            venueShareVc.venueShareDetail = self.venueProfileDetail
        }
        
        if segue.identifier == Text.Segue.venueProfileListToVenuePhotos{
            let viewAllVC = segue.destination as! WUVenuePhotosViewController
            viewAllVC.venueOrEvent = self.venueProfileDetail
            viewAllVC.photos = self.venueProfileDetail.VenuePhotos
        }
        
        if segue.identifier ==  Text.Segue.venuePhotosToVenueIndividualPhoto {
            let individualPhotosVc = segue.destination as! WUVenueIndividualPhotoViewController
            if let cureentVisibleIndexPath = sender as? IndexPath{
                individualPhotosVc.photosindividual = self.venueProfileDetail.VenuePhotos
                individualPhotosVc.venueOrEvent = self.venueProfileDetail
                individualPhotosVc.currentVisibleIndex = cureentVisibleIndexPath.row
            }
        }
    }
}

//MARK: - TableView
extension WUVenueProfileViewController : UITableViewDelegate ,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableViewVenueProfile {
            return self.arrVenueProfilePropertyList.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tableViewVenueProfile {
            return 65.0
        }else{
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tableViewVenueProfile{
            //            let headerView = WUExpandableSectionHeaderView.instanceFromNib()
            //            headerView.frame = CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 65.0))
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Utill.getClassNameFor(classType: WUExpandableSectionHeaderView())) as! WUExpandableSectionHeaderView
            headerView.tag = section
            headerView.delegate = self
            headerView.viewExpandableSectionHeader.backgroundColor = .white
            let sectionObject = self.arrVenueProfilePropertyList[section]
            headerView.profileCategory = sectionObject
            headerView.buttonViewAllPhotos.isHidden = true
            headerView.buttonArrowToExpandCell.isHidden = false
            if self.isSectionExpanded(forSectionObj: sectionObject){
                headerView.viewExpandableSectionHeader.backgroundColor = UIColor.WhiteShadeBGColor
                headerView.buttonArrowToExpandCell.isHidden = true
                
                if sectionObject is WUVenueProfilePhotos{
                    headerView.buttonViewAllPhotos.isHidden = false
                }
                if sectionObject is WULiveCams{
                    headerView.viewExpandableSectionHeader.backgroundColor = UIColor.LiveCamYellowColor
                }
            }
            return headerView
        }else{
            return nil
        }
    }
    
    private func isSectionExpanded(forSectionObj sectionObject : Any) -> Bool{
        if sectionObject is WUVenueProfilePhotos {
            if (sectionObject as! WUVenueProfilePhotos).isExpanded == true{
                return true
            }else{
                return false
            }
        }else  if sectionObject is WULocalPromotions  {
            if (sectionObject as! WULocalPromotions).isExpanded == true{
                return true
            }else{
                return false
            }
        }else  if sectionObject is WUSpecials {
            if (sectionObject as! WUSpecials).isExpanded == true{
                return true
            }else{
                return false
            }
        }else  if sectionObject is WULiveCams {
            if (sectionObject as! WULiveCams).isExpanded == true{
                return true
            }else{
                return false
            }
        }else  if sectionObject is WUVenueHappyHours {
            if (sectionObject as! WUVenueHappyHours).isExpanded == true{
                return true
            }else{
                return false
            }
        }else  if sectionObject is WUMenus {
            if (sectionObject as! WUMenus).isExpanded == true{
                return true
            }else{
                return false
            }
        }else  if sectionObject is WULiveMusic {
            if (sectionObject as! WULiveMusic).isExpanded == true{
                return true
            }else{
                return false
            }
        }else  if sectionObject is WUSpecialEvents {
            if (sectionObject as! WUSpecialEvents).isExpanded == true{
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewVenueProfile{
            let sectionObject = self.arrVenueProfilePropertyList[section]
            if self.isSectionExpanded(forSectionObj: sectionObject) == true{
                return 1
            }
            return 0
        }else {
            return (self.venueProfileDetail != nil) ? self.venueProfileDetail.VenueOpenHours.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewVenueProfile{
            return 250.0
        }else {
            return 20.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableViewVenueProfile{
            return self.getRowsForSection(section: indexPath.section)
        }
        else{
            return 22.0
        }
    }
    
    private func getRowsForSection(section : Int) -> CGFloat{
        let sectionObject = self.arrVenueProfilePropertyList[section]
        if self.isSectionExpanded(forSectionObj: sectionObject) == true {
            if sectionObject is WUVenueProfilePhotos {
                return 253
            }else  if sectionObject is WULocalPromotions || sectionObject is WUSpecials {
                return 183
            }else  if sectionObject is WULiveCams {
                if (sectionObject as! WULiveCams).LocalLiveCams.count == 1{
                    return 250.0
                }else{
                    return 420.0
                }
            }else{
                return UITableViewAutomaticDimension
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewVenueProfile{
            let sectionObject = self.arrVenueProfilePropertyList[indexPath.section]
            if sectionObject is WUVenueProfilePhotos || sectionObject is WULocalPromotions || sectionObject is WUSpecials{
                let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUVenueProfileTableCell()), for: indexPath) as! WUVenueProfileTableCell
                cell.delegate = self
                cell.venueProfileList = sectionObject
                cell.viewSeparator.isHidden = false
                self.mangeSeparator(cell: cell, forIndexPath: indexPath)
                return cell
            }else if sectionObject is WULiveCams{
                let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUExpandableViewAndCollectionTableCell()), for: indexPath) as! WUExpandableViewAndCollectionTableCell
                cell.delegate = self
                cell.venueProfileLiveCam = sectionObject as! WULiveCams
                cell.viewSeparator.isHidden = false
                self.mangeSeparator(cell: cell, forIndexPath: indexPath)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUExpandableImageTableCell()), for: indexPath) as! WUExpandableImageTableCell
                cell.delegate = self
                cell.venueProfileList = sectionObject
                cell.viewSeparator.isHidden = false
                self.mangeSeparator(cell: cell, forIndexPath: indexPath)
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUTimeSheetTableCell()), for: indexPath)as! WUTimeSheetTableCell
            cell.buttonCloseTimeSheet.isHidden = true
            if indexPath.row == self.venueProfileDetail.VenueOpenHours.count - 1{
                cell.buttonCloseTimeSheet.isHidden = false
            }
            cell.delegate = self
            cell.labelWeekDayName.font = UIFont.ProximaNovaMedium(15.0)
            cell.labelWeekDayName.text = "\(self.venueProfileDetail.VenueOpenHours[indexPath.row].Days)"
            cell.labelTime.text = "\(self.venueProfileDetail.VenueOpenHours[indexPath.row].Time[0])"
            
            if self.venueProfileDetail.VenueOpenHours[indexPath.row].includeToday.toBool() == true{
                cell.labelWeekDayName.font = UIFont.ProximaNovaBold(15.0)
                cell.labelWeekDayName.text = (self.venueProfileDetail.VenueOpenHours[indexPath.row].Days).uppercased()
            }
            return cell
        }
    }
    
    //MARK: - Manage Methods
    func mangeSeparator(cell : UITableViewCell , forIndexPath indexPath : IndexPath){
        if cell is WUVenueProfileTableCell {
            if indexPath.section == self.arrVenueProfilePropertyList.count - 1 {
                if self.tableViewVenueProfile.contentSize.height > self.tableViewVenueProfile.frame.size.height{
                    (cell as! WUVenueProfileTableCell).viewSeparator.isHidden = true
                }
            }
        }else  if cell is WUExpandableViewAndCollectionTableCell {
            if indexPath.section == self.arrVenueProfilePropertyList.count - 1 {
                if self.tableViewVenueProfile.contentSize.height > self.tableViewVenueProfile.frame.size.height{
                    (cell as! WUExpandableViewAndCollectionTableCell).viewSeparator.isHidden = true
                }
            }
        }else{
            if indexPath.section == self.arrVenueProfilePropertyList.count - 1 {
                if self.tableViewVenueProfile.contentSize.height > self.tableViewVenueProfile.frame.size.height{
                    (cell as! WUExpandableImageTableCell).viewSeparator.isHidden = true
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableViewVenueProfile.isHidden == false{
            self.buttonGoToTop.isHidden = false
            Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
            if scrollView.contentOffset.y > self.viewHeader.height{
                if self.arrSlider.count > 1 {
                    self.stopTimer()
                }
                
                self.manageViewBlackTopbar(isShow: true)
                self.view.endEditing(true)
            }else{
                if self.arrSlider.count > 1 {
                    self.startTimerForchangeImageAnimation()
                }
                self.manageViewBlackTopbar(isShow: false)
            }
        }else{
            self.buttonGoToTop.isHidden = true
        }
    }
    
    func manageViewBlackTopbar(isShow : Bool){
        if isShow == true {
            self.view.bringSubview(toFront: self.viewBlackTopBar)
            self.view.bringSubview(toFront: self.buttonGoToTop)
            self.viewBlackTopBar.isHidden = false
            self.viewBlackTopBar.alpha = 1.0
            self.constraintTopHeaderTop.constant = 0
            //            UIView.animate(withDuration: 0.3, animations: {
            //                self.view.layoutIfNeeded()
            //            })
        }else{
            UIView.animate(withDuration: 0.3, animations:{
                self.viewBlackTopBar.alpha = 0.0
            }, completion: { (isBool) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    if self.tableViewVenueProfile.contentOffset.y > self.viewHeader.height{
                        self.viewBlackTopBar.isHidden = true
                        self.view.sendSubview(toBack: self.viewBlackTopBar)
                        self.constraintTopHeaderTop.constant = -self.viewBlackTopBar.height
                    }
                })
            })
        }
    }
}

//MARK: - CollectionView
extension WUVenueProfileViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.venueProfileDetail != nil  && collectionView == self.collectionViewImageAnimate {
            return self.arrSlider.count
        }else{
            return self.arrShareOptions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewImageAnimate {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), for: indexPath)as! WUHomeSliderCollectionCell
            cell.venueLocalPromotion = self.arrSlider[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Utill.getClassNameFor(classType: WUCategoryCollectionCell()) , for: indexPath)as! WUCategoryCollectionCell
            cell.shareOption = self.arrShareOptions[indexPath.row]
            return cell
        }
    }
    
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        Utill.printInTOConsole(printData:"  collectionView willDisplay")
    //        if collectionView == self.collectionViewImageAnimate{
    //            if indexPath.row > 0 {
    //                self.stopTimer()
    //            }
    //        }
    //    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewImageAnimate {
            if self.arrSlider.count  > 1 {
                self.stopTimer()
                let currentPage = self.collectionViewImageAnimate.contentOffset.x / self.collectionViewImageAnimate.frame.size.width
                self.currentVisibleImageIndex = Int(currentPage)
                Utill.printInTOConsole(printData:"current index : \(currentPage)")
                Utill.printInTOConsole(printData:"didEndDisplaying")
                self.startTimerForchangeImageAnimation()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewImageAnimate {
            return CGSize(width: self.collectionViewImageAnimate.frame.size.width, height: 100.0)
        }else {
            return CGSize(width: 70.0, height: 115.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.collectionViewImageAnimate {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0.0)
        }else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionCategory {
            let cell = collectionView.cellForItem(at: indexPath) as! WUCategoryCollectionCell
            self.currentShareOptionIndex = indexPath.row
            
            let selectedType =  self.arrShareOptions[indexPath.row].shareOptionType
            switch selectedType {
            case .call :
                self.callForVenue(cell: cell, forIndexPath: indexPath)
                break
            case .share:
                self.shareVenue(cell: cell, forIndexPath: indexPath)
                break
            case .favorite:
                self.favoriteVenueForCell(cell: cell, forIndexPath: indexPath)
                break
            case .liveCam:
                //go to live screen
                self.playLiveCam(cell: cell, forIndexPath: indexPath)
                break
            case .website:
                self.openInWebsite(cell: cell, forIndexPath: indexPath)
                break
            case .addToCalendar:
                self.addEventToCalenderForCell(cell: cell, forIndexPath: indexPath)
                break
            case .follow:
                break
            case .rate:
                self.rateVenueForCell(cell: cell, forIndexPath: indexPath)
                break
            case .facebook:
                self.shareOnFacebook(cell: cell, forIndexPath: indexPath)
                break
            case .twitter:
                self.shareOnTwitter(cell: cell, forIndexPath: indexPath)
                break
            case .instagram:
                self.shareToInstagramForCell(cell: cell, forIndexPath: indexPath)
                break
            case .none:
                break
            }
        }
    }
    
    //MARK: - Collection Button Actions
    private func callForVenue(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        if self.venueProfileDetail.VenuePhone == "" {
            
        }else{
            //Utill.formatNumber(self.venueProfileDetail.VenuePhone)
            if let url = URL(string: "tel://\(Utill.formatNumber(self.venueProfileDetail.VenuePhone)!)"), UIApplication.shared.canOpenURL(url) {
                self.arrShareOptions[indexPath.row].isSelected = true
                cell.updateCellImage()
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            else {
                Utill.showAlertView(viewController: self, message:Text.Message.msg_Call)
            }
        }
    }
    
    private func shareVenue(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        self.arrShareOptions[indexPath.row].isSelected = true
        cell.updateCellImage()
        self.performSegue(withIdentifier: Text.Segue.venueProfileListToVenueShare, sender: nil)
    }
    
    private func favoriteVenueForCell(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        self.isFavoriteVenue = !self.isFavoriteVenue
        
        self.callWS_favoriteVenue(isFavorite: self.isFavoriteVenue, withCompletion: { (success) in
            if success == true{
                self.labelFavoriteCount.text = "(\(self.venueProfileDetail.VenueFavoriteCount))"
                self.buttonStarFavourite.isSelected = false
                if self.isFavoriteVenue == true{
                    self.buttonStarFavourite.isSelected = true
                }
                self.venueProfileDetail.IsUserFavoriteVenue = "\(self.isFavoriteVenue)"
                self.arrShareOptions[indexPath.row].isSelected = self.isFavoriteVenue
                cell.updateCellImage()
            }
        })
    }
    
    private func playLiveCam(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        self.arrShareOptions[indexPath.row].isSelected = true
        cell.updateCellImage()
        FirebaseManager.sharedInstance.play_venue_GUID_livecam_GUID_ios(parameter: nil, playLiveCamVenueM: self.venueProfileDetail)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            Utill.goToLivecamProfile(viewController: self, withLivecamM: self.venueProfileDetail.LiveCams.LocalLiveCams[0])
            
            /* if let vc = UIStoryboard.home.get(WUPlayLiveCamViewController.self){
             vc.hidesBottomBarWhenPushed = true
             vc.playLiveCamArray = self.venueProfileDetail.LiveCams.LocalLiveCams
             self.navigationController?.pushViewController(vc, animated: false)
             }*/
        })
    }
    
    private func openInWebsite(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        self.arrShareOptions[indexPath.row].isSelected = true
        cell.updateCellImage()
        
        var webSiteUrl = self.venueProfileDetail.VenueURL
        
        
        if webSiteUrl == "" {
            
        }else{
            if #available(iOS 10.0, *) {
                if webSiteUrl.isValidForUrl() == false{
                    webSiteUrl = "https://" + webSiteUrl
                }
                UIApplication.shared.open(URL(string : webSiteUrl)!, options: [:], completionHandler: { (status) in
                })
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private func addEventToCalenderForCell(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        self.arrShareOptions[indexPath.row].isSelected = true
        cell.updateCellImage()
        self.manageCalenderEvent()
    }
    
    private func rateVenueForCell(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        let rateView = WUVenueRateView.instanceFromNib()
        rateView.delegate = self
        rateView.venueDetail = self.venueProfileDetail
        rateView.rating = Int(self.venueProfileDetail.UserVenueRating) ?? 0
        rateView.showInView(superView: self.view)
    }
    
    private func shareOnFacebook(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        self.arrShareOptions[indexPath.row].isSelected = true
        cell.updateCellImage()
        
        var facebookUrl = self.venueProfileDetail.Facebook
        if facebookUrl.isValidForUrl() == false{
            facebookUrl = "https://" + facebookUrl
        }
        
        UIApplication.shared.open(URL(string : facebookUrl)!, options: [:], completionHandler: { (status) in
            self.arrShareOptions[indexPath.row].isSelected = false
            cell.updateCellImage()
        })
    }
    
    private func shareOnTwitter(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        self.arrShareOptions[indexPath.row].isSelected = true
        cell.updateCellImage()
        
        var twitterUrl = self.venueProfileDetail.Twitter
        if twitterUrl.isValidForUrl() == false{
            twitterUrl = "https://" + twitterUrl
        }
        UIApplication.shared.open(URL(string : twitterUrl)!, options: [:], completionHandler: { (status) in
            self.arrShareOptions[indexPath.row].isSelected = false
            cell.updateCellImage()
        })
        
    }
    
    private func shareToInstagramForCell(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        self.arrShareOptions[indexPath.row].isSelected = true
        cell.updateCellImage()
        
        var instragramUrl = self.venueProfileDetail.Instragram
        if instragramUrl.isValidForUrl() == false{
            instragramUrl = "https://" + instragramUrl
        }
        UIApplication.shared.open(URL(string : instragramUrl)!, options: [:], completionHandler: { (status) in
            self.arrShareOptions[indexPath.row].isSelected = false
            cell.updateCellImage()
        })
    }
    
    private func manageCalenderEvent(){
        let eventStore : EKEventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = self.venueProfileDetail.VenueName
                event.startDate = Date()
                event.endDate = Date()
                event.notes = self.venueProfileDetail.VenueDescription
                event.location = self.venueProfileDetail.VenueFullAddress
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    let controller = EKEventEditViewController()
                    controller.event = event
                    controller.eventStore = eventStore
                    controller.editViewDelegate = self
                    self.present(controller, animated: true, completion: nil)
                    try eventStore.save(event, span: .thisEvent)
                    
                } catch let error as NSError {
                    Utill.printInTOConsole(printData:"failed to save event with error : \(error)")
                }
                Utill.printInTOConsole(printData:"Saved Event")
            }
            else{
                
                Utill.printInTOConsole(printData:"failed to save event with error : or access not granted")
                if (granted == false){
                    Utill.showAlert_GoToSettingCancle_View(viewController: self, message: Text.Label.text_AllowAccessToCalender, completion: { (bool) in
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                        }
                    })
                }
            }
        }
    }
}

//MARK: - AddToCalender => EKEventEditViewDelegate
extension WUVenueProfileViewController : EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        self.dismiss(animated: true, completion: nil)
        
        let indexPath = IndexPath(item: self.currentShareOptionIndex, section: 0)
        if let cell = self.collectionCategory.cellForItem(at: indexPath) as? WUCategoryCollectionCell{
            if action == .saved {
                self.arrShareOptions[indexPath.row].isSelected = true
                cell.updateCellImage()
            }else{
                self.arrShareOptions[indexPath.row].isSelected = false
                cell.updateCellImage()
            }
        }
    }
}

//MARK: - HeaderView Delegate => ExpandCell
extension WUVenueProfileViewController : WUExpandableSectionHeaderViewDelegate {
    func expandableSectionHeaderView(didSelectExpandableSectionHeaderView headerView: UIView) {
        let index = headerView.tag
        let sectionObject = self.arrVenueProfilePropertyList[index]
        if self.isSectionExpanded(forSectionObj: sectionObject) == false {
            if sectionObject is WUVenueProfilePhotos {
                (sectionObject as! WUVenueProfilePhotos).isExpanded = true
            }else  if sectionObject is WULocalPromotions  {
                (sectionObject as! WULocalPromotions).isExpanded = true
            }else  if sectionObject is WUSpecials {
                (sectionObject as! WUSpecials).isExpanded = true
            }else  if sectionObject is WULiveCams {
                (sectionObject as! WULiveCams).isExpanded = true
            }else  if sectionObject is WUVenueHappyHours {
                (sectionObject as! WUVenueHappyHours).isExpanded = true
            }else  if sectionObject is WUMenus {
                (sectionObject as! WUMenus).isExpanded = true
            }else  if sectionObject is WULiveMusic {
                (sectionObject as! WULiveMusic).isExpanded = true
            }else  if sectionObject is WUSpecialEvents {
                (sectionObject as! WUSpecialEvents).isExpanded = true
            }
            
            if #available(iOS 11.0, *) {
                UIView.setAnimationsEnabled(false)
                self.tableViewVenueProfile.beginUpdates()
                self.tableViewVenueProfile.reloadSections(IndexSet(integer: index), with: .none)
                self.tableViewVenueProfile.endUpdates()
                UIView.setAnimationsEnabled(true)
            }else {
                UIView.performWithoutAnimation  {
                    self.tableViewVenueProfile.reloadData();
                    self.tableViewVenueProfile.layoutIfNeeded();
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                if ((sectionObject is WUVenueHappyHours && (sectionObject as! WUVenueHappyHours).isExpanded == true) || (sectionObject is WUMenus && (sectionObject as! WUMenus).isExpanded == true)  || (sectionObject is WULiveMusic && (sectionObject as! WULiveMusic).isExpanded == true) || (sectionObject is WUSpecialEvents && (sectionObject as! WUSpecialEvents).isExpanded == true))
                {
                    if self.tableViewVenueProfile.contentOffset.y+150 < self.tableViewVenueProfile.contentSize.height
                    {
                        self.tableViewVenueProfile.setContentOffset(CGPoint(x: 0, y: self.tableViewVenueProfile.contentOffset.y+150), animated: false)
                    }
                    else {
                        self.tableViewVenueProfile.setContentOffset(CGPoint(x: 0, y: self.tableViewVenueProfile.contentOffset.y+50), animated: false)
                    }
                }
                else {
                    self.tableViewVenueProfile.scrollToRow(at: IndexPath(row: 0, section: index), at: .none, animated: false)
                }
            })
            
        }
    }
    
    func expandableSectionHeaderView(didSelectViewAll headerView: UIView) {
        self.performSegue(withIdentifier: Text.Segue.venueProfileListToVenuePhotos, sender: nil)
    }
    
    func venueGoToTopButtonClicked() {
        self.tableViewVenueProfile.setContentOffset(CGPoint.zero, animated: true)
    }
}

//MARK: - WUExpandableViewAndCollectionTableCell of Close Button => LiveCam
extension WUVenueProfileViewController : WUVenueProfileTableCellDelegate {
    func venueCloseButton(cell: UITableViewCell, didSelectCloseButton button: UIButton) {
        print(type(of: cell))
        let indexPath = tableViewVenueProfile.indexPath(for: cell)
        let sectionObject = self.arrVenueProfilePropertyList[(indexPath?.section)!]
        
        if self.isSectionExpanded(forSectionObj: sectionObject) == true {
            if sectionObject is WUVenueProfilePhotos {
                (sectionObject as! WUVenueProfilePhotos).isExpanded = false
            }else  if sectionObject is WULocalPromotions  {
                (sectionObject as! WULocalPromotions).isExpanded = false
            }else  if sectionObject is WUSpecials {
                (sectionObject as! WUSpecials).isExpanded = false
            }else  if sectionObject is WULiveCams {
                (sectionObject as! WULiveCams).isExpanded = false
            }
            
            UIView.performWithoutAnimation  {
                self.tableViewVenueProfile.reloadData();
                self.tableViewVenueProfile.layoutIfNeeded();
            }
        }
    }
    
    func venueShareButton(cell: UITableViewCell, didSelectShareButton button: UIButton) {
        self.venueShareInfo()
    }
    
    func venueShareInfo(){
        WEB_API.call_api_GetShareLinkForVenueOrEvent(strVenueID: self.venueProfileDetail.SponsoredVenuID,strFourSquareVenueID : self.venueProfileDetail.FourSquareVenueID, strEventID: "", strLiveCamID: "") { (response, success, message) in
            if success == true{
                let dicShare = response?.dictionary!
                let coverPhotoURL = self.imageViewVenueCoverPhoto.image!
                let shareText = dicShare!["ShareMessage"]?.string!
                //let shareLink = dicShare!["ShareLink"]?.string!
                let shareLink = "https://apps.arvzapp.com/venue/\(self.venueProfileDetail.SponsoredVenuID)/FourSquareID/\(self.venueProfileDetail.FourSquareVenueID)"

                let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: coverPhotoURL) as Any,WUShareActivityItemProvider(placeholderItem: shareText ?? Text.Message.msg_Deeplinking_Share) as Any,WUShareActivityItemProvider(placeholderItem: shareLink ?? "https://apps.arvzapp.com/") as Any,WUShareActivityItemProvider(placeholderItem:"Venue Name : \(self.venueProfileDetail.VenueName)") as Any]
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
                activityViewController.excludedActivityTypes = [.addToReadingList ,.saveToCameraRoll , .copyToPasteboard , .addToReadingList ,.assignToContact ,.print , activityTypeCloud, .airDrop]
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
                
                activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                    if completed == true{
                        Utill.showAlertView(viewController: self, message: Text.Message.venueShareMsg)
                    }
                }
            }
        }
    }
    
    func venueCalendarButton(cell: UITableViewCell, didSelectCalendarButton button: UIButton) {
        self.manageCalenderEvent()
    }
    
    func didSelectPhoto(cell: UITableViewCell,currentVisibleIndex: IndexPath) {
        self.performSegue(withIdentifier:Text.Segue.venuePhotosToVenueIndividualPhoto , sender: currentVisibleIndex)
    }
}
//MARK: - WUExpandableImageTableCellDelegate
extension WUVenueProfileViewController : WUExpandableImageTableCellDelegate{
    func venueProfileTableCellLiveCamButtonClicked(cell: UITableViewCell, withVenueCategory venueCategory: Any) {
        if venueCategory is WUVenueLiveCams{
            Utill.goToLivecamProfile(viewController: self, withLivecamM: (venueCategory as! WUVenueLiveCams))
            
            /*if let vc = UIStoryboard.home.get(WUPlayLiveCamViewController.self){
             vc.hidesBottomBarWhenPushed = true
             vc.playLiveCamArray = [(venueCategory as! WUVenueLiveCams)]
             self.navigationController?.pushViewController(vc, animated: false)
             }*/
        }
    }
    
    func innerShareButton(cell: UITableViewCell, didSelectShareButton button: UIButton, tabel: UITableView) {
        self.venueShareInfo()
    }
    
    func innerCloseButton(cell: UITableViewCell, expandableImagetableCell: WUExpandableImageTableCell, didSelectCloseButton button: UIButton, tabel: UITableView) {
        let indexPath = self.tableViewVenueProfile.indexPath(for: expandableImagetableCell)
        let sectionObject = self.arrVenueProfilePropertyList[(indexPath?.section)!]
        
        if self.isSectionExpanded(forSectionObj: sectionObject) == true {
            if sectionObject is WUVenueHappyHours {
                (sectionObject as! WUVenueHappyHours).isExpanded = false
            }else  if sectionObject is WUMenus {
                (sectionObject as! WUMenus).isExpanded = false
            }else  if sectionObject is WULiveMusic {
                (sectionObject as! WULiveMusic).isExpanded = false
            }else  if sectionObject is WUSpecialEvents {
                (sectionObject as! WUSpecialEvents).isExpanded = false
            }
            
            //            if #available(iOS 11.0, *) {
            //                UIView.setAnimationsEnabled(false)
            //                self.tableViewVenueProfile.beginUpdates()
            //                self.tableViewVenueProfile.reloadSections(IndexSet(integer: (indexPath?.section)!), with: .none)
            //                self.tableViewVenueProfile.endUpdates()
            //                UIView.setAnimationsEnabled(true)
            //            }else {
            //                UIView.performWithoutAnimation  {
            self.tableViewVenueProfile.reloadData();
            self.tableViewVenueProfile.layoutIfNeeded();
            //                }
            //            }
        }
    }
    
    func innerCalendarButton(cell: UITableViewCell, expandableImagetableCell: WUExpandableImageTableCell, didSelectCalendarButton button: UIButton, tabel: UITableView) {
        //        let indexPath = tableViewVenueProfile.indexPath(for: expandableImagetableCell)
        //        let sectionObject = self.arrVenueProfilePropertyList[(indexPath?.section)!]
        ////        let internalIndexPath = tabel.indexPath(for: cell)
        ////print(internalIndexPath)
        //
        //            if sectionObject is WUVenueHappyHours {
        //                (sectionObject as! WUVenueHappyHours).HappyHours[0].isAddedToCalendar = true
        //            }else  if sectionObject is WUMenus {
        //                (sectionObject as! WUMenus).isExpanded = false
        //            }else  if sectionObject is WULiveMusic {
        //                (sectionObject as! WULiveMusic).isExpanded = false
        //            }else  if sectionObject is WUSpecialEvents {
        //                (sectionObject as! WUSpecialEvents).isExpanded = false
        //            }
        
        self.manageCalenderEvent()
    }
    
    func goToTopButtonClicked() {
        self.tableViewVenueProfile.setContentOffset(.zero, animated: true)
    }
    
    func expandableImageTableCell(innerCell: UITableViewCell, didLoadImage image: UIImage) {
        DispatchQueue.main.async {
            if let indexpath = self.tableViewVenueProfile.indexPath(for: innerCell){
                if #available(iOS 11.0, *) {
                    UIView.setAnimationsEnabled(false)
                    self.tableViewVenueProfile.beginUpdates()
                    self.tableViewVenueProfile.reloadSections(IndexSet(integer: indexpath.section), with: .none)
                    self.tableViewVenueProfile.endUpdates()
                    UIView.setAnimationsEnabled(true)
                }else {
                    UIView.performWithoutAnimation  {
                        self.tableViewVenueProfile.reloadData();
                        self.tableViewVenueProfile.layoutIfNeeded();
                    }
                }
            }
        }
    }
}

//MARK: - WUTimeSheetTableCellDelegate to close TimeSheet
extension WUVenueProfileViewController : WUTimeSheetTableCellDelegate{
    func timeSheetTableCell(cell: WUTimeSheetTableCell, buttonCloseTimeSheet button: UIButton) {
        self.viewTimeSheet.isHidden = true
    }
}
//MARK: - MAPView
extension WUVenueProfileViewController : MKMapViewDelegate {
    
}
//MARK: - TextField
extension WUVenueProfileViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.imageViewSearchTextBorder.image = #imageLiteral(resourceName: "SearchTextFieldBorderActive")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textFieldSearchText.text = textField.text
        self.view.endEditing(true)
        if let vc = UIStoryboard.home.get(WUHomeSearchViewController.self){
            vc.isTextFromHomeSearch = self.textFieldSearchText.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.imageViewSearchTextBorder.image = #imageLiteral(resourceName: "SearchTextFieldBorderNormal")
    }
}

//MARK: - Rate Delegate
extension WUVenueProfileViewController : WUVenueRateDelegate{
    func venueRateConfirm(didSelectConfirmButton: UIButton, withRatings rating: Int) {
        self.setupForRatingForVenue()
    }
    
    func venueRateCancel(didSelectCancelButton: UIButton) {
        
    }
    
    private func hightLightRateIcon(){
        let rateObj = self.arrShareOptions.filter { $0.shareOptionType == .rate}
        let indexPath = IndexPath(item: self.arrShareOptions.index(of: rateObj[0])!, section: 0)
        self.arrShareOptions[indexPath.row].isSelected = true
        self.collectionCategory.reloadItems(at: [indexPath])
    }
    
    private func hightLightFavouriteIcon(){
        let favObj = self.arrShareOptions.filter { $0.shareOptionType == .favorite}
        let indexPath = IndexPath(item: self.arrShareOptions.index(of: favObj[0])!, section: 0)
        self.arrShareOptions[indexPath.row].isSelected = true
        self.collectionCategory.reloadItems(at: [indexPath])
    }
}
