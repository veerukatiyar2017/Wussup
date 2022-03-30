//
//  WUHomeViewController.swift
//  Wussup
//
//  Created by MAC26 on 18/04/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import Foundation
import AVKit
import SDWebImage
import GooglePlaces

struct HomeVenueData : Codable {
    let CategorisedVenues                 : [WUCategorisedVenues]
    let TopVenues                         : WUTopSpots
    let LocalLiveCams                     : WULiveCams
    let LocalPromotions                   : WULocalPromotions
    var LiveCamBanners                    : [WUHomeBannerList]
    
    var PlaceholderOutdoors               : WUPlaceholder!
    var PlaceholderLiveCams               : WUPlaceholder!
    var PlaceholderCafes                  : WUPlaceholder!
    var PlaceholderColleges               : WUPlaceholder!
    var PlaceholderOther                  : WUPlaceholder!
    var PlaceholderEventAds               : WUPlaceholder!
    var PlaceholderMusic                  : WUPlaceholder!
    var PlaceholderArtsandEntertainment   : WUPlaceholder!
    var PlaceholderShop                   : WUPlaceholder!
    var PlaceholderTravel                 : WUPlaceholder!
    var PlaceholderNightlife              : WUPlaceholder!
    var PlaceholderTopSpotAds             : WUPlaceholder!
    var PlaceholderFood                   : WUPlaceholder!
    var PlaceholderLocalPromotionAds      : WUPlaceholder!
    //var Categories
}

class WUHomeViewController: UIViewController {
    
    typealias TypePlaceholder = WUPlaceholder.TypePlaceholder
    
    // MARK: - IBOutlets
    @IBOutlet private weak var buttonGoToTop                        : UIButton!
    @IBOutlet private weak var viewAnimatedImageHeight              : NSLayoutConstraint!
    @IBOutlet private weak var labelNoResults                       : UILabel!
    @IBOutlet private weak var viewHeaderContainer                  : UIView!
    @IBOutlet weak var tableViewHome                                : UITableView!
    @IBOutlet private weak var constraintTopHeaderHeight            : NSLayoutConstraint!
    @IBOutlet private weak var viewVideo                            : UIView!
    @IBOutlet private weak var viewVideoContainer                   : UIView!
    @IBOutlet private weak var constraintBlackTopBarHeight          : NSLayoutConstraint!
    @IBOutlet private weak var constraintTopHeaderTop               : NSLayoutConstraint!
    @IBOutlet private weak var bannersCollectionView                : UICollectionView!
    @IBOutlet private weak var noBannersPlaceholder                 : UIImageView!
    @IBOutlet private weak var viewHeader                           : HeaderContainerView!
    @IBOutlet private weak var viewHeaderTop                        : HeaderTopContainerView!
    @IBOutlet private weak var viewBlackTopBar                      : HeaderTopContainerView!
    @IBOutlet private weak var viewAnimatedImage                    : UIView!
    @IBOutlet private weak var buttonMute                           : UIButton!
    @IBOutlet private weak var viewFooter                           : UIView!
    @IBOutlet private weak var buttonClaimBussiness                 : UIButton!
    @IBOutlet private weak var buttonShare                          : UIButton!
    @IBOutlet private weak var imageViewWeather                     : UIImageView!
    @IBOutlet private weak var labelWeather                         : UILabel!
    @IBOutlet private weak var collectionViewImageAnimate           : UICollectionView!
    @IBOutlet private weak var buttonSearch                         : UIButton!
    @IBOutlet private weak var labelWeatherCity                     : UILabel!
    
    // MARK: - Image Animation Variables
    private var arrVideoUrls                    : [String]!
    private var currentVideoUrlIndex = 0
    
    private var currentVisibleIndex = 0
    private var timerAnimation                  : Timer?
    var verticalContentOffset                   : CGFloat!
    private var placesClient: GMSPlacesClient!
//    var getDataFirs: NSObject {
//        return self.getData()
//    }

    // MARK: - Play Video Variables
    var player                                  : AVPlayer?
    private var playerController                : AVPlayerViewController!
    
    // MARK: - Variables
    private var homeVenueAllData                : HomeVenueData!
    private var homeAdsData                     : WUHomeAds!
    private var cityName                        : String!
    private var arrBannerListData               : [WUHomeBannerList] = []
    private var arrVideoListData                : [WUHomeVideoList] = []

    private var arrHomeVenueDataList            : [Any]! = []
    private var selectedCategoryVenueForViewAll : Any!
    private var selectedVenueForDetail          : Any!
    private var isFirstLogin                    : Bool!
    private var placeholdersDictionary          : [String : WUPlaceholder]!

    // MARK: - Pull To Refresh
    var refreshView                             : RefreshView!
    
    var tableViewRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = UIColor.SearchBarYellowColor
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isFirstLogin = true
        self.tableViewHome.alwaysBounceVertical = true
        self.prepareUI()
        self.initialInterfaceSetUp()
        placesClient = GMSPlacesClient.shared()
        self.callGooglePlaceAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getData()
        self.buttonSearch.isSelected = false
        self.buttonShare.isSelected = false
        if  self.player != nil {
            if self.tableViewHome.contentOffset.y < self.viewVideo.frame.size.height{
                self.player?.play()
            }
        }
        
        if self.verticalContentOffset != nil {
            DispatchQueue.main.async {
                Utill.printInTOConsole(printData:"*** \(String(describing: self.verticalContentOffset))" )
                let offset = CGPoint.init(x: 0, y:self.verticalContentOffset)
                self.tableViewHome.setContentOffset(offset, animated: false)
            }
        }
        
        if self.arrBannerListData.count > 1 {
            self.startTimerForchangeImageAnimation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.player?.pause()
        self.buttonMute.isSelected = true
        self.player?.isMuted = true
        if self.arrBannerListData.count > 1 {
            self.stopTimer()
        }
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.viewHeaderContainer.dropShadow()
        self.viewBlackTopBar.dropBlcakShadow()
        self.viewBlackTopBar.isHidden = true
        self.buttonGoToTop.isHidden = true
        self.viewHeaderTop.isHidden = false
        self.constraintTopHeaderHeight.constant = viewHeaderTop.height
        self.constraintBlackTopBarHeight.constant = viewBlackTopBar.height
        self.viewHeader.frame = CGRect(x: 0,
                                       y: 0,
                                       width: self.tableViewHome.frame.size.width,
                                       height: self.view.frame.size.width / 375 * 480) //self.viewHeader.height)
        self.viewFooter.isHidden = true
        self.tableViewHome.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.tableViewHome.frame.width, height: 0.0)
        //self.manageBanner(isShow: false)
        self.collectionViewImageAnimate.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()))
        
