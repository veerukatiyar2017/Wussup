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
     @IBOutlet private var viewMain: UIView!
    @IBOutlet private weak var buttonNoResults: UIButton!
    
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
    
    @IBOutlet private weak var cntImageViewClaimAPromptHeight   : NSLayoutConstraint!
    @IBOutlet private weak var cntImageViewClaimFingerHeight    : NSLayoutConstraint!
    
    // MARK: - Variables
    private var arrBannerListData   : [WUHomeBannerList] = []
    private var homeAdsData         : WUHomeAds!
    private var venueProfileDetail  : WUVenueDetail!
    var tapGesture                  = UITapGestureRecognizer()
    var venue : Any!
    private var currentVisibleIndex = 0
    private var timerAnimation :Timer?
    
    var fourSquareVenueId = ""
    var sponsoredVenuID = ""
    var isScreenFromThankYouOfCAB : Bool = false
   
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
            
        }else {
            if self.arrBannerListData.count > 1 {
                self.stopTimer()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialData() {
        
        self.collectionBanners.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()))
        
        if self.venue is WUVenueLocalPromotions{
            self.labelBusinessName.text     = (self.venue as! WUVenueLocalPromotions).VenueName
            self.fourSquareVenueId          = (self.venue as! WUVenueLocalPromotions).VenueFourSquareID
            self.sponsoredVenuID            = (self.venue as! WUVenueLocalPromotions).VenueID
        }else if self.venue is WUVenueDetail{
            self.labelBusinessName.text     = (self.venue as! WUVenueDetail).VenueName
            self.fourSquareVenueId          = (self.venue as! WUVenueDetail).FourSquareVenueID
            self.sponsoredVenuID            = (self.venue as! WUVenueDetail).SponsoredVenuID
        }else if self.venue is WUVenue{
            self.labelBusinessName.text     = (self.venue as! WUVenue).VenueName
            self.fourSquareVenueId          = (self.venue as! WUVenue).FourSquareVenueID
            self.sponsoredVenuID            = (self.venue as! WUVenue).SponsoredVenuID
        }else if self.venue is WUHomeBannerList{
            self.labelBusinessName.text     = (self.venue as! WUHomeBannerList).Title
            self.fourSquareVenueId          = (self.venue as! WUHomeBannerList).VenueFourSquareID
            self.sponsoredVenuID            = (self.venue as! WUHomeBannerList).VenueID
        }
        
        self.callWS_getVenueProfileDetail()
        if self.isScreenFromThankYouOfCAB == false{
            if GlobalShared.homeBanner.count == 0 {
                self.callWS_getHomeAds()
            }else {
                if UIScreen.main.bounds.size.height >= CGFloat(IPHONE6_HEIGHT) {
                    self.manageTabelViewHeaderViewHeight(isBannerHide: false)
                }
                self.arrBannerListData = GlobalShared.homeBanner
                self.collectionBanners.reloadData()
            }
        }
        
        self.buttonNoResults.setTitle(Text.Message.noDataFound, for: .normal)
        self.tableViewClaimABusinessDetail.reloadData()
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelAddClaimABusinessAction(_:)))
        self.tapGesture.numberOfTapsRequired = 1
        self.labelAddClaimBusiness.isUserInteractionEnabled = true
        self.labelAddClaimBusiness.addGestureRecognizer(self.tapGesture)
    }
    
    // MARK: - Action Methods

    @IBAction func buttonBackAction(_ sender: Any) {
        if self.isScreenFromThankYouOfCAB == true {
            self.manageBackButtonFlow()
        }else {
            self.view.endEditing(true)
            self.buttonBack.isSelected = true
            self.buttonBack.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Back, color: .GreenColor ), for: .selected)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func labelAddClaimABusinessAction(_ sender : UITapGestureRecognizer) {
        if let vc = UIStoryboard.home.get(WUClaimABusinessViewController.self){
            vc.claimVenue = self.venue
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func buttonVideoAction(_ sender: Any) {
        Utill.goToLivecamProfile(viewController: self, withLivecamM: self.venueProfileDetail.LiveCams.LocalLiveCams[0])
    }
    
    @IBAction func buttonCallAction(_ sender: Any) {
        
        if self.venueProfileDetail.VenuePhone.count == 0 {
            guard let url = URL(string: "tel://\(0123456789)"), UIApplication.shared.canOpenURL(url) else {
                Utill.showAlertViewOnWindow(message:Text.Message.msg_Call)
                return
            }
        }else {
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
    
    private func manageTabelViewHeaderViewHeight(isBannerHide : Bool){
        if isBannerHide == true{
            self.cnstCollectionViewHeight.constant = 0.0
            self.tableViewClaimABusinessDetail.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.tableViewClaimABusinessDetail.frame.width, height: 210.0)
            self.tableViewClaimABusinessDetail.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.tableViewClaimABusinessDetail.frame.width, height: (UIScreen.main.bounds.size.height - 287))
        }else {
            self.cnstCollectionViewHeight.constant = 100.0
            self.tableViewClaimABusinessDetail.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.tableViewClaimABusinessDetail.frame.width, height: 310.0)
            self.tableViewClaimABusinessDetail.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.tableViewClaimABusinessDetail.frame.width, height: (UIScreen.main.bounds.size.height - 387))
        }
        
    }
    
    private func prepareVenueViewOfDetail(){
        self.labelNavigationTitle.text = self.venueProfileDetail.VenueName
        self.labelTitle.text = self.venueProfileDetail.VenueName
        self.labelTitleAddress.text = self.venueProfileDetail.VenueFullAddress
        
        if self.venueProfileDetail.LiveCams.LocalLiveCams.count > 0 {
            self.buttonVideo.isHidden = false
        }
        
//        self.imageViewOfSearchResult.sd_setShowActivityIndicatorView(true)
//        self.imageViewOfSearchResult.sd_setIndicatorStyle(.white)
        self.imageViewOfSearchResult.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.imageViewOfSearchResult.sd_setImage(with: URL(string:self.venueProfileDetail.VenueCoverPhoto.SquareImage),
                                                 placeholderImage:#imageLiteral(resourceName: "NullState_VenuePhoto"),
                                                 options: .refreshCached)
        
        self.buttonDistance.setTitle(NSString(format: "%0.2f Mi", Float(self.venueProfileDetail.VenueDistance) ?? 0) as String, for:.normal)
        self.buttonDistance.backgroundColor = UIColor.buttonDistanceColor
        
        var strUrl = Utill.getMapUrl(pinImageUrl: self.venueProfileDetail.MapPinImageUrl, latitute: self.venueProfileDetail.VenueLattitude, longtitude: self.venueProfileDetail.VenueLongitude)
        
        if URL(string: strUrl) == nil {
            strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
//        self.imageViewMap.sd_setShowActivityIndicatorView(true)
//        self.imageViewMap.sd_setIndicatorStyle(.white)
        self.imageViewOfSearchResult.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.imageViewMap.sd_setImage(with: URL(string: strUrl), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: .refreshCached)
    }
    
    private func manageFlowFromThankYouScreen (){
        if self.isScreenFromThankYouOfCAB == true {
            self.viewMain.backgroundColor = UIColor.mainViewBackGroundColor
            self.cntImageViewClaimFingerHeight.constant = 0.0
            self.cntImageViewClaimAPromptHeight.constant = 0.0
            
            self.imageViewClaimAPrompt.isHidden     = true
            self.labelCaptionSays.isHidden          = true
            self.labelBusinessName.isHidden         = true
            self.labelNotBeenClaimed.isHidden       = true
            self.labelClickHere.isHidden            = true
            self.labelAddClaimBusiness.isHidden     = true
            self.imageViewClaimFinger.isHidden      = true
            
            self.tableViewClaimABusinessDetail.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.tableViewClaimABusinessDetail.frame.width, height: 0)
            self.callWS_getVenueProfileDetail()
            self.tableViewClaimABusinessDetail.reloadData()
        }else {
            self.viewMain.backgroundColor = UIColor.CABBGColor
            
            self.imageViewClaimAPrompt.isHidden     = false
            self.labelCaptionSays.isHidden          = false
            self.labelBusinessName.isHidden         = false
            self.labelNotBeenClaimed.isHidden       = false
            self.labelClickHere.isHidden            = false
            self.labelAddClaimBusiness.isHidden     = false
            self.imageViewClaimFinger.isHidden      = false
            
            if self.arrBannerListData.count > 1 {
                self.startTimerForchangeImageAnimation()
            }
        }
    }
    
    
    // MARK: - Webservice calls
    func callWS_getHomeAds() {
        WEB_API.call_api_GetHomeAds(withCompletionHandler: { (response,status,message) in
            if status == true{
                let data = try! JSONSerialization.data(withJSONObject: (response!).dictionaryObject ?? [:], options: [])
                self.homeAdsData = try! JSONDecoder().decode(WUHomeAds.self, from: data)
                Utill.saveHomeBannerModel(self.homeAdsData.BannerList)
                if UIScreen.main.bounds.size.height >= CGFloat(IPHONE6_HEIGHT) {
                    self.manageTabelViewHeaderViewHeight(isBannerHide: true)
                }
                if self.homeAdsData.BannerList.count > 0{
                    if UIScreen.main.bounds.size.height >= CGFloat(IPHONE6_HEIGHT) {
                        self.manageTabelViewHeaderViewHeight(isBannerHide: false)
                    }
                    if self.homeAdsData.BannerList.count > 1 {
                        self.arrBannerListData = self.homeAdsData.BannerList.repeated(count: sliderRepeatCount)
                        self.collectionBanners.reloadData()
                        self.startTimerForchangeImageAnimation()
                    }else {
                        self.arrBannerListData = self.homeAdsData.BannerList
                        self.collectionBanners.reloadData()
                    }
                }
            }
        })
    }
    
    private func callWS_getVenueProfileDetail(){
        
        self.buttonVideo.isHidden = true
        WEB_API.call_api_GetVenueProfileDetail(user: GlobalShared.user, fourSquareVenueId: self.fourSquareVenueId, sponsoredVenuID: self.sponsoredVenuID) { (response, success, message) in
            Utill.printInTOConsole(printData:"response \(response ?? "")")
            if success == true{
                let data = try! JSONSerialization.data(withJSONObject: response?["VenueDetail"].dictionaryObject ?? [:], options: [])
                self.venueProfileDetail = try! JSONDecoder().decode(WUVenueDetail.self, from: data)
                self.prepareVenueViewOfDetail()
            }else{
                if self.isScreenFromThankYouOfCAB == true {
                    self.tableViewClaimABusinessDetail.isHidden = true
                    self.buttonNoResults.isHidden = false
                }else{
                    self.tableViewClaimABusinessDetail.isHidden = false
                    self.buttonNoResults.isHidden = true
                }
                Utill.showAlertViewOnWindow(message: Text.Message.noInternet)
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
        if self.arrBannerListData.count > 0{
            self.currentVisibleIndex = self.currentVisibleIndex + 1
            if self.currentVisibleIndex >= self.arrBannerListData.count {
                self.currentVisibleIndex = 0
            }
            if self.currentVisibleIndex < self.arrBannerListData.count{
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
    
}

//MARK: - CollectionView
extension WUClaimABusinessDetailViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrBannerListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), for: indexPath)as! WUHomeSliderCollectionCell
        cell.venueLocalPromotion = self.arrBannerListData[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if  self.arrBannerListData[indexPath.row].VenueStatusID == 1{
            FirebaseManager.sharedInstance.ad_herobanner_GUID_ios(parameter:nil, homeBanner:self.arrBannerListData[indexPath.row] )
            if let vc : WUVenueProfileViewController = UIStoryboard.venue.get(WUVenueProfileViewController.self){
                vc.sponsoredVenuID = self.arrBannerListData[indexPath.row].VenueID
                vc.fourSquareVenueId = self.arrBannerListData[indexPath.row].VenueFourSquareID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
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
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        Utill.printInTOConsole(printData:"  collectionView didEndDisplaying")
        if collectionView == self.collectionBanners {
            if self.arrBannerListData.count > 1 {
                self.stopTimer()
                let currentPage = self.collectionBanners.contentOffset.x / self.collectionBanners.frame.size.width
                self.currentVisibleIndex = Int(currentPage)
                Utill.printInTOConsole(printData:"current index : \(currentPage)")
                self.startTimerForchangeImageAnimation()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:self.collectionBanners.frame.size.width, height: 100.0)
    }
}
