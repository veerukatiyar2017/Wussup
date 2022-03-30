//
//  WULiveCamProfileViewController.swift
//  Wussup
//
//  Created by MAC105 on 17/07/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class WULiveCamProfileViewController: UIViewController,UIViewControllerTransitioningDelegate {
    let viewheaderHeightForNoDescriptionWithBanner = CGFloat(590.0).propotionalHeight
    let viewheaderHeightForNoDescriptionWithNoBanner = CGFloat(490.0).propotionalHeight
    let viewheaderHeightForDescription = 207.0.propotional + 100 + 118 + 81
    
    // MARK: - IBOutlets
    @IBOutlet private weak var labelNavigationTitle             : UILabel!
    @IBOutlet private weak var imageBG                          : UIImageView!
    @IBOutlet private weak var tableViewLiveCamProfile          : UITableView!
    @IBOutlet private weak var tableHeaderView                  : UIView!
    @IBOutlet private weak var viewVideoPlayer                  : UIView!
    @IBOutlet private weak var collectionAds                    : UICollectionView!
    @IBOutlet private weak var viewLabels                       : UIView!
    @IBOutlet private weak var liveCamSubTitle                  : UILabel!
    @IBOutlet private weak var labelLiveCamTitle                : UILabel!
    @IBOutlet private weak var buttonYellowLiveCam              : UIButton!
    @IBOutlet private weak var cnstCollectionViewHeight         : NSLayoutConstraint!
    @IBOutlet private weak var viewNoDescription                : UIView!
    @IBOutlet private weak var viewDescription                  : UIView!
    @IBOutlet private weak var labelDescription                 : UILabel!
    @IBOutlet private weak var buttonReadMore                   : UIButton!
    @IBOutlet private weak var labelNoDescription               : UILabel!
    @IBOutlet private weak var buttonShare                      : UIButton!
    
    @IBOutlet private weak var imageBigFish                     : UIImageView!
    @IBOutlet private weak var imageViewRound                   : UIImageView!
    @IBOutlet private weak var viewSep2                         : UIView!
    @IBOutlet private weak var viewSep1                         : UIView!
    @IBOutlet private weak var viewButtons                      : UIView!
    @IBOutlet private weak var viewBlack                        : UIView!
    @IBOutlet private weak var wussupIcon                       : UIImageView!
    @IBOutlet private weak var labelNoResultFound               : UILabel!
    
    
    var player                      : AVPlayer!
    var  liveCamVenue               : WUVenueLiveCams!
    private var currentVisibleImageIndex = 0
    private var timerAnimation      :Timer?
    var playerController    : AVPlayerViewController    = AVPlayerViewController()
    var arrayBannerList             : [WUHomeBannerList]        = []
    var isFullScreen                : Bool                      = false
    var lableFinalHeight            : CGFloat                   = 0.0
    let playerFrame                 : CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 207.0.propotional)
    var liveCamID = "0"
    var isPopToBack : Bool = false
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialDataSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.arrayBannerList.count > 0 {
            self.startTimerForchangeImageAnimation()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        if self.arrayBannerList.count > 0 {
            self.stopTimer()
        }
        
        if self.player != nil {
            self.player.pause()
        }
        if isPopToBack == true {
            if self.player != nil {
                self.player.pause()
                self.playerController.removeObserver(self, forKeyPath: "videoBounds")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        lableFinalHeight = UIScreen.main.bounds.size.height - 77 - viewheaderHeightForDescription
        self.buttonShare.isSelected = false
        //        self.initialDataSetup()
        
        self.viewDescription.backgroundColor    = .white
        self.viewButtons.backgroundColor        = .white
        self.buttonShare.isHidden               = false
        self.buttonYellowLiveCam.isHidden       = false
        self.viewSep1.isHidden                  = false
        self.viewSep2.isHidden                  = false
        self.buttonReadMore.isHidden            = false
        self.viewBlack.isHidden                 = false
        self.imageBigFish.isHidden              = false
        self.imageViewRound.isHidden            = false
        self.viewNoDescription.isHidden         = false
        self.viewBlack.backgroundColor          = .black
        self.wussupIcon.isHidden                = false
        
        if self.liveCamVenue.Description.count > 0 {
            self.manageViewDescription(isShow: true)
        }else {
            self.manageViewDescription(isShow: false)
        }
        self.loadURLTOPlayer()
        
        self.tableViewLiveCamProfile.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.tableViewLiveCamProfile.frame.width, height: self.tableHeaderView.frame.size.height)
        self.collectionAds.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()))
        self.tableViewLiveCamProfile.reloadData()
        self.collectionAds.reloadData()
        if self.arrayBannerList.count > 0 {
            self.startTimerForchangeImageAnimation()
        }
    }
    
    private func initialDataSetup() {
        if self.liveCamVenue == nil {
            self.callWS_GetLiveCamDetail()
        }else {
            self.initialInterfaceSetUp()
        }
        
    }
    
    // MARK: - Webservice calls
    func callWS_GetLiveCamDetail(){
        WEB_API.call_api_GetLiveCamDetail(strLiveCamID: self.liveCamID) { (response, success, message) in
            Utill.printInTOConsole(printData:"response: \(response ?? "")")
            
            self.viewDescription.backgroundColor    = .clear
            self.viewButtons.backgroundColor        = .clear
            self.buttonShare.isHidden               = true
            self.buttonReadMore.isHidden            = true
            self.buttonYellowLiveCam.isHidden       = true
            self.viewSep1.isHidden                  = true
            self.viewSep2.isHidden                  = true
            self.imageBigFish.isHidden              = true
            self.imageViewRound.isHidden            = true
            self.viewBlack.isHidden                 = true
            self.viewBlack.backgroundColor          = .clear
            self.wussupIcon.isHidden                = true
            self.labelDescription.text              = ""
            self.labelNavigationTitle.text          = "LIVE CAM"
            self.labelLiveCamTitle.text             = ""
            self.viewNoDescription.isHidden         = true
            self.tableViewLiveCamProfile.isHidden   = false
            
            if success == true{
                
                let bannerListData = try! JSONSerialization.data(withJSONObject: response?["BannerList"].arrayObject ?? [], options: [])
                self.arrayBannerList = try! JSONDecoder().decode([WUHomeBannerList].self, from: bannerListData)
                Utill.saveHomeBannerModel(self.arrayBannerList)
                
                let data = try! JSONSerialization.data(withJSONObject: response?["LiveCamsURL"].dictionaryObject ?? [:], options: [])
                self.liveCamVenue = try! JSONDecoder().decode(WUVenueLiveCams.self, from: data)
                
                self.initialInterfaceSetUp()
                
            }else{
                self.tableViewLiveCamProfile.isHidden = true
                
                Utill.showAlert_OK_ViewForTabManage(viewController: self, message: message, completion: { (sucess) in
                    if sucess {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
                
            }
        }
    }
    
    private func manageViewDescription(isShow : Bool){
        self.liveCamID = self.liveCamVenue.ID
        
        if isShow == true{
            self.imageBG.isHidden               = true
            self.labelNavigationTitle.text      = "LIVE CAM"
            self.labelLiveCamTitle.text         = self.liveCamVenue.Name
            self.viewLabels.backgroundColor     = UIColor.LiveCamYellowColor
            self.viewNoDescription.isHidden     = true
            self.viewDescription.isHidden       = false
            self.buttonReadMore.isHidden        = false
            self.labelDescription.isHidden      = false
            self.labelDescription.text          = self.liveCamVenue.Description
            
            if self.arrayBannerList.count == 0 {
                self.cnstCollectionViewHeight.constant = 0
            }else {
                self.cnstCollectionViewHeight.constant = 100
            }
            self.tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableViewLiveCamProfile.frame.size.width, height: viewheaderHeightForDescription) //490.0
            self.tableViewLiveCamProfile.reloadData()
            self.manageReadMoreFunctionality()
        }else{
            
            self.imageBG.isHidden               = false
            self.labelNavigationTitle.text      = self.liveCamVenue.Name
            self.viewNoDescription.isHidden     = false
            self.viewDescription.isHidden       = true
            self.buttonReadMore.isHidden        = true
            self.labelDescription.isHidden      = true
            self.labelNoDescription.text        = "Live Cam Info Coming Soon!"
            
            if self.arrayBannerList.count == 0 {
                self.cnstCollectionViewHeight.constant = 0
                self.tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableViewLiveCamProfile.frame.size.width, height: viewheaderHeightForNoDescriptionWithNoBanner) //390.0
            }else {
                self.cnstCollectionViewHeight.constant = 100
                self.tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableViewLiveCamProfile.frame.size.width, height: viewheaderHeightForNoDescriptionWithBanner) //490.0
            }
        }
    }
    
    private func manageReadMoreFunctionality(){
        let textsize = Utill.findHeightForText(text: self.labelDescription.text!, havingWidth:  self.labelDescription.frame.size.width, andFont:self.labelDescription.font)
        if self.liveCamVenue.Description == ""  {
            self.buttonReadMore.isHidden = true
        }else if textsize <= lableFinalHeight{
            var headerHeight = self.tableHeaderView.frame.size.height
            headerHeight += textsize
            self.buttonReadMore.isHidden = true
            self.tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableViewLiveCamProfile.frame.size.width, height: headerHeight) //490.0
        }else{
            self.buttonReadMore.isHidden = false
            var headerHeight = self.tableHeaderView.frame.size.height
            headerHeight += lableFinalHeight
            self.tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableViewLiveCamProfile.frame.size.width, height: headerHeight) //490.0
        }
    }
    
    private func loadURLTOPlayer(){
        if let urlVideo = URL(string: self.liveCamVenue.LiveCamURL) {
            let avplayerItem = AVPlayerItem(url: urlVideo)
            self.player = AVPlayer(playerItem: avplayerItem)
            self.player?.rate = 1.0;
            self.player?.isMuted = true
            self.playerController.player                        = self.player
            self.playerController.view.isUserInteractionEnabled = true
            self.playerController.view.frame                    = self.viewVideoPlayer.bounds
            self.playerController.updatesNowPlayingInfoCenter   = false
            self.playerController.videoGravity                  = AVLayerVideoGravity.resizeAspectFill.rawValue
            //            self.playerController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            if #available(iOS 11.0, *) {
                self.playerController.entersFullScreenWhenPlaybackBegins = true
            } else {
                // Fallback on earlier versions
            }
            self.viewVideoPlayer.addSubview(self.playerController.view)
            self.player?.play()
            
            self.playerController.addObserver(self, forKeyPath: "videoBounds", options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old ], context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "videoBounds"
        {
            if let rect = change?[.newKey] as? NSValue
            {
                if let newrect = rect.cgRectValue as CGRect?
                {
                    let isFullscreenAV: Bool = newrect.equalTo(UIScreen.main.bounds)
                    
                    if let oldBounds = change?[.oldKey] as? NSValue {
                        
                        if let oldrect = oldBounds.cgRectValue as CGRect? {
                            
                            let wasFullscreen: Bool = oldrect.equalTo(UIScreen.main.bounds)
                            
                            if isFullscreenAV == false  && wasFullscreen == false && newrect.origin.x == 0 && newrect.origin.y == 0{
                                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                                if self.arrayBannerList.count > 0 {
                                    self.startTimerForchangeImageAnimation()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func deviceRotated(){
        if UIDevice.current.orientation == .landscapeLeft ||  UIDevice.current.orientation == .landscapeRight{
            Utill.printInTOConsole(printData:"landscapeLeft")
            self.isFullScreen = true
            self.enterFullscreen(playerViewController: self.playerController)
        }
        else if UIDevice.current.orientation == .portraitUpsideDown ||  UIDevice.current.orientation == .portrait{
            Utill.printInTOConsole(printData:"portrait")
            self.isFullScreen = false
            self.exitFullscreen(playerViewController: self.playerController)
        }
    }
    
    // MARK: - Action Methods
    @IBAction func buttonBackAction(_ sender: Any) {
//        if self.player != nil {
//            self.player.pause()
//            self.playerController.removeObserver(self, forKeyPath: "videoBounds")
//        }
        self.isPopToBack = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonReadMoreAction(_ sender: UIButton) {
        if sender.isSelected == false{
            sender.isSelected = true
            var headerHeight = self.tableHeaderView.frame.size.height
            headerHeight -= self.labelDescription.frame.size.height
            let textsize = Utill.findHeightForText(text:  self.labelDescription.text!, havingWidth:  self.labelDescription.frame.size.width, andFont:self.labelDescription.font)
            headerHeight += textsize
            self.tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableViewLiveCamProfile.frame.size.width, height: headerHeight) //490.0
        }else {
            sender.isSelected = false
            var headerHeight = viewheaderHeightForDescription
            headerHeight += lableFinalHeight
            self.tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableViewLiveCamProfile.frame.size.width, height: headerHeight) //490.0
        }
        self.tableViewLiveCamProfile.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.tableViewLiveCamProfile.frame.width, height: self.tableHeaderView.frame.size.height)
        self.tableViewLiveCamProfile.reloadData()
    }
    
    @IBAction func buttonYellowLiveCamAction(_ sender: Any) {
        
    }
    
    @IBAction func buttonShareAction(_ sender: Any) {
        print("Share Button")
        self.buttonShare.isSelected = true
        WEB_API.call_api_GetShareLinkForVenueOrEvent(strVenueID: "",strFourSquareVenueID : "", strEventID: "", strLiveCamID: self.liveCamID) { (response, success, message) in
            if success == true{
                let dicShare = response?.dictionary!
                let shareText = dicShare!["ShareMessage"]?.string!
                //let shareLink = dicShare!["ShareLink"]?.string!
                let shareLink = "https://apps.arvzapp.com/livecam/\(self.liveCamID)"

                let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: shareText ?? Text.Message.msg_Deeplinking_Share) as Any,WUShareActivityItemProvider(placeholderItem: shareLink ?? "https://apps.arvzapp.com/") as Any,WUShareActivityItemProvider(placeholderItem:"LiveCam Name : \(self.liveCamVenue.Name)") as Any]
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
                activityViewController.excludedActivityTypes = [.addToReadingList ,.saveToCameraRoll , .copyToPasteboard , .addToReadingList ,.assignToContact ,.print , activityTypeCloud, .airDrop]
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
                
                activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                    self.buttonShare.isSelected = false
                    if completed == true{
                        Utill.showAlertView(viewController: self, message: Text.Message.venueShareMsg)
                    }
                }
            }
        }
    }
    
    // MARK: - For Manage Player
    private func exitFullscreen(playerViewController:AVPlayerViewController) {
        let selectorName: String = {
            return "exitFullScreenAnimated:completionHandler:"
        }()
        let selectorToForceFullScreenMode = NSSelectorFromString(selectorName)
        if self.playerController.responds(to: selectorToForceFullScreenMode) {
            self.playerController.perform(selectorToForceFullScreenMode, with: true, with: nil)
        }
    }
    
    private func enterFullscreen(playerViewController:AVPlayerViewController) {
        
        let selectorName: String = {
            if #available(iOS 11.3, *) {
                return "_transitionToFullScreenAnimated:interactive:completionHandler:"
            } else if #available(iOS 11, *) {
                return "_transitionToFullScreenAnimated:completionHandler:"
            } else {
                return "_transitionToFullScreenViewControllerAnimated:completionHandler:"
            }
        }()
        let selectorToForceFullScreenMode = NSSelectorFromString(selectorName)
        if self.playerController.responds(to: selectorToForceFullScreenMode) {
            
            self.playerController.perform(selectorToForceFullScreenMode, with: true, with: nil)
        }
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
        if self.arrayBannerList.count > 0{
            self.currentVisibleImageIndex = self.currentVisibleImageIndex + 1
            if self.currentVisibleImageIndex >= self.arrayBannerList.count {
                self.currentVisibleImageIndex = 0
            }
            if self.currentVisibleImageIndex < self.arrayBannerList.count{
                DispatchQueue.main.async {
                    if self.currentVisibleImageIndex == 0{
                        self.collectionAds.scrollToItem(at:IndexPath(row: self.currentVisibleImageIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
                    }else{
                        self.collectionAds.scrollToItem(at:IndexPath(row: self.currentVisibleImageIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
                    }
                }
            }else{
                self.stopTimer()
            }
        }
    }
}

//MARK: - CollectionView
extension WULiveCamProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayBannerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), for: indexPath)as! WUHomeSliderCollectionCell
        cell.venueLocalPromotion = self.arrayBannerList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            self.stopTimer()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if  self.arrayBannerList[indexPath.row].VenueStatusID == 1{
            FirebaseManager.sharedInstance.ad_herobanner_GUID_ios(parameter:nil, homeBanner:self.arrayBannerList[indexPath.row] )
            if let vc : WUVenueProfileViewController = UIStoryboard.venue.get(WUVenueProfileViewController.self){
                vc.sponsoredVenuID = self.arrayBannerList[indexPath.row].VenueID
                vc.fourSquareVenueId = self.arrayBannerList[indexPath.row].VenueFourSquareID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            Utill.goToClaimBussinessScreenWithVenue(viewController: self, venue: self.arrayBannerList[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let currentPage = self.collectionAds.contentOffset.x / self.collectionAds.frame.size.width
        if currentPage.isNaN == false && currentPage.isInfinite == false {
            if self.arrayBannerList.count > 1 {
                self.stopTimer()
                self.currentVisibleImageIndex = Int(currentPage)
                self.startTimerForchangeImageAnimation()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:self.collectionAds.frame.size.width, height: 100.0)
    }
}