//        self.arrVideoUrls = [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
//                              "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
//                              "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
//                              "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
//                              "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
//                              "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"]
    }
    
    func getData() {
        
        AppDel.setUpLocationManager(completion: {   // set location
            
            self.callWS_getCityNameFromCordinates(completion: { city in // get city name
                
                if self.isFirstLogin {
                    self.getContentForCity(city)
                    self.isFirstLogin = false
                } else {
                    if (CurrentCityManager.shared.currentCity != city) {
                        self.getContentForCity(city)
                    }
                }
            })
        })
    }
    
    private func getContentForCity( _ city: String!) {
        
        CurrentCityManager.shared.currentCity = city
        self.showOverleyViewWithCity(city)
        self.call_api_GetLocationKeyOfCity()    // get weather
        self.callWS_getHomeAds()                // get ads
     //   self.callWS_getHomeVenueList()          // get venue
        
    }
    
    // MARK: - Pull To Refresh
    
    func prepareUI() {
        self.tableViewHome.refreshControl = tableViewRefreshControl
        getRefereshView()
    }
    
    func getRefereshView() {
        if let objOfRefreshView = Bundle.main.loadNibNamed("RefreshView",
                                                           owner: self,
                                                           options: nil)?.first as? RefreshView {
            refreshView = objOfRefreshView
            refreshView.frame = tableViewRefreshControl.frame
            tableViewRefreshControl.addSubview(refreshView)
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.getData()
        
        self.player?.play()
        self.tableViewHome.reloadData()
        self.playContinousVideo()
        self.tableViewRefreshControl.endRefreshing()
    }
    
    //MARK: - Show Label Of No Result Found
    
    private func showNoResult(show : Bool ,message : String ) {
        if show {
            self.viewFooter.isHidden = false
            self.tableViewHome.tableFooterView?.frame = CGRect(x: 0,
                                                               y: 0,
                                                               width: self.tableViewHome.frame.width,
                                                               height: 40.0)
            self.tableViewHome.tableFooterView = self.viewFooter
            self.labelNoResults.isHidden = false
            self.buttonGoToTop.isHidden = true
        } else {
            self.viewFooter.isHidden = true
            self.tableViewHome.tableFooterView?.frame = CGRect(x: 0,
                                                               y: 0,
                                                               width: self.tableViewHome.frame.width,
                                                               height: 0.0)
            self.labelNoResults.isHidden = true
            self.buttonGoToTop.isHidden = false
        }
        self.labelNoResults.text = message
    }
    
    // MARK: - getCityName, getHomeAds, getHomeVenueList, getWeather
    
    func callWS_getCityNameFromCordinates(completion:@escaping ((String) -> Void)) {
        
        WEB_API.call_api_CityNameFromCordinates(withCompletionHandler:
            { (response, status, message) in
                //if status == true {
                if response != nil {
                    let city = String(describing: response!["City"]).uppercased()
                    self.labelWeatherCity.text = city
                    completion(city)
                    print("////city - \(city)")
                } else {
                    self.labelWeatherCity.text = ""
                }
                //            } else {
                //                self.manageBanner(isShow: false)
                //            }
        })
    }
    
    // getHomeAds
    func callWS_getHomeAds() {
        WEB_API.call_api_GetHomeAds(withCompletionHandler: { (response,status,message) in
            if status == true {
                let data = try! JSONSerialization.data(withJSONObject: (response!).dictionaryObject ?? [:], options: [])
                self.homeAdsData = try! JSONDecoder().decode(WUHomeAds.self, from: data)
                let sortedBannerList = self.homeAdsData.BannerList.shuffled()
                let sortedVideoList = self.homeAdsData.VideoList.shuffled()

                Utill.saveHomeBannerModel(sortedBannerList)
                if self.homeAdsData.VideoList.count > 0 {
                    self.arrVideoListData = sortedVideoList
                    self.currentVisibleIndex = 0
                    self.playContinousVideo()
                } else {
                    self.playPlaceholderVideo()
                }
                
                if self.homeAdsData.BannerList.count > 0 {
                    self.manageBanner(isShow: true)
                    if self.homeAdsData.BannerList.count > 1 {
                        self.arrBannerListData = sortedBannerList.repeated(count: sliderRepeatCount)
                        self.collectionViewImageAnimate.reloadData()
                        self.startTimerForchangeImageAnimation()
                    } else {
                        self.arrBannerListData = sortedBannerList
                        self.collectionViewImageAnimate.reloadData()
                    }
                    // let array = [1,2,3].repeated(count: 3)
                } else {
                    self.manageBanner(isShow: false)
                }
            } else {
            }
        })
    }
    // get Google Place API
    func callGooglePlaceAPI() {
        
        let placeFields: GMSPlaceField = [.name, .formattedAddress]
            placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { [weak self] (placeLikelihoods, error) in
              guard let strongSelf = self else {
                return
              }

              guard error == nil else {
                print("Current place error: \(error?.localizedDescription ?? "")")
                return
              }

              guard let place = placeLikelihoods?.first?.place else {
//                strongSelf.nameLabel.text = "No current place"
//                strongSelf.addressLabel.text = ""
                return
              }
                print(place.name)
                var lat = place.coordinate.latitude
                    var lon = place.coordinate.longitude
                    print("lat lon",lat,lon)
                print(place.formattedAddress)
//              strongSelf.nameLabel.text = place.name
//              strongSelf.addressLabel.text = place.formattedAddress
            }
    }
    
    // getHomeVenueList
    func callWS_getHomeVenueList() {
        WEB_API.call_api_GetHomeVenuesList(user: Utill.getUserModel()!,
                                           withCompletionHandler:
            { (response, status, message) in
                if status == true {
                    self.arrHomeVenueDataList.removeAll()
                    let data = try! JSONSerialization.data(withJSONObject: response?.dictionaryObject ?? [:], options: [])
                    self.homeVenueAllData = try! JSONDecoder().decode(HomeVenueData.self, from: data)
                    self.placeholdersDictionary = self.setPlaceholdersToDictionary()

                    Utill.printInTOConsole(printData:"///\(String(describing: self.homeVenueAllData))")
                    
                    self.randomArraysSorting()
                    self.prepareArrayHomeVenueList()
                    if self.arrHomeVenueDataList.count == 0 {
                        self.showNoResult(show: true, message: Text.Message.noDataFound)
                    } else {
                        self.showNoResult(show: false, message: Text.Message.noDataFound)
                    }
                    self.tableViewHome.reloadData()
                } else {
                    if self.arrHomeVenueDataList.count > 0 {
                        self.showNoResult(show: false, message: "")
                    } else {
                        self.showNoResult(show: true, message: Text.Message.noDataFound)
                        Utill.showAlertView(viewController: self, message: message)
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9, execute: {
                    if AppDel.redirectUrl != nil {
                        if AppDel.redirectUrl.host == "venue" {
                            AppDel.reDirectToVenueProfile(redirectUrl : AppDel.redirectUrl)
                        }else if AppDel.redirectUrl.host == "event"{
                            AppDel.reDirectToEventProfile(redirectUrl : AppDel.redirectUrl)
                        }else if AppDel.redirectUrl.host == "livecam"{
                            AppDel.reDirectToLiveCamProfile(redirectUrl: AppDel.redirectUrl)
                        }
                        AppDel.redirectUrl = nil
                    }
                    
                    if AppDel.NotificationUserInfo != nil {
                        AppDel.checkFavoriteNotification()
                        AppDel.NotificationUserInfo = nil
                    }
                })
        })
    }
    
    private func call_api_GetLocationKeyOfCity() {
        
        WEB_API.call_api_GetLocationKeyOfCity()
            { (response,status,message) in
                
                if response != nil {
                    let arr = response?.array
                    if arr != nil, (arr?.count)! > 0 {
                        if let locationKey =  arr![0]["Key"].string {
                            WEB_API.call_api_GetCurrnetConditionWeather (strLocationKey: locationKey,
                                                                         withCompletionHandler:
                                { (responseWeather,statusWeather,messageWeather) in
                                    
                                    Utill.printInTOConsole(printData:"response \(responseWeather ?? "")")
                                    let arrWeather = responseWeather?.array
                                    if arrWeather != nil , (arrWeather?.count)! > 0 {
                                        
                                        if let dicWeather = arrWeather![0].dictionary {
                                            
                                            let weatherIconNo = dicWeather["WeatherIcon"]?.int64
                                            let weatherIcon = "https://developer.accuweather.com/sites/default/files/\(String(format: "%02d", weatherIconNo!))-s.png"
                                            self.imageViewWeather.sd_setImage(with: URL(string: weatherIcon), completed: nil)
                                            self.labelWeather.attributedText =
                                                "\((dicWeather["Temperature"]!["Imperial"]["Value"].int64)!) {o}F".customText()
                                        }
                                    }
                            })
                        }
                    }
                }
        }
    }
    
    private func setPlaceholdersToDictionary() -> [String : WUPlaceholder] {
        
        var placeholdersDictionary: [String : WUPlaceholder]!
        placeholdersDictionary =
            [TypePlaceholder.Outdoors.stringValue             : self.homeVenueAllData.PlaceholderOutdoors,
             TypePlaceholder.LiveCams.stringValue             : self.homeVenueAllData.PlaceholderLiveCams,
             TypePlaceholder.Cafes.stringValue                : self.homeVenueAllData.PlaceholderCafes,
             TypePlaceholder.Colleges.stringValue             : self.homeVenueAllData.PlaceholderColleges,
             TypePlaceholder.Other.stringValue                : self.homeVenueAllData.PlaceholderOther,
             TypePlaceholder.Event.stringValue                : self.homeVenueAllData.PlaceholderEventAds,
             TypePlaceholder.Music.stringValue                : self.homeVenueAllData.PlaceholderMusic,
             TypePlaceholder.ArtsandEntertainment.stringValue : self.homeVenueAllData.PlaceholderArtsandEntertainment,
             TypePlaceholder.Shop.stringValue                 : self.homeVenueAllData.PlaceholderShop,
             TypePlaceholder.Travel.stringValue               : self.homeVenueAllData.PlaceholderTravel,
             TypePlaceholder.Nightlife.stringValue            : self.homeVenueAllData.PlaceholderNightlife,
             TypePlaceholder.TopSpotAds.stringValue           : self.homeVenueAllData.PlaceholderTopSpotAds,
             TypePlaceholder.Food.stringValue                 : self.homeVenueAllData.PlaceholderFood,
             TypePlaceholder.LocalPromotion.stringValue       : self.homeVenueAllData.PlaceholderLocalPromotionAds]
        
        return placeholdersDictionary
    }
    
    // MARK: -  Overley View
    
    private func showOverleyViewWithCity( _ city: String?) {
        
        // add OverleyView
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let imageViewLogo = self.createOverleyImageView()
            imageViewLogo.image = UIImage.init(named: "overlay")
            imageViewLogo.contentMode = .scaleAspectFit
            
            let imageViewText = self.createOverleyImageView()
            if city != nil {
                imageViewText.image = TextRotation.imageOfArtboard(text: city!,
                                                               frame: self.viewVideo.bounds)
            } else {
                imageViewText.image = TextRotation.imageOfArtboard(text: "Welcome to app",
                                                                   frame: self.viewVideo.bounds)
            }
            self.viewVideo.addSubview(imageViewLogo)
            self.viewVideo.addSubview(imageViewText)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.viewHeaderTop.isHidden = false
                //imageViewLogo.removeFromSuperview()
                //imageViewText.removeFromSuperview()
            }
        }
    }
    
    private func createOverleyImageView() -> UIImageView {
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0.0,
                                 y: 0.0,
                                 width: self.viewVideo.frame.size.width,
                                 height: self.viewVideo.frame.size.height - 0.0)
        return imageView
    }
    
    private func randomArraysSorting() {
        
        let sortedVenues = self.homeVenueAllData.TopVenues.Venues.shuffled()
        self.homeVenueAllData.TopVenues.Venues = sortedVenues
        
        let sortedVenuePromotions = self.homeVenueAllData.LocalPromotions.VenuePromotions.shuffled()
        self.homeVenueAllData.LocalPromotions.VenuePromotions = sortedVenuePromotions
        
        let sortedLocalLiveCams = self.homeVenueAllData.LocalLiveCams.LocalLiveCams.shuffled()
        self.homeVenueAllData.LocalLiveCams.LocalLiveCams = sortedLocalLiveCams
        
        let sortedLiveCamBanners = self.homeVenueAllData.LiveCamBanners.shuffled()
        self.homeVenueAllData.LiveCamBanners = sortedLiveCamBanners
        
        for array in self.homeVenueAllData.CategorisedVenues {
            let sortedCategorisedEvents = array.Events.shuffled()
            array.Events = sortedCategorisedEvents
            let sortedCategorisedVenues = array.Venues.shuffled()
            array.Venues = sortedCategorisedVenues
        }
    }
    
    private func prepareArrayHomeVenueList() {
        //        if self.homeVenueAllData.TopVenues.Venues.count > 0 {
        self.arrHomeVenueDataList.append(self.homeVenueAllData.TopVenues)
        //        }
        //        if self.homeVenueAllData.LocalPromotions.VenuePromotions.count > 0 {
        self.arrHomeVenueDataList.append(self.homeVenueAllData.LocalPromotions)
        //        }
        //        if self.homeVenueAllData.LocalLiveCams.LocalLiveCams.count > 0 {
        self.arrHomeVenueDataList.append(self.homeVenueAllData.LocalLiveCams)
        //        }
        //        if self.homeVenueAllData.CategorisedVenues.count > 0 {
        for cateVenue in self.homeVenueAllData.CategorisedVenues {
            self.arrHomeVenueDataList.append(cateVenue)
        }
        //        }
        Utill.saveHomeBannerModel(homeVenueAllData.LiveCamBanners)
    }
    
    // MARK: - Local promotion Animation methods
    //To change images contiouesly in header slider
    private func startTimerForchangeImageAnimation(){
        if self.timerAnimation == nil  {
            self.timerAnimation = Timer.scheduledTimer(timeInterval: 03.0,
                                                       target: self,
                                                       selector: #selector(self.updateImage),
                                                       userInfo: nil,
                                                       repeats: true)
        }
    }
    
    private func stopTimer() {
        if self.timerAnimation != nil {
            self.timerAnimation?.invalidate()
            self.timerAnimation = nil
        }
    }
    
    @objc func updateImage() {
        if self.arrBannerListData.count > 0{
            self.manageBanner(isShow: true)
            self.currentVisibleIndex = self.currentVisibleIndex + 1
            if self.currentVisibleIndex >= self.arrBannerListData.count {
                self.currentVisibleIndex = 0
                //                self.collectionViewImageAnimate.scrollToItem(at:IndexPath(row: self.currentVisibleIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
            }
            if self.currentVisibleIndex < self.arrBannerListData.count{
                DispatchQueue.main.async {
                    if self.currentVisibleIndex == 0 {
                        self.collectionViewImageAnimate.scrollToItem(at:IndexPath(row: self.currentVisibleIndex, section: 0), at: UICollectionViewScrollPosition.right, animated: false)
                    }
                    else{
                        self.collectionViewImageAnimate.scrollToItem(at:IndexPath(row: self.currentVisibleIndex, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
                    }
                }
            }
        }else{
            //            self.stopTimer()
            self.manageBanner(isShow: false)
        }
    }
    
    // MARK: - Action Methods
    @IBAction func buttonWeatherAction(_ sender: UIButton) {
        //  self.performSegue(withIdentifier: Text.Segue.homeToVenueDetail, sender: nil)
    }
    
    @IBAction func buttonMuteAction(_ sender: UIButton) {
        if self.player?.isMuted == true{
            self.player?.isMuted = false
            sender.isSelected = false
        }else{
            self.player?.isMuted = true
            sender.isSelected = true
        }
    }
    
    @IBAction func buttonViewEventAction(_ sender: UIButton) {
        if self.arrVideoListData.count > 0 {
            FirebaseManager.sharedInstance.ad_herovid_GUID_ios(parameter: nil, videoBanner: self.arrVideoListData[self.currentVideoUrlIndex])
            
            if let vc : WUEventProfileViewController = UIStoryboard.events.get(WUEventProfileViewController.self){
                self.verticalContentOffset  = self.tableViewHome.contentOffset.y
                vc.selectedEventId = self.arrVideoListData[self.currentVideoUrlIndex].EventID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func buttonClaimBussiness(_ sender: UIButton) {
        FirebaseManager.sharedInstance.claimbiz_start_ios(parameter: nil)
        //        Utill.showAlertView(viewController: self, message: Text.Message.claimBussiness)
        self.performSegue(withIdentifier:Text.Segue.homeVCToClaimBusiness, sender: nil)
    }
    
    @IBAction func buttonSearchBlackAction(_ sender: UIButton) {
        self.buttonSearch.isSelected = true
        self.performSegue(withIdentifier:Text.Segue.homeViewControllerToSearchResult, sender: nil)
    }
    @IBAction func buttonSearchAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.performSegue(withIdentifier: Text.Segue.homeViewControllerToSearchResult, sender: nil)
    }
    @IBAction func buttonShareAction(_ sender: UIButton) {
        FirebaseManager.sharedInstance.shareapp_ios(parameter: nil)
        self.buttonShare.isSelected = true
        let text = "Check out ARVZAPP"
        let image = #imageLiteral(resourceName: "WussUpShareIcon")
        let webSite : URL = URL(string:APPSTORE_URL)!
        
        let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: text) as Any,WUShareActivityItemProvider(placeholderItem: image) as Any,WUShareActivityItemProvider(placeholderItem: webSite) as Any]
        
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
        activityViewController.excludedActivityTypes = [.addToReadingList ,.saveToCameraRoll , .copyToPasteboard ,.assignToContact ,.print , activityTypeCloud, .airDrop]
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true) {
            self.buttonShare.isSelected = true
            self.player?.pause()
        }
        
        activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            self.buttonShare.isSelected = false
            self.player?.play()
            
            if completed{
                //                if (activityType?.rawValue == "com.apple.reminders.RemindersEditorExtension") || (activityType?.rawValue ==  "net.whatsapp.WhatsApp.ShareExtension"){
                //
                //                }else {
                Utill.showAlertView(viewController: self, message: Text.Message.applicationShareMsg)
                //                }
            }
        }
    }
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.tableViewHome.setContentOffset(CGPoint.zero, animated: true)
    }
    // MARK: - Video Player methods
    
    //    @objc func playerFromBackGroundTOForground(notification: Notification){
    //        if let tabbarController = GlobalShared.appTabbarController {
    //            let vc = (tabbarController.selectedViewController as! UINavigationController).viewControllers.last
    //            if vc is WUHomeViewController{
    //                self.player?.play()
    //            }
    //        }
    //    }
    
    //To change video contiouesly in header
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        Utill.printInTOConsole(printData:"Video Finished")
        self.currentVideoUrlIndex = self.currentVideoUrlIndex + 1
        if self.arrVideoListData.count > 0 {
            self.playContinousVideo() //2
        } else {
            self.playPlaceholderVideo()
        }
    }
    
    private func playContinousVideo() {
        if self.homeAdsData != nil {
            self.playVideo(withUrl: self.homeAdsData.VideoList)
        }
    }
    
    //Play video
    private func playVideo(withUrl arrURL: [WUHomeVideoList]) {
        
        if self.playerController == nil {
            self.playerController = AVPlayerViewController()
        }
        if currentVideoUrlIndex >= arrURL.count
        {
            currentVideoUrlIndex = 0
        }
        if (arrURL.count > 0)
        {
            let url = arrURL[currentVideoUrlIndex].VideoURL
            if url != ""
            {
                if let urlVideo = URL(string: url){
                    let avplayerItem = AVPlayerItem(url: urlVideo)
                    self.player = AVPlayer(playerItem: avplayerItem)
                    self.player?.rate = 1.0;
                    self.player?.isMuted = false
                    if self.buttonMute.isSelected == true{
                        self.player?.isMuted = true
                    }
                    
                    self.playerController.player = self.player
                    self.playerController.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
                    self.playerController.view.isUserInteractionEnabled = false
                    self.playerController.view.frame = self.viewVideo.bounds
                    self.playerController.showsPlaybackControls = false
                    self.playerController.updatesNowPlayingInfoCenter = false
                    self.viewVideo.addSubview(self.playerController.view)
                    self.player?.play()
                }
            }
        }
    }
    
    private func playPlaceholderVideo() {
        
        if self.playerController == nil {
            self.playerController = AVPlayerViewController()
        }
        
        let urlVideosPlaceholder = homeAdsData.PlaceholderVideoAds.Url
        //https://wussup-sandbox.s3.amazonaws.com/App_Videos%2FUniversal+Placeholder+Video+Ads+1.mp4
        
        // set PlaceholderVideoAds
        if let urlVideo = URL(string: urlVideosPlaceholder) {
            let avplayerItem = AVPlayerItem(url: urlVideo)
            self.player = AVPlayer(playerItem: avplayerItem)
            self.player?.rate = 1.0;
            self.player?.isMuted = false
            if self.buttonMute.isSelected == true {
                self.player?.isMuted = true
            }
            
            self.playerController.player = self.player
            self.playerController.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
            self.playerController.view.isUserInteractionEnabled = false
            self.playerController.view.frame = self.viewVideo.bounds
            self.playerController.showsPlaybackControls = false
            self.playerController.updatesNowPlayingInfoCenter = false
            self.viewVideo.addSubview(self.playerController.view)
            self.player?.play()
        }
    }
    
    private func manageBanner(isShow : Bool) {
        
        if isShow == true {
            noBannersPlaceholder.isHidden = true
            bannersCollectionView.isHidden = false
            
            //self.viewAnimatedImage.isHidden = false
            //self.viewAnimatedImageHeight.constant = 100.0
           // self.viewHeader.frame = CGRect(x: 0, y: 0, width: self.tableViewHome.frame.size.width, height: 500.0)
        } else {
            bannersCollectionView.isHidden = true
            noBannersPlaceholder.isHidden = false

            // set PlaceholderBannerAds
            let urlBannerAdsPlaceholder = homeAdsData.PlaceholderBannerAds.Url
            noBannersPlaceholder.sd_setImage(with: URL(string: urlBannerAdsPlaceholder), completed: nil)
            
            // self.viewAnimatedImage.isHidden = true
            // self.viewAnimatedImageHeight.constant = 0.0
            //self.viewHeader.frame = CGRect(x: 0, y: 0, width: self.tableViewHome.frame.size.width, height: 500.0)
            //self.viewHeader.frame = CGRect(x: 0, y: 0, width: self.tableViewHome.frame.size.width, height: 400.0)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.verticalContentOffset  = self.tableViewHome.contentOffset.y
        if segue.identifier == Text.Segue.homeViewAll{
            let homeViewAll = segue.destination as! WUHomeViewAllViewController
            homeViewAll.delegate = self
            homeViewAll.selectedHomeVenueData = self.selectedCategoryVenueForViewAll
        }
        
        if segue.identifier == Text.Segue.homeToVenueDetail {
            let venueProfileVC = segue.destination as! WUVenueProfileViewController
            venueProfileVC.delegate = self
            venueProfileVC.venue = self.selectedVenueForDetail
        }
        
        
        if segue.identifier == Text.Segue.homeViewControllerToSearchResult{
            let searchVC = segue.destination as! WUHomeSearchViewController
            searchVC.delegateRating = self
        }
        
        if segue.identifier == Text.Segue.homeVCToClaimBusiness{
            let claimABusinessVC = segue.destination as! WUClaimABusinessViewController
            claimABusinessVC.hidesBottomBarWhenPushed = true
            // claimABusinessVC.isFromCABVC = true
        }
    }
}

//MARK: - TableView
extension WUHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHomeVenueDataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.arrHomeVenueDataList[indexPath.row] is WUTopSpots{
            if (self.arrHomeVenueDataList[indexPath.row] as? WUTopSpots )?.Venues.count == 0 {
                return 275.0//240.0 // placeholder
            }
            else {
                return 275.0
            }
        }else if self.arrHomeVenueDataList[indexPath.row] is WULocalPromotions{
            if (self.arrHomeVenueDataList[indexPath.row] as? WULocalPromotions )?.VenuePromotions.count == 0 {
                return self.view.frame.size.width / 375 * 210//240.0//130.0
            } else {
                return self.view.frame.size.width / 375 * 210//210.0
            }
        }else if self.arrHomeVenueDataList[indexPath.row] is WULiveCams {
            
            if (self.arrHomeVenueDataList[indexPath.row] as! WULiveCams).LocalLiveCams.count == 0 {
                return 280.0//140.0
            }else if (self.arrHomeVenueDataList[indexPath.row] as! WULiveCams).LocalLiveCams.count == 1 {
                return 275.0
            }else{
                return 446.0
            }
        }else if let category =  self.arrHomeVenueDataList[indexPath.row] as? WUCategorisedVenues,
            category.CategoryID == VenueCategoryID.ArtsEntertainment.rawValue {
            if (self.arrHomeVenueDataList[indexPath.row] as! WUCategorisedVenues).Venues.count == 0 {
                return 280.0//140.0 // Arts & entnt
            }else if (self.arrHomeVenueDataList[indexPath.row] as! WUCategorisedVenues).Venues.count == 1 {
                return 275.0
            }else{
                return 446.0
            }
        }else if let category =  self.arrHomeVenueDataList[indexPath.row] as? WUCategorisedVenues,
            category.CategoryID == VenueCategoryID.Other.rawValue {
            if (self.arrHomeVenueDataList[indexPath.row] as! WUCategorisedVenues).Venues.count == 0{
                return 280.0//140.0
            }else if (self.arrHomeVenueDataList[indexPath.row] as! WUCategorisedVenues).Venues.count == 1{
                return 275.0
            }else{
                return 446.0
            }
        }else if let category =  self.arrHomeVenueDataList[indexPath.row] as? WUCategorisedVenues,
            category.CategoryID == VenueCategoryID.Event.rawValue {
            if (self.arrHomeVenueDataList[indexPath.row] as! WUCategorisedVenues).Events.count == 0{
                return 275.0//130.0
            }else{
                return 275.0
            }
        }else if (self.arrHomeVenueDataList[indexPath.row] as? WUCategorisedVenues )?.Venues.count == 0 {
            return 275.0//130.0 // ALL
        }else {
            return 275.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.arrHomeVenueDataList[indexPath.row] is WULiveCams  {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUHomeViewAndCollectionTableCell()), for: indexPath)as! WUHomeViewAndCollectionTableCell
            cell.delegate = self
            cell.viewSeparator.isHidden = false
            cell.liveCames = self.arrHomeVenueDataList[indexPath.row] as? WULiveCams
            if indexPath.row == self.arrHomeVenueDataList.count - 1 {
                if self.tableViewHome.contentSize.height > self.tableViewHome.frame.size.height{
                    cell.viewSeparator.isHidden = true
                }
            }
            return cell
            
        } else if let category =  self.arrHomeVenueDataList[indexPath.row] as? WUCategorisedVenues,
            ((category.CategoryID == VenueCategoryID.ArtsEntertainment.rawValue)
                || (category.CategoryID == VenueCategoryID.Other.rawValue)) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUHomeViewAndCollectionTableCell()), for: indexPath)as! WUHomeViewAndCollectionTableCell
            cell.delegate = self
            cell.viewSeparator.isHidden = false
            cell.artAndEntmt = self.arrHomeVenueDataList[indexPath.row] as? WUCategorisedVenues
            if indexPath.row == self.arrHomeVenueDataList.count - 1 {
                if self.tableViewHome.contentSize.height > self.tableViewHome.frame.size.height{
                    cell.viewSeparator.isHidden = true
                }
            }
            return cell
            
        } else if self.arrHomeVenueDataList[indexPath.row] is WULocalPromotions
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WULocalPromotionTableCell()), for: indexPath)as! WULocalPromotionTableCell
            cell.delegate = self
            cell.categorizedVenue = self.arrHomeVenueDataList[indexPath.row]
            cell.viewSeparator.isHidden = false
            if indexPath.row == self.arrHomeVenueDataList.count - 1 {
                if self.tableViewHome.contentSize.height > self.tableViewHome.frame.size.height{
                    cell.viewSeparator.isHidden = true
                }
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUHomeTableCell()), for: indexPath)as! WUHomeTableCell
            cell.delegate = self
            cell.categorizedVenue = self.arrHomeVenueDataList[indexPath.row] // 14
            
            print("////categorizedVenue = \(String(describing: cell.categorizedVenue))")
            cell.viewSeparator.isHidden = false
            if indexPath.row == self.arrHomeVenueDataList.count - 1 {
                if self.tableViewHome.contentSize.height > self.tableViewHome.frame.size.height{
                    cell.viewSeparator.isHidden = true
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let localCell = cell as? WULocalPromotionTableCell
        {
            Utill.printInTOConsole(printData: "WULocalPromotionTableCell willDisplay")
            localCell.updateImage()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let localCell = cell as? WULocalPromotionTableCell
        {
            Utill.printInTOConsole(printData: "WULocalPromotionTableCell didEndDisplaying")
            if localCell.arrCollectionData.count > 1{
                localCell.stopTimerForLocalPromotion()
            }
        }
    }
    //This code inside this method is for home top view animation
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableViewHome {
            if scrollView.contentOffset.y > self.viewVideo.frame.size.height{
                self.player?.pause()
            }else {
                self.player?.play()
            }
            
            if scrollView.contentOffset.y > self.viewHeader.height{
                self.view.bringSubview(toFront: self.viewBlackTopBar)
                self.view.bringSubview(toFront: self.buttonGoToTop)
                self.viewBlackTopBar.isHidden = false
                self.buttonGoToTop.isHidden = false
                self.viewBlackTopBar.alpha = 1.0
                self.buttonGoToTop.alpha = 1.0
                self.constraintTopHeaderTop.constant = 0
                if self.arrBannerListData.count > 1{
                    self.stopTimer()
                }
                //            UIView.animate(withDuration: 0.3, animations: {
                //                self.view.layoutIfNeeded()
                //            })
            }else{
                if self.arrBannerListData.count > 1{
                    self.startTimerForchangeImageAnimation()
                }
                
                UIView.animate(withDuration: 0.3, animations:{
                    self.viewBlackTopBar.alpha = 0.0
                    self.buttonGoToTop.alpha = 0.0
                }, completion: { (isBool) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        if scrollView.contentOffset.y < self.viewHeader.height{
                            self.viewBlackTopBar.isHidden = true
                            self.buttonGoToTop.isHidden = true
                            self.view.sendSubview(toBack: self.viewBlackTopBar)
                            self.view.sendSubview(toBack: self.buttonGoToTop)
                            self.constraintTopHeaderTop.constant = -self.viewBlackTopBar.height
                        }
                    })
                })
            }
        }
    }
}

//MARK: - CollectionView
extension WUHomeViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrBannerListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), for: indexPath)as! WUHomeSliderCollectionCell
            cell.venueLocalPromotion = self.arrBannerListData[indexPath.row] //>>>banner 1600pc
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if  self.arrBannerListData[indexPath.row].VenueStatusID == 1 {
            FirebaseManager.sharedInstance.ad_herobanner_GUID_ios(parameter:nil,
                                                                  homeBanner:self.arrBannerListData[indexPath.row] )
            
            if let vc : WUVenueProfileViewController = UIStoryboard.venue.get(WUVenueProfileViewController.self){
                self.verticalContentOffset  = self.tableViewHome.contentOffset.y
                vc.sponsoredVenuID = self.arrBannerListData[indexPath.row].VenueID
                vc.fourSquareVenueId = self.arrBannerListData[indexPath.row].VenueFourSquareID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            Utill.goToClaimBussinessScreenWithVenue(viewController: self, venue:self.arrBannerListData[indexPath.row] )
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
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        Utill.printInTOConsole(printData:"  collectionView didEndDisplaying")
        if collectionView == self.collectionViewImageAnimate {
            if self.arrBannerListData.count > 1 {
                self.stopTimer()
                let currentPage = self.collectionViewImageAnimate.contentOffset.x / self.collectionViewImageAnimate.frame.size.width
                self.currentVisibleIndex = Int(currentPage)
                Utill.printInTOConsole(printData:"current index : \(currentPage)")
                self.startTimerForchangeImageAnimation()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:self.collectionViewImageAnimate.frame.size.width, height: 100.0)
    }
}


//MARK: - ViewAll && Cell Did Select Delegate
extension WUHomeViewController : WUHomeTableCellDelegate {
    
    func homeTableCellViewAllButtonClicked(cell: UITableViewCell, withVenueCategory venueCategory: Any) {
        
        self.selectedCategoryVenueForViewAll = venueCategory
        if (self.selectedCategoryVenueForViewAll as? WUTopSpots) != nil
        {
            FirebaseManager.sharedInstance.viewall_topspots_ios(parameter: nil)
        }
        else if (self.selectedCategoryVenueForViewAll as? WULocalPromotions) != nil
        {
            FirebaseManager.sharedInstance.viewall_localpromo_ios(parameter: nil)
        }
        else if (self.selectedCategoryVenueForViewAll as? WUCategorisedVenues) != nil
        {
            let categoryVenue = self.selectedCategoryVenueForViewAll as! WUCategorisedVenues
            if categoryVenue.CategoryID == VenueCategoryID.ArtsEntertainment.rawValue
            {
                FirebaseManager.sharedInstance.viewall_arts_ios(parameter: nil)
            }
            else if categoryVenue.CategoryID == VenueCategoryID.Food.rawValue
            {
                FirebaseManager.sharedInstance.viewall_restaurant_ios(parameter: nil)
            }
            else if categoryVenue.CategoryID == VenueCategoryID.Nightlife.rawValue
            {
                FirebaseManager.sharedInstance.viewall_barpub_ios(parameter: nil)
            }
            else if categoryVenue.CategoryID == VenueCategoryID.Outdoors.rawValue
            {
                FirebaseManager.sharedInstance.viewall_outdoor_ios(parameter: nil)
            }
            else if categoryVenue.CategoryID == VenueCategoryID.Shop.rawValue
            {
                FirebaseManager.sharedInstance.viewall_shop_ios(parameter: nil)
            }
            else if categoryVenue.CategoryID == VenueCategoryID.Music.rawValue
            {
                //                FirebaseManager.sharedInstance.viewall_mu
            }
            else if categoryVenue.CategoryID == VenueCategoryID.Cafes.rawValue
            {
                FirebaseManager.sharedInstance.viewall_cafes_ios(parameter: nil)
            }
        }
        if ((self.selectedCategoryVenueForViewAll as? WULiveCams) != nil) {
            Utill.printInTOConsole(printData:"LiveCam")
            FirebaseManager.sharedInstance.viewall_livecam_ios(parameter: nil)
            (self.tabBarController as! WUTabbarViewController).selectIndexForTabbar(selectedIndex: .LiveCam)
        }else {
            self.performSegue(withIdentifier: Text.Segue.homeViewAll , sender: nil)
        }
    }
    
    func homeTableCell(homeTableCell: UITableViewCell, didSelectCellForVenue venue: Any) {
        self.selectedVenueForDetail = venue
        
        if self.selectedVenueForDetail is WUVenueLiveCams {
            self.verticalContentOffset  = self.tableViewHome.contentOffset.y
            Utill.goToLivecamProfile(viewController: self, withLivecamM: (self.selectedVenueForDetail as! WUVenueLiveCams))
        }else if (self.selectedVenueForDetail as? WUEventDetail) != nil {
            self.verticalContentOffset  = self.tableViewHome.contentOffset.y
            if let vc : WUEventProfileViewController = UIStoryboard.events.get(WUEventProfileViewController.self){
                vc.selectedEventId = ((self.selectedVenueForDetail as? WUEventDetail)?.ID)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            if self.selectedVenueForDetail is WUVenueLocalPromotions {
                if  (self.selectedVenueForDetail as! WUVenueLocalPromotions).VenueStatusID == 1 { //IsSponseredVenues == true
                    self.performSegue(withIdentifier: Text.Segue.homeToVenueDetail , sender: nil)
                }else {
                    self.verticalContentOffset  = self.tableViewHome.contentOffset.y
                    Utill.goToClaimBussinessScreenWithVenue(viewController: self, venue:self.selectedVenueForDetail as! WUVenueLocalPromotions)
                }
            }else {
                if self.selectedVenueForDetail is WUVenue{
                    if (self.selectedVenueForDetail as! WUVenue).VenueStatusID == 1 {
                        self.performSegue(withIdentifier: Text.Segue.homeToVenueDetail , sender: nil)
                    }else{
                        self.verticalContentOffset  = self.tableViewHome.contentOffset.y
                        Utill.goToClaimBussinessScreenWithVenue(viewController: self, venue:self.selectedVenueForDetail as! WUVenue)
                    }
                }
            }
        }
    }
    
    func homeTableCellLiveCamButtonClicked(cell: UITableViewCell, withVenueCategory venueCategory: Any) {
        if venueCategory is WUVenueLiveCams{
            self.verticalContentOffset  = self.tableViewHome.contentOffset.y
            Utill.goToLivecamProfile(viewController: self, withLivecamM: (venueCategory as! WUVenueLiveCams))
        }
        if venueCategory is WUVenue{
            Utill.goToLivecamProfile(viewController: self, withLivecamM:  (venueCategory as! WUVenue).LiveCamsURLs[0])
        }
        if venueCategory is WUEventDetail {
            Utill.goToLivecamProfile(viewController: self, withLivecamM:  (venueCategory as! WUEventDetail).LiveCamsURL[0])
        }
    }
    
    func goToClaimBussinessScreenWithVenue(_ venue : WUVenue) {
        self.verticalContentOffset  = self.tableViewHome.contentOffset.y
        if let vc = UIStoryboard.home.get(WUClaimABusinessPromptViewController.self){
            vc.venue = venue
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getPlaceholdersByKey(_ key : String) -> WUPlaceholder {
        return self.placeholdersDictionary[key]!
    }

}
//MARK: -  WUVenueProfileViewControllerDelegate
extension WUHomeViewController : WUVenueProfileViewControllerDelegate {
    func venueProfileUpdateRating_Favorite(venueProfile obj: WUVenueDetail) {
        
        if self.arrHomeVenueDataList.count > 0 {
            if self.homeVenueAllData.TopVenues.Venues.count > 0 {
                
                let sectionTemp = self.arrHomeVenueDataList.index(where: {$0 as? WUTopSpots === self.homeVenueAllData.TopVenues})
                
                if (sectionTemp! < self.arrHomeVenueDataList.count) {
                    if let cell = self.tableViewHome.cellForRow(at: IndexPath(row: sectionTemp!, section: 0)) as? WUHomeTableCell{
                        let arrTopVenueRating = self.homeVenueAllData.TopVenues.Venues.filter({$0.FourSquareVenueID == obj.FourSquareVenueID})
                        if arrTopVenueRating.count > 0 {
                            arrTopVenueRating.first?.VenueRating = obj.VenueRating
                            let index = self.homeVenueAllData.TopVenues.Venues.index(of: arrTopVenueRating.first!)
                            cell.collectionView.reloadItems(at:[IndexPath(row: index!, section: 0)])
                        }
                    }
                }
            }
            
            if self.homeVenueAllData.CategorisedVenues.count > 0 {
                let arrOfCategorisedRating = self.homeVenueAllData.CategorisedVenues.filter({$0.Venues.filter({$0.FourSquareVenueID == obj.FourSquareVenueID}).count > 0}) //like food ,shop etc
                if arrOfCategorisedRating.count > 0 {
                    let sectionTemp = self.arrHomeVenueDataList.index(where:{$0 as? WUCategorisedVenues == arrOfCategorisedRating.first!}) // get particular index of shop ,food etc
                    if (sectionTemp! < self.arrHomeVenueDataList.count) {
                        if let cell = self.tableViewHome.cellForRow(at: IndexPath(row: sectionTemp!, section: 0)) as? WUHomeTableCell{ //get cell
                            if arrOfCategorisedRating.count > 0 {
                                let arrCategorisedVenueRating = arrOfCategorisedRating.first?.Venues.filter({$0.FourSquareVenueID == obj.FourSquareVenueID}) // get shop's ,food's venuelist 
                                arrCategorisedVenueRating?.first?.VenueRating = obj.VenueRating
                                let index = arrOfCategorisedRating.first?.Venues.index(of:(arrCategorisedVenueRating?.first)!)
                                cell.collectionView.reloadItems(at:[IndexPath(row: index!, section: 0)])
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - WUHomeViewAllViewControllerDelegate
extension WUHomeViewController : WUHomeViewAllViewControllerDelegate {
    
    func HomeVenueUpdateRating(category obj: Any!) {
        
        if obj is WUTopSpots {
            let sectionTemp = self.arrHomeVenueDataList.index(where: {$0 as? WUTopSpots === obj as? WUTopSpots})
            if (sectionTemp! < self.arrHomeVenueDataList.count) {
                if let cell = self.tableViewHome.cellForRow(at: IndexPath(row: sectionTemp!, section: 0)) as? WUHomeTableCell{
                    self.arrHomeVenueDataList.remove(at: sectionTemp!)
                    self.arrHomeVenueDataList.insert(obj as! WUTopSpots, at: sectionTemp!)
                    cell.collectionView.reloadData()
                }
            }
        }
        
        if obj is WUCategorisedVenues {
            let sectionTemp = self.arrHomeVenueDataList.index(where: {$0 as? WUCategorisedVenues === obj as? WUCategorisedVenues})
            if (sectionTemp! < self.arrHomeVenueDataList.count) {
                if let cell = self.tableViewHome.cellForRow(at: IndexPath(row: sectionTemp!, section: 0)) as? WUHomeTableCell{
                    self.arrHomeVenueDataList.remove(at: sectionTemp!)
                    self.arrHomeVenueDataList.insert(obj as! WUCategorisedVenues, at: sectionTemp!)
                    cell.collectionView.reloadData()
                }
            }
        }
    }
}

//MARK: - WUHomeSearchDelegate 
extension WUHomeViewController : WUHomeSearchDelegate {
    func updateHomeBasedOnRationgChanges() {
       // self.callWS_getHomeVenueList()
      //  callGooglePlaceAPI()
    }
}

//MARK: - IBDesignable class
@IBDesignable class HeaderTopContainerView : UIView{
    @IBInspectable
    var height: CGFloat = 90.0 {
        didSet{
            self.frame.size.height = self.height
        }
    }
}

@IBDesignable class HeaderContainerView : UIView{
    @IBInspectable
    var height: CGFloat = 500.0    {
        didSet{
            self.frame.size.height = self.frame.size.width / 375 * 480//self.height
        }
    }
}

extension Array {
    init(repeating: [Element], count: Int) {
        self.init([[Element]](repeating: repeating, count: count).flatMap{$0})
    }
    
    func repeated(count: Int) -> [Element] {
        return [Element](repeating: self, count: count)
    }
    
    //    func shuffled() -> [Element] {
    //        return (self as NSArray).shuffled() as! [Element]
    //    }
}


