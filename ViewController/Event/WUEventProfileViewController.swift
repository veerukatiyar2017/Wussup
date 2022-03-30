//
//  WUEventProfileViewController.swift
//  Wussup
//
//  Created by MAC26 on 25/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage
import Social
import EventKitUI
import Photos
import FBSDKLoginKit
import FBSDKShareKit

class WUEventProfileViewController: UIViewController {
    let viewheaderHeight = CGFloat(396.0)
    let viewheaderHeightReadMore = CGFloat(426.0)
    var viewHeaderFinalHeight : CGFloat!
    
    //MARK: - IBOutlet
    @IBOutlet private weak var labelNavTitle                        : UILabel!
    @IBOutlet private weak var mainView                             : UIView!
    @IBOutlet private weak var buttonGoToTop                        : UIButton!
    @IBOutlet private weak var imageviewEventFeaturedImage          : UIImageView!
    @IBOutlet private weak var buttonVideo                          : UIButton!
    @IBOutlet private weak var labelTitle                           : UILabel!
    @IBOutlet private weak var labelDiscription                     : UILabel!
    @IBOutlet private weak var labelDate                            : UILabel!
    @IBOutlet private weak var buttonReadMore                       : UIButton!
    @IBOutlet weak var collectionViewShareOptions                   : UICollectionView!
    @IBOutlet private weak var viewHeaderContainer                  : UIView!
    @IBOutlet private weak var tableHeaderView                      : UIView!
    @IBOutlet private weak var tableViewEventProfile                : UITableView!
    @IBOutlet private weak var viewCollectionShareOptionHeight      : NSLayoutConstraint!
    @IBOutlet private weak var viewFooter                           : UIView!
    @IBOutlet private weak var buttonSearch                         : UIButton!
    @IBOutlet private weak var buttonNoResults                      : UIButton!
    @IBOutlet private weak var labelAdmissionFee                    : UILabel!
    @IBOutlet private weak var viewWithLabelNameAndAddress          : UIView!
    
    //MARK: - Variables
    var isFromSearchVC : Bool = false
    private var arrEventProfilePropertyList : [Any]! = []
    private var arrShareOptions             : [WUShareOptions] = []
    private var eventProfileDetail          : WUEventDetail!
    private var currentShareOptionIndex = 0
//    private var arrMyeventList : [WUMyEventList] =  []
    let eventdetailModel = WUMyEventListDetail()
    var navTitle = "EVENT"
    var selectedEventId = "0"
    let eventStore : EKEventStore = EKEventStore()
    var event : EKEvent?

    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let eventListModel = WUMyEventList()
        eventListModel.Name = "xyz"
        
        eventdetailModel.Name = "MY EVENT LIST"
        if let arrEvent = Utill.getEventFromCalendar() {
            eventdetailModel.eventList = arrEvent
        }
        else{
            eventdetailModel.eventList = []
        }
        self.initialInterfaceSetUp()
        self.initialDataSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.buttonSearch.isSelected = false
        self.collectionViewShareOptions.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        self.labelNavTitle.text = self.navTitle
        self.mainView.backgroundColor = .mainViewBackGroundColor
        self.tableViewEventProfile.isHidden = true
        self.buttonNoResults.setTitle(Text.Message.noDataFound, for: .normal)
        self.buttonGoToTop.isHidden = true
        self.viewHeaderContainer.dropShadow()
        
        // self.tableViewEventProfile.contentInset = UIEdgeInsetsMake(0, 0, -25, 0)
        
        self.tableViewEventProfile.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUEventDirectionTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUEventDirectionTableCell()))
        
        self.tableViewEventProfile.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUNoEventTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUNoEventTableCell()))
        
        self.tableViewEventProfile.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUMyEventExpandTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUMyEventExpandTableCell()))
        
        self.tableViewEventProfile.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUExpandableImageTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUExpandableImageTableCell()))
        
        let headerNib = UINib.init(nibName:Utill.getClassNameFor(classType: WUExpandableSectionHeaderView()), bundle: Bundle.main)
        self.tableViewEventProfile.register(headerNib, forHeaderFooterViewReuseIdentifier: Utill.getClassNameFor(classType: WUExpandableSectionHeaderView()))
        
        self.tableViewEventProfile.reloadData()
    }
    
    private func manageDescriptionLabel(){
        let textsize = Utill.findHeightForText(text:  self.labelDiscription.text!, havingWidth:  self.labelDiscription.frame.size.width, andFont:self.labelDiscription.font)
        let height = Utill.findHeightForText(text:  "Aaa  \n Azz ", havingWidth:  self.labelDiscription.frame.size.width, andFont:self.labelDiscription.font)

        if textsize <= height {
            self.buttonReadMore.isHidden = true
            if textsize == height{
                self.viewHeaderFinalHeight = self.viewheaderHeightReadMore
            }else {
                self.viewHeaderFinalHeight = self.viewheaderHeight + textsize
            }
        }else{
            self.buttonReadMore.isHidden = false
            self.viewHeaderFinalHeight = self.viewheaderHeightReadMore
            
        }
        self.reloadTableForHeaderHeight()
    }
    
    private func reloadTableForHeaderHeight(){
        self.tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableViewEventProfile.frame.size.width, height: self.viewHeaderFinalHeight)
        self.tableViewEventProfile.reloadData()
    }
    
    private func initialDataSetup() {
        self.callWS_getEventDetail(eventId: selectedEventId)
    }
    
    private func prepareArrayEventProfileProperties(){
        if self.eventProfileDetail.EventAdmissionDetail.EventAdmission.count > 0 {
            self.arrEventProfilePropertyList.append(self.eventProfileDetail.EventAdmissionDetail)
        }
        
        if self.eventProfileDetail.DirectionDetail.Latitude != "" && self.eventProfileDetail.DirectionDetail.Latitude != ""{
            self.arrEventProfilePropertyList.append(self.eventProfileDetail.DirectionDetail)
        }
        if self.eventProfileDetail.EventPhotoDetail.eventPhotos.count > 0 {
            self.arrEventProfilePropertyList.append(self.eventProfileDetail.EventPhotoDetail)
        }
        if self.eventProfileDetail.EventPromoterDetail.eventPromoter.count > 0 {
            self.arrEventProfilePropertyList.append(self.eventProfileDetail.EventPromoterDetail)
        }
        if self.eventdetailModel.eventList.count > 0 {
            self.arrEventProfilePropertyList.append(self.eventdetailModel)
        }
        
        if self.eventProfileDetail.MoreEventDetail.MoreEvents.count > 0 {
            self.arrEventProfilePropertyList.append(self.eventProfileDetail.MoreEventDetail)
        }
        self.tableViewEventProfile.reloadData()
    }
    
    private func prepareViewForEventProfileDetail(){
        self.imageviewEventFeaturedImage.sd_setShowActivityIndicatorView(true)
        self.imageviewEventFeaturedImage.sd_setIndicatorStyle(.white)
        self.imageviewEventFeaturedImage.sd_setImage(with: URL(string: self.eventProfileDetail.ConverPhotoURL), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
        
        self.labelTitle.text = self.eventProfileDetail.Name
        self.labelDiscription.text = self.eventProfileDetail.Description
        self.manageDescriptionLabel()
        
        self.buttonVideo.isHidden = true
        if self.eventProfileDetail.LiveCamsURL.count > 0 {
            self.buttonVideo.isHidden = false
        }
        self.viewWithLabelNameAndAddress.backgroundColor = UIColor.LiveCamYellowColor
        
        
        self.eventProfileDetail.StartDate = self.eventProfileDetail.StartDate.replacingOccurrences(of: " 0", with: " ")
        self.eventProfileDetail.EndDate = self.eventProfileDetail.EndDate.replacingOccurrences(of: " 0", with: " ")
        
        self.labelDate.text = Date.getCombinedDateForDayAbdRemoveZero(startDate: self.eventProfileDetail.StartDate,
                                                                      endDate: self.eventProfileDetail.EndDate)
        
        self.labelAdmissionFee.text = self.eventProfileDetail.PriceRating == "" ? "FREE" : self.eventProfileDetail.PriceRating
        self.createShareOptionArray()
    }
    
    private func createShareOptionArray(){
        if self.arrShareOptions.count == 0 {
            if self.eventProfileDetail.Phone != ""{
                let shareOption1 = WUShareOptions(title: Text.Label.text_Call, normalImage:  #imageLiteral(resourceName: "CallIconNormal"), selectedImage:  #imageLiteral(resourceName: "CallIconActive"),shareOptionType:.call)
                self.arrShareOptions.append(shareOption1)
            }
            let shareOption2 = WUShareOptions(title: Text.Label.text_Share, normalImage:  #imageLiteral(resourceName: "ShareIconNormal"), selectedImage:  #imageLiteral(resourceName: "ShareIconActive"),shareOptionType:.share)
            self.arrShareOptions.append(shareOption2)
            
            //        let shareOption3 = WUShareOptions(title: Text.Label.text_Favorite, normalImage:  #imageLiteral(resourceName: "FavoriteIconNormal"), selectedImage:  #imageLiteral(resourceName: "FavoriteIconActive"),shareOptionType:.favorite)
            //        self.arrShareOptions.append(shareOption3)
            //
            if self.eventProfileDetail.LiveCamsURL.count > 0 {
                let shareOption4 = WUShareOptions(title: Text.Label.text_LiveCam, normalImage: #imageLiteral(resourceName: "LiveCamIconNormal"), selectedImage:  #imageLiteral(resourceName: "LiveCamIconActive"),shareOptionType:.liveCam)
                self.arrShareOptions.append(shareOption4)
            }
            if self.eventProfileDetail.WebsiteURL != "" {
                let shareOption5 = WUShareOptions(title: Text.Label.text_Website, normalImage:  #imageLiteral(resourceName: "WebSiteIconNormal"), selectedImage:  #imageLiteral(resourceName: "WebSiteIconActive"),shareOptionType:.website)
                self.arrShareOptions.append(shareOption5)
            }
            
            let shareOption6 = WUShareOptions(title: Text.Label.text_AddToCalender, normalImage:  #imageLiteral(resourceName: "CalendarIconNormal"), selectedImage:  #imageLiteral(resourceName: "CalendarIconActive"),shareOptionType:.addToCalendar)
            self.checkCalenderEventIsAddedOrNot(shareOption6)
            self.arrShareOptions.append(shareOption6)
            
            //        let shareOption7 = WUShareOptions(title: Text.Label.text_Follow, normalImage: #imageLiteral(resourceName: "FollowIconNormal"), selectedImage:  #imageLiteral(resourceName: "FollowIconActive"),shareOptionType:.follow)
            //        self.arrShareOptions.append(shareOption7)
            //
            //        let shareOption8 = WUShareOptions(title: Text.Label.text_Rate, normalImage:  #imageLiteral(resourceName: "RateIconNormal"), selectedImage:  #imageLiteral(resourceName: "RateIconActive") ,shareOptionType:.rate)
            //        self.arrShareOptions.append(shareOption8)
            //
            if self.eventProfileDetail.Facebook != "" {
                let shareOption9 = WUShareOptions(title: Text.Label.text_Facebook, normalImage:  #imageLiteral(resourceName: "FaceBookIconNormal"), selectedImage:  #imageLiteral(resourceName: "FaceBookIconActive"),shareOptionType:.facebook)
                self.arrShareOptions.append(shareOption9)
            }
        
            
            if self.eventProfileDetail.Twitter != "" {
                let shareOption10 = WUShareOptions(title: Text.Label.text_Twitter, normalImage:  #imageLiteral(resourceName: "TwitterIconNormal"), selectedImage:  #imageLiteral(resourceName: "TwitterIconActive"),shareOptionType:.twitter)
                self.arrShareOptions.append(shareOption10)
            }
          
            
            if self.eventProfileDetail.Instagram != "" {
                let shareOption11 = WUShareOptions(title: Text.Label.text_Insta, normalImage:  #imageLiteral(resourceName: "InstagramIconNormal"), selectedImage:  #imageLiteral(resourceName: "InstagramIconActive"),shareOptionType:.instagram)
                self.arrShareOptions.append(shareOption11)
            }
        
            
            self.collectionViewShareOptions.reloadData()
            
            if self.arrShareOptions.count == 0{
                self.viewHeaderFinalHeight = self.viewHeaderFinalHeight - self.viewCollectionShareOptionHeight.constant
                self.viewCollectionShareOptionHeight.constant = 0
                self.reloadTableForHeaderHeight()
            }
        }
    }
    
    // MARK: - Webservice calls
    private func callWS_getEventDetail(eventId : String){
        WEB_API.call_api_GetEventDetail(eventId: eventId,
                                        latitude: GlobalShared.geolocationFilterData.Latitude,
                                        longitude: GlobalShared.geolocationFilterData.Longitude) { (response, success, message) in
           
                                            Utill.printInTOConsole(printData:"response: \(response ?? "")")
            
            if success == true{
                self.mainView.backgroundColor = .mainViewBackGroundColor
                self.tableViewEventProfile.isHidden = false
                self.buttonNoResults.isHidden = true
                self.buttonGoToTop.isHidden = false
                self.arrEventProfilePropertyList.removeAll()
                let bannerListData = try! JSONSerialization.data(withJSONObject: response?["LiveCamBanners"].arrayObject ?? [], options: [])
                let arrayLivecamBannerList = try! JSONDecoder().decode([WUHomeBannerList].self, from: bannerListData)
                Utill.saveHomeBannerModel(arrayLivecamBannerList)
                
                let data = try! JSONSerialization.data(withJSONObject: response?["EventDetail"].dictionaryObject ?? [:], options: [])
                self.eventProfileDetail = try! JSONDecoder().decode(WUEventDetail.self, from: data)
                Utill.printInTOConsole(printData:"response: \(self.eventProfileDetail )")
                self.prepareViewForEventProfileDetail()
                self.prepareArrayEventProfileProperties()
                self.createShareOptionArray()
                self.tableViewEventProfile.reloadData()
            }else{
//                self.mainView.backgroundColor = .mainViewBackGroundColor
                self.buttonNoResults.isHidden = false
                self.tableViewEventProfile.isHidden = true
                self.buttonGoToTop.isHidden = true
            }
        }
    }
    
    // MARK: - Action Methods
    @IBAction func buttonNoResultsAction(_ sender: Any) {
        self.initialDataSetup()
    }
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.tableViewEventProfile.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func buttonBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSearchAction(_ sender: UIButton) {
        self.buttonSearch.isSelected = true
        if self.isFromSearchVC == true{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.performSegue(withIdentifier: Text.Segue.eventToEventSearchVC, sender: nil)
        }
    }
    
    @IBAction func buttonVideoAction(_ sender: UIButton) {
         Utill.printInTOConsole(printData:"buttonVideoAction")
        Utill.goToLivecamProfile(viewController: self, withLivecamM:  self.eventProfileDetail.LiveCamsURL[0])

       /* if let vc = UIStoryboard.home.get(WUPlayLiveCamViewController.self){
            vc.hidesBottomBarWhenPushed = true
            vc.playLiveCamArray = self.eventProfileDetail.LiveCamsURL
            self.navigationController?.pushViewController(vc, animated: false)
        }*/
    }
    
    @IBAction func buttonReadMoreAction(_ sender: UIButton) {
        let height = Utill.findHeightForText(text:  "Aaa  \n Azz ", havingWidth:  self.labelDiscription.frame.size.width, andFont:self.labelDiscription.font)

        if sender.isSelected == false{
            sender.isSelected = true
            var textsize = Utill.findHeightForText(text:  self.labelDiscription.text!, havingWidth:  self.labelDiscription.frame.size.width, andFont:self.labelDiscription.font)
            if textsize > height{
                textsize = textsize - height
            }
            self.tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableViewEventProfile.frame.size.width, height: self.viewHeaderFinalHeight + textsize)
        }else {
            sender.isSelected = false
            self.tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableViewEventProfile.frame.size.width, height: self.viewHeaderFinalHeight)
        }
        self.tableViewEventProfile.reloadData()
    }
    
    private func manageCalenderEvent(){
        
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                 Utill.printInTOConsole(printData:"granted \(granted)")
                let strSectionName = self.eventProfileDetail.Name

                let user = GlobalShared.user
                let strResultKey = "\(user!.ID)_\(self.eventProfileDetail.GUID)"

                self.event = Utill.findOrCreateEvent(with: self.eventStore, withStepName: strSectionName, withResultKey: strResultKey, withStartDate: self.eventProfileDetail.StartDate, withEndDate: self.eventProfileDetail.EndDate)
                
//                event.title = self.eventProfileDetail.Name
//                event.startDate = Date.dateObject(dateStr: self.eventProfileDetail.StartDate)
//                event.endDate = Date.dateObject(dateStr: self.eventProfileDetail.EndDate)
//                event.notes = self.eventProfileDetail.Description
//                event.location = self.eventProfileDetail.FullAddress
                
//                event.calendar = eventStore.defaultCalendarForNewEvents
                    let controller = EKEventEditViewController()
                    controller.event = self.event
                    controller.eventStore = self.eventStore
                    controller.editViewDelegate = self
                    self.present(controller, animated: true, completion: nil)
                
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
    
    func checkCalenderEventIsAddedOrNot(_ shareOption : WUShareOptions)
    {
        if self.eventdetailModel.eventList.count > 0
        {
            let user = GlobalShared.user
            let strResultKey = "\(user!.ID)_\(self.eventProfileDetail.GUID)"
            let arr = self.eventdetailModel.eventList.filter({$0.UserID_ResultKey == strResultKey})
            if arr.count > 0
            {
                shareOption.isSelected = true
            }
        }
    }
    func deleteCalenderEventFromCalenderAndLocal(_ calenderEventM : WUMyEventList)
    {
        print("event Delete on Click of cross")
        self.event = Utill.findOrCreateEvent(with: self.eventStore, withStepName: calenderEventM.Name, withResultKey: calenderEventM.UserID_ResultKey, withStartDate: calenderEventM.StartDate, withEndDate: calenderEventM.EndDate)
        if self.event!.eventIdentifier != nil
        {
            if let eventRemove = self.eventStore.event(withIdentifier: self.event!.eventIdentifier)
            {
                do {
                    try self.eventStore.remove(eventRemove, span: .thisEvent)
                    Utill.saveEvent(inCalendar: calenderEventM, isdelete: true, withViewController: self)
                } catch let error as NSError {
                    Utill.printInTOConsole(printData:"failed to save event with error : \(error)")
                }
            }
        }else {
            Utill.saveEvent(inCalendar: calenderEventM, isdelete: true, withViewController: self)
        }
        
        if let arrEvent = Utill.getEventFromCalendar() {
            self.eventdetailModel.eventList = arrEvent
        }
        if self.eventdetailModel.eventList.count == 0
        {
            let sectionTemp = self.arrEventProfilePropertyList.index(where: {$0 as? WUMyEventListDetail === self.eventdetailModel})
            if sectionTemp! < self.arrEventProfilePropertyList.count
            {
                self.eventdetailModel.isExpanded = false
                self.arrEventProfilePropertyList.remove(at: sectionTemp!)
            }
        }
        UIView.performWithoutAnimation {
            self.tableViewEventProfile.reloadData()
        }
        
        let arrShare = self.arrShareOptions.filter({$0.title == Text.Label.text_AddToCalender})
        if arrShare.count > 0{
            arrShare[0].isSelected = false
        }
        self.collectionViewShareOptions.reloadData()
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

//MARK: - TableView
extension WUEventProfileViewController : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrEventProfilePropertyList.count//(1 for extar section of permission like mayBe or Yes)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //        if section == 0 {
        //            return 110.0
        //        }else{
        return 53.0
        //}
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        if section == 0 {
        //            let eventAttendView = WUAttendEventView.instanceFromNib()
        //            eventAttendView.frame = CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 110.0))
        //            return eventAttendView
        //        }else {}
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Utill.getClassNameFor(classType: WUExpandableSectionHeaderView())) as! WUExpandableSectionHeaderView
        headerView.tag = section
        headerView.delegate = self
        headerView.viewExpandableSectionHeader.backgroundColor = .white
        
        let sectionObject = self.arrEventProfilePropertyList[section]
        headerView.profileCategory = sectionObject
        headerView.buttonViewAllPhotos.isHidden = true
        headerView.buttonArrowToExpandCell.isHidden = false
        
        if self.isSectionExpanded(forSectionObj: sectionObject){
            if sectionObject is WUEventPhotoDetail{
                headerView.buttonViewAllPhotos.isHidden = false
            }else if (sectionObject is WUMyEventListDetail)  || (sectionObject is WUMoreEventDetail){
                headerView.viewSeperator.isHidden = false
            }
            headerView.viewExpandableSectionHeader.backgroundColor = UIColor.WhiteShadeBGColor
            headerView.buttonArrowToExpandCell.isHidden = true
        }
        return headerView
        
        //        if self.isSectionExpanded(forSectionObj: sectionObject){
        //            headerView.buttonArrowToExpandCell.isHidden = true
        //        }
        //        return headerView
    }
    
    private func isSectionExpanded(forSectionObj sectionObject : Any) -> Bool{
        if sectionObject is WUEventPhotoDetail {
            return (sectionObject as! WUEventPhotoDetail).isExpanded
        }else  if sectionObject is WUEventPromoterDetail  {
            return (sectionObject as! WUEventPromoterDetail).isExpanded
        }else if sectionObject is WUMoreEventDetail {
            return (sectionObject as! WUMoreEventDetail).isExpanded
        }else if sectionObject is WUEventDirectionDetail {
            return (sectionObject as! WUEventDirectionDetail).isExpanded
        }else if sectionObject is WUMyEventListDetail {
             return (sectionObject as! WUMyEventListDetail).isExpanded
        }else  if sectionObject is WUEventAdmissionDetail  {
            return (sectionObject as! WUEventAdmissionDetail).isExpanded
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if section == 0 {
        //            return 0
        //        }else{
        return 1
        //        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.getRowsForSection(section: indexPath.section)
    }
    
    private func getRowsForSection(section : Int) -> CGFloat{
        let sectionObject = self.arrEventProfilePropertyList[section]
        if self.isSectionExpanded(forSectionObj: sectionObject) == true {
            if sectionObject is WUEventPhotoDetail {
                return 250.0
            }else if sectionObject is WUEventDirectionDetail {
                return 210.0
            }
            else if sectionObject is WUMyEventListDetail {
                return CGFloat((self.eventdetailModel.eventList.count * 40) + 50)
            }
            else{
                return UITableViewAutomaticDimension
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionObject = self.arrEventProfilePropertyList[indexPath.section ]
        if sectionObject is WUEventPhotoDetail {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUEventProfileTableCell()), for: indexPath)as! WUEventProfileTableCell
            cell.eventPhotoDetail = sectionObject as! WUEventPhotoDetail
            cell.delegate = self
            return cell
        }else if (sectionObject is WUEventPromoterDetail)  || (sectionObject is WUMoreEventDetail)  || (sectionObject is WUEventAdmissionDetail) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUExpandableImageTableCell()), for: indexPath)as! WUExpandableImageTableCell
            if sectionObject is WUEventPromoterDetail {
                cell.venueProfileList = sectionObject as! WUEventPromoterDetail
            }else if sectionObject is WUMoreEventDetail { //
                cell.venueProfileList = sectionObject as! WUMoreEventDetail
            }else if sectionObject is WUEventAdmissionDetail{
                 cell.venueProfileList = sectionObject as! WUEventAdmissionDetail
            }
            cell.delegate = self
            return cell
        }else if  (sectionObject is WUMyEventListDetail) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUMyEventExpandTableCell()), for: indexPath)as! WUMyEventExpandTableCell
                cell.venueProfileList = sectionObject as! WUMyEventListDetail
            cell.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier:Utill.getClassNameFor(classType: WUEventDirectionTableCell()) , for: indexPath)as! WUEventDirectionTableCell
            cell.eventDirection = sectionObject as! WUEventDirectionDetail
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionObject = self.arrEventProfilePropertyList[indexPath.section ]
        if sectionObject is WUEventDirectionDetail {
            if (sectionObject as! WUEventDirectionDetail).Latitude == "" || Float((sectionObject as! WUEventDirectionDetail).Latitude) == 0.0 && (sectionObject as! WUEventDirectionDetail).Longitude == "" || Float((sectionObject as! WUEventDirectionDetail).Longitude) == 0.0 {
                Utill.showAlertView(viewController: self, message: Text.Message.eventLocationNotFound)
            } else if GlobalShared.currentLocationCoordinate.latitude == 0 && GlobalShared.currentLocationCoordinate.longitude == 0 {
                AppDel.setUpLocationManager(completion: nil)
            }else{
                if let vc = UIStoryboard.venue.get(WUVenueMapViewController.self){
                    vc.eventMapDetail = sectionObject as? WUEventDirectionDetail
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
    }
}


//MARK: - CollectionView
extension WUEventProfileViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrShareOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Utill.getClassNameFor(classType: WUCategoryCollectionCell()) , for: indexPath)as! WUCategoryCollectionCell
        cell.shareOption = self.arrShareOptions[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
            break
        case .liveCam:
            self.playLiveCam(cell: cell, forIndexPath: indexPath)
            break
        case .website:
            self.openInWebsite(cell: cell, forIndexPath: indexPath)
            break
        case .addToCalendar:
            FirebaseManager.sharedInstance.event_add_calendar_ios(parameter: nil)
            self.addEventToCalenderForCell(cell: cell, forIndexPath: indexPath)
            break
        case .follow:
            break
        case .rate:
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
    
    private func callForVenue(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath) {
        if self.eventProfileDetail.Phone == "" {
            
         } else {
            if let url = URL(string: "tel://\(Utill.formatNumber(self.eventProfileDetail.Phone)!)"),
                UIApplication.shared.canOpenURL(url) {
                self.arrShareOptions[indexPath.row].isSelected = true
                cell.updateCellImage()
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }else {
                Utill.showAlertView(viewController: self, message:Text.Message.msg_Call)
            }
        }
    }
    
    private func shareVenue(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        self.arrShareOptions[indexPath.row].isSelected = true
        cell.updateCellImage()
        WEB_API.call_api_GetShareLinkForVenueOrEvent(strVenueID: "", strFourSquareVenueID : "", strEventID: self.eventProfileDetail.ID, strLiveCamID: "") { (response, success, message) in
            if success == true{
                
                let dicShare = response?.dictionary!
                let coverPhotoURL = self.imageviewEventFeaturedImage.image!
                let shareText = dicShare!["ShareMessage"]?.string!
                let shareLink = dicShare!["ShareLink"]?.string!
                
                //let shareLink = "https://apps.arvzapp.com/event/\(self.eventProfileDetail.ID)"
                 
                let strtDate = Date.dateObject(dateStr: self.eventProfileDetail.StartDate)
                let endedDate = Date.dateObject(dateStr: self.eventProfileDetail.EndDate)
    
                let finalStartDate =  Date.eventDateStringInUTC(date: strtDate!)
                let finalEndDate = Date.eventDateStringInUTC(date: endedDate!)
                               
                let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: self.imageviewEventFeaturedImage.image) as Any,
                                        WUShareActivityItemProvider(placeholderItem: "Check out this event on ArvzApp!") as Any,
                                        WUShareActivityItemProvider(placeholderItem: "\nI found this event on ArvzApp and wanted to share it!") as Any,
                                        WUShareActivityItemProvider(placeholderItem: "\nEvent Name: \(self.eventProfileDetail.Name)") as Any,
                                        WUShareActivityItemProvider(placeholderItem: "\nEvent Date & Time: \(finalStartDate) – \(finalEndDate)") as Any,
                                        WUShareActivityItemProvider(placeholderItem: "\n\(shareLink ?? "https://apps.arvzapp.com")") as Any]
                                                          
                
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                activityViewController.setValue("Check out this event on ArvzApp!", forKey: "Subject")

                let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
                activityViewController.excludedActivityTypes = [.addToReadingList ,.saveToCameraRoll , .copyToPasteboard , .addToReadingList ,.assignToContact ,.print , activityTypeCloud, .airDrop]
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
                
                activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                    self.arrShareOptions[indexPath.row].isSelected = false
                    cell.updateCellImage()
                    if completed == true{
                        //Utill.showAlertView(viewController: self, message: Text.Message.venueShareMsg)
                    }
                }
            }
        }
        /*
         var text = ""
         var webSite : URL!
         var image : UIImage = UIImage()
         text = "EventName : \(self.eventProfileDetail.Name)\n EventAddress : \(self.eventProfileDetail.FullAddress)"
         if self.eventProfileDetail.WebsiteURL != ""{
         webSite = URL(string: self.eventProfileDetail.WebsiteURL)!
         }else{
         webSite = URL(string:"http://www.wussup.com/")!
         }
         if self.eventProfileDetail.ConverPhotoURL == ""{
         let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: text) as Any,WUShareActivityItemProvider(placeholderItem: webSite) as Any]
         let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
         let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
         activityViewController.excludedActivityTypes = [.addToReadingList ,.saveToCameraRoll , .copyToPasteboard , .addToReadingList ,.assignToContact ,.print , activityTypeCloud]
         activityViewController.popoverPresentationController?.sourceView = self.view
         self.present(activityViewController, animated: true, completion: nil)
         
         activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
         if completed == true{
         Utill.showAlertView(viewController: self, message: Text.Message.applicationShareMsg)
         self.arrShareOptions[indexPath.row].isSelected = false
         cell.updateCellImage()
         }
         }
         
         }else{
         Utill.getImageFrom(path: self.eventProfileDetail.ConverPhotoURL) { (img) in
         DispatchQueue.main.async {
         image = img
         let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: img) as Any,WUShareActivityItemProvider(placeholderItem: text) as Any,WUShareActivityItemProvider(placeholderItem: webSite) as Any]
         let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
         let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
         activityViewController.excludedActivityTypes = [.addToReadingList ,.saveToCameraRoll , .copyToPasteboard , .addToReadingList ,.assignToContact ,.print , activityTypeCloud]
         activityViewController.popoverPresentationController?.sourceView = self.view
         self.present(activityViewController, animated: true, completion: nil)
         activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
         if completed == true{
         self.arrShareOptions[indexPath.row].isSelected = false
         cell.updateCellImage()
         Utill.showAlertView(viewController: self, message: Text.Message.applicationShareMsg)
         }
         }
         }
         }
         }*/
    }
    
    /* private func favoriteVenueForCell(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
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
     }*/
    
    private func playLiveCam(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        self.arrShareOptions[indexPath.row].isSelected = true
        cell.updateCellImage()
        FirebaseManager.sharedInstance.view_event_GUID_livecam_GUID_ios(parameter: nil, playLiveCamEventM: self.eventProfileDetail)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute:
            {
                Utill.goToLivecamProfile(viewController: self, withLivecamM:  self.eventProfileDetail.LiveCamsURL[0])

               /* if let vc = UIStoryboard.home.get(WUPlayLiveCamViewController.self){
                    vc.hidesBottomBarWhenPushed = true
                    vc.playLiveCamArray = self.eventProfileDetail.LiveCamsURL
                    self.navigationController?.pushViewController(vc, animated: false)
                }*/
        })
    }
    
    private func openInWebsite(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        self.arrShareOptions[indexPath.row].isSelected = true
        cell.updateCellImage()
        
        var webSiteUrl = self.eventProfileDetail.WebsiteURL
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
    
    /*
     private func rateVenueForCell(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
     let rateView = WUVenueRateView.instanceFromNib()
     rateView.delegate = self
     rateView.venueDetail = self.venueProfileDetail
     rateView.rating = Int(self.venueProfileDetail.UserVenueRating) ?? 0
     rateView.showInView(superView: self.view)
     }
     */
    
    private func shareOnFacebook(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        self.arrShareOptions[indexPath.row].isSelected = true
        cell.updateCellImage()
        
        var facebookUrl = self.eventProfileDetail.Facebook
        if facebookUrl.isValidForUrl() == false
        {
            facebookUrl = "https://" + facebookUrl
        }
        
        UIApplication.shared.open(URL(string : facebookUrl)!, options: [:], completionHandler: { (status) in
            self.arrShareOptions[indexPath.row].isSelected = false
            cell.updateCellImage()
        })
        
        /*let shareText = "EventName : \(self.eventProfileDetail.Name)\n EventAddress : \(self.eventProfileDetail.FullAddress)"
        var shareLink : String! = ""
        if self.eventProfileDetail.WebsiteURL == ""{
            shareLink = ""
        }else{
            shareLink = self.eventProfileDetail.WebsiteURL
        }
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookComposeVC?.setInitialText(shareText)
            //            facebookComposeVC?.add(img)
            facebookComposeVC?.add(URL(string:shareLink ))
            self.present(facebookComposeVC!, animated: true, completion: nil)
            facebookComposeVC?.completionHandler = {(result:SLComposeViewControllerResult) -> Void in
                switch result {
                case .cancelled:
                    self.arrShareOptions[indexPath.row].isSelected = false
                    cell.updateCellImage()
                    break
                case .done:
                    self.arrShareOptions[indexPath.row].isSelected = true
                    cell.updateCellImage()
                    break
                }
            }
        }else {
            let content = FBSDKShareLinkContent()
            let url : URL? = URL(string:shareLink )
            if (url != nil)
            {
                content.contentURL = url
            }
            FBSDKShareDialog.show(from: self, with: content, delegate: nil)
        }*/
    }
    
    private func shareOnTwitter(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        self.arrShareOptions[indexPath.row].isSelected = true
        cell.updateCellImage()
        
        var twitterUrl = self.eventProfileDetail.Twitter
        if twitterUrl.isValidForUrl() == false
        {
            twitterUrl = "https://" + twitterUrl
        }
        
        UIApplication.shared.open(URL(string : twitterUrl)!, options: [:], completionHandler: { (status) in
            self.arrShareOptions[indexPath.row].isSelected = false
            cell.updateCellImage()
        })
        
        /*let shareText = "EventName : \(self.eventProfileDetail.Name)\n EventAddress : \(self.eventProfileDetail.FullAddress)"
        var shareLink : String! = ""
        if self.eventProfileDetail.WebsiteURL == ""{
            shareLink = ""
        }else{
            shareLink = self.eventProfileDetail.WebsiteURL
        }
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterComposeVC?.setInitialText(shareText)
            twitterComposeVC?.add(URL(string: shareLink))
            self.present(twitterComposeVC!, animated: true, completion: nil)
            twitterComposeVC?.completionHandler = {(result:SLComposeViewControllerResult) -> Void in
                switch result {
                case .cancelled:
                    self.arrShareOptions[indexPath.row].isSelected = false
                    cell.updateCellImage()
                    break
                case .done:
                    self.arrShareOptions[indexPath.row].isSelected = true
                    cell.updateCellImage()
                    break
                }
            }
        }else {
            if let url = URL(string: "twitter://"), UIApplication.shared.canOpenURL(url) {
                TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
                    if session != nil { // Log in succeeded
                        let composer = TWTRComposer()
                        composer.setText(shareText)
                        composer.setURL(URL(string: shareLink))
                        composer.show(from: self.navigationController!, completion: nil)
                    } else {
                        Utill.showAlertView(viewController: self, message: (error?.localizedDescription)!)
                    }
                })
            }else{
                var shareString = "https://twitter.com/intent/tweet?text=\(shareText)"
                if shareLink.count > 0
                {
                    shareString = "https://twitter.com/intent/tweet?text=\(shareText)&url=\(shareLink!)"
                }
                shareString = shareString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                UIApplication.shared.open(URL(string : shareString)!, options: [:], completionHandler: { (status) in
                })
            }
        }*/
    }
    
    private func shareToInstagramForCell(cell : WUCategoryCollectionCell, forIndexPath indexPath : IndexPath){
        self.arrShareOptions[indexPath.row].isSelected = true
        cell.updateCellImage()
        
        var instagramUrl = self.eventProfileDetail.Instagram
        if instagramUrl.isValidForUrl() == false
        {
            instagramUrl = "https://" + instagramUrl
        }
        
        UIApplication.shared.open(URL(string : instagramUrl)!, options: [:], completionHandler: { (status) in
            self.arrShareOptions[indexPath.row].isSelected = false
            cell.updateCellImage()
        })
        
       /* Utill.getImageFrom(path: self.eventProfileDetail.ConverPhotoURL) { (img) in
            DispatchQueue.main.async {
                Utill.getPHObjectPlaceHolder(videoURL: nil, objectImage: img, isMediaTypeImage: true, CompletionHandler: {(success:Bool, objectPlaceHolder:PHObjectPlaceholder?) in
                    DispatchQueue.main.async {
                        if success{
                            InstagramManager.sharedManager.postFileToInstagramWithCaption(objectMediaID: (objectPlaceHolder?.localIdentifier)!, isImage: true)
                        }
                        else {
                            Utill.showAlert_GoToSettingCancle_View(viewController: self, message: Text.Message.photoPermissionMsg, completion: { (bool) in
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                                } else {
                                    // Fallback on earlier versions
                                }
                            })
                        }
                    }
                })
            }
        }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70.0, height: 115.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20.0)
    }
}

//MARK: - AddToCalender => EKEventEditViewDelegate
extension WUEventProfileViewController : EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        self.dismiss(animated: true, completion: nil)
        let arrShare = self.arrShareOptions.filter({$0.title == Text.Label.text_AddToCalender})
        
        let indexPath = IndexPath(item: self.currentShareOptionIndex, section: 0)
        if let cell = self.collectionViewShareOptions.cellForItem(at: indexPath) as? WUCategoryCollectionCell{
            if action == .saved {
                do {
                try self.eventStore.save(self.event!, span: .thisEvent)
                } catch let error as NSError {
                Utill.printInTOConsole(printData:"failed to save event with error : \(error)")
                }
                let user = GlobalShared.user
                let eventName : WUMyEventList = WUMyEventList()
                eventName.EventIdentifier = self.event!.eventIdentifier
                eventName.UserID_ResultKey = "\(user!.ID)_\(self.eventProfileDetail.GUID)"
                eventName.ID = self.eventProfileDetail.ID
                eventName.Name = self.eventProfileDetail.Name
                eventName.StartDate = self.event!.startDate.toUTCString()
                eventName.EndDate = self.event!.endDate.toUTCString()
                if self.eventStore.eventStoreIdentifier.count > 0
                {
                    Utill.saveEvent(inCalendar: eventName, isdelete: false, withViewController: self)
                }
                
                if let arrEvent = Utill.getEventFromCalendar() {
                    eventdetailModel.eventList = arrEvent
                }
                var index = 0
                if self.eventProfileDetail.EventAdmissionDetail.EventAdmission.count > 0 {
                    index += 1
                }
                if self.eventProfileDetail.DirectionDetail.Latitude != "" && self.eventProfileDetail.DirectionDetail.Latitude != ""{
                    index += 1
                }
                
                if self.eventProfileDetail.EventPhotoDetail.eventPhotos.count > 0 {
                    index += 1
                }
                if self.eventProfileDetail.EventPromoterDetail.eventPromoter.count > 0 {
                    index += 1
                }
                
                if arrShare.count > 0{
                    arrShare[0].isSelected = true
                }
                Utill.showAlertView(viewController: self, message:" Event Successfully Added To Calendar")
                cell.updateCellImage()
                if self.eventdetailModel.eventList.count > 0 {
                    if  let sectionTemp = self.arrEventProfilePropertyList.index(where: {$0 as? WUMyEventListDetail === self.eventdetailModel}), sectionTemp < self.arrEventProfilePropertyList.count
                    {
                        self.arrEventProfilePropertyList.remove(at: sectionTemp)
                    }
                    self.arrEventProfilePropertyList.insert(self.eventdetailModel, at: index)
                }
                UIView.performWithoutAnimation {
                    self.tableViewEventProfile.reloadData()
                }
            }
            else if action == .deleted
            {
                let user = GlobalShared.user
                let eventName : WUMyEventList = WUMyEventList()
                if self.event?.eventIdentifier != nil
                {
                    eventName.EventIdentifier = self.event!.eventIdentifier
                    eventName.UserID_ResultKey = "\(user!.ID)_\(self.eventProfileDetail.GUID)"
                    eventName.ID = self.eventProfileDetail.ID
                    eventName.Name = self.eventProfileDetail.Name
                    eventName.StartDate = self.event!.startDate.toUTCString()
                    eventName.EndDate = self.event!.endDate.toUTCString()
                    
                    self.deleteCalenderEventFromCalenderAndLocal(eventName)
                    if arrShare.count > 0{
                        arrShare[0].isSelected = false
                    }
                    cell.updateCellImage()
                }
            }
            else{
                if arrShare.count > 0{
                    self.checkCalenderEventIsAddedOrNot(arrShare[0])
                }
                cell.updateCellImage()
            }
        }
    }
}

//MARK: -  Delegate
extension WUEventProfileViewController :WUVenueProfileTableCellDelegate {
    
    func venueCloseButton(cell: UITableViewCell, didSelectCloseButton button: UIButton) {
         Utill.printInTOConsole(printData:"Close")
        print(type(of: cell))
        let indexPath = tableViewEventProfile.indexPath(for: cell)
        let sectionObject = self.arrEventProfilePropertyList[(indexPath?.section)!]
        if self.isSectionExpanded(forSectionObj: sectionObject) == true {
            if sectionObject is WUEventPhotoDetail {
                (sectionObject as! WUEventPhotoDetail).isExpanded = false
            }else  if sectionObject is WUEventDirectionDetail  {
                (sectionObject as! WUEventDirectionDetail).isExpanded = false
            }else  if sectionObject is WUMyEventListDetail  {
                (sectionObject as! WUMyEventListDetail).isExpanded = false
            }
            UIView.performWithoutAnimation  {
                self.tableViewEventProfile.reloadData();
                self.tableViewEventProfile.layoutIfNeeded();
            }
        }
    }
    
    func venueGoToTopButtonClicked() {
        self.tableViewEventProfile.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func eventCrossDelete(cell : WUMyEventListTableCell , withCalenderEvent  calenderEventM: WUMyEventList) {
        print("event Delete on Click of cross")
        Utill.showAlert_OKCancle_View(viewController: self, message: Text.Message.deleteRowMsg) { (bool) in
            self.deleteCalenderEventFromCalenderAndLocal(calenderEventM)
        }
    }
}

extension WUEventProfileViewController : WUExpandableImageTableCellDelegate{
    
    func eventShareInfo(){
        WEB_API.call_api_GetShareLinkForVenueOrEvent(strVenueID: "", strFourSquareVenueID : "", strEventID: self.eventProfileDetail.ID, strLiveCamID: "") { (response, success, message) in
            if success == true{
                let dicShare = response?.dictionary!
                let coverPhotoURL = self.imageviewEventFeaturedImage.image!
                let shareText = dicShare!["ShareMessage"]?.string!
                let shareLink = dicShare!["ShareLink"]?.string!
                //let shareLink = "https://apps.arvzapp.com/event/\(self.eventProfileDetail.ID)"
                
                     
                let strtDate = Date.dateObject(dateStr: self.eventProfileDetail.StartDate)
                let endedDate = Date.dateObject(dateStr: self.eventProfileDetail.EndDate)
                
                let finalStartDate =  Date.eventDateStringInUTC(date: strtDate!)
                let finalEndDate = Date.eventDateStringInUTC(date: endedDate!)
                                              
                let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: coverPhotoURL) as Any,
                                        WUShareActivityItemProvider(placeholderItem: "Check out this event on ArvzApp!") as Any,
                                        WUShareActivityItemProvider(placeholderItem: "\nI found this event on ArvzApp and wanted to share it!") as Any,
                                        WUShareActivityItemProvider(placeholderItem: "\nEvent Name: \(self.eventProfileDetail.Name)") as Any,
                                        WUShareActivityItemProvider(placeholderItem: "\nEvent Date & Time: \(finalStartDate) – \(finalEndDate)") as Any,
                                        WUShareActivityItemProvider(placeholderItem: "\n\(shareLink ?? "https://apps.arvzapp.com")") as Any]
                                                          
                
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                activityViewController.setValue("Check out this event on ArvzApp!", forKey: "Subject")
                
                let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
                activityViewController.excludedActivityTypes = [.addToReadingList ,.saveToCameraRoll , .copyToPasteboard , .addToReadingList ,.assignToContact ,.print , activityTypeCloud, .airDrop]
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
                
                activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                    if completed == true{
                        //Utill.showAlertView(viewController: self, message: Text.Message.venueShareMsg)
                    }
                }
            }
        }
        /*
         var text = ""
         var webSite : URL!
         var image : UIImage = UIImage()
         text = "EventName : \(self.eventProfileDetail.Name)\n EventAddress : \(self.eventProfileDetail.FullAddress)"
         if self.eventProfileDetail.WebsiteURL != ""{
         webSite = URL(string: self.eventProfileDetail.WebsiteURL)!
         }else{
         webSite = URL(string:"http://www.wussup.com/")!
         }
         if self.eventProfileDetail.ConverPhotoURL == ""{
         let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: text) as Any,WUShareActivityItemProvider(placeholderItem: webSite) as Any]
         let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
         let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
         activityViewController.excludedActivityTypes = [.addToReadingList ,.saveToCameraRoll , .copyToPasteboard , .addToReadingList ,.assignToContact ,.print , activityTypeCloud]
         activityViewController.popoverPresentationController?.sourceView = self.view
         self.present(activityViewController, animated: true, completion: nil)
         
         activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
         if completed == true{
         Utill.showAlertView(viewController: self, message: Text.Message.applicationShareMsg)
         }
         }
         
         }else{
         Utill.getImageFrom(path: self.eventProfileDetail.ConverPhotoURL) { (img) in
         DispatchQueue.main.async {
         image = img
         let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: img) as Any,WUShareActivityItemProvider(placeholderItem: text) as Any,WUShareActivityItemProvider(placeholderItem: webSite) as Any]
         let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
         let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
         activityViewController.excludedActivityTypes = [.addToReadingList ,.saveToCameraRoll , .copyToPasteboard , .addToReadingList ,.assignToContact ,.print , activityTypeCloud]
         activityViewController.popoverPresentationController?.sourceView = self.view
         self.present(activityViewController, animated: true, completion: nil)
         activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
         if completed == true{
         Utill.showAlertView(viewController: self, message: Text.Message.applicationShareMsg)
         }
         }
         }
         }
         }*/
    }
    
    func innerShareButton(cell: UITableViewCell, didSelectShareButton button: UIButton, tabel: UITableView) {
        self.eventShareInfo()
        //        var image = #imageLiteral(resourceName: "placeholder")
        //        if cell is WUEventPromoterTableCell{
        //            if (cell as! WUEventPromoterTableCell).imageViewPromoter.image != nil{
        //                image = (cell as! WUEventPromoterTableCell).imageViewPromoter.image!
        //            }
        //        }else {
        //            if (cell as! WUInnerImageTableCell).imageViewCell.image != nil{
        //                image = (cell as! WUInnerImageTableCell).imageViewCell.image!
        //            }
        //        }
        ////        if (cell as! WUEventPromoterTableCell).imageViewPromoter.image != nil{
        ////            image = (cell as! WUEventPromoterTableCell).imageViewPromoter.image!
        ////        }else if (cell as! WUInnerImageTableCell).imageViewCell.image != nil{
        ////            image = (cell as! WUInnerImageTableCell).imageViewCell.image!
        ////        }
        //        //        let shareAll = [image] as [Any]
        //
        //        let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: image) as Any]
        //
        //        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        //        let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
        //        activityViewController.excludedActivityTypes = [.addToReadingList ,.saveToCameraRoll , .copyToPasteboard , .addToReadingList ,.assignToContact ,.print , activityTypeCloud]
        //        activityViewController.popoverPresentationController?.sourceView = self.view
        //        self.present(activityViewController, animated: true, completion: nil)
        //
        //        activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
        //            if completed == true{
        //                Utill.showAlertView(viewController: self, message: Text.Message.applicationShareMsg)
        //            }
        //        }
    }
    
    func innerCloseButton(cell: UITableViewCell, expandableImagetableCell: WUExpandableImageTableCell, didSelectCloseButton button: UIButton, tabel: UITableView) {
        let indexPath = tableViewEventProfile.indexPath(for: expandableImagetableCell)
        let sectionObject = self.arrEventProfilePropertyList[(indexPath?.section)!]
        
        if self.isSectionExpanded(forSectionObj: sectionObject) == true {
            if sectionObject is WUEventPromoterDetail {
                (sectionObject as! WUEventPromoterDetail).isExpanded = false
            }else if sectionObject is WUMoreEventDetail{
                (sectionObject as! WUMoreEventDetail).isExpanded = false
            }else if sectionObject is WUEventAdmissionDetail{
                (sectionObject as! WUEventAdmissionDetail).isExpanded = false
            }
//            UIView.performWithoutAnimation  {
                self.tableViewEventProfile.reloadData();
                self.tableViewEventProfile.layoutIfNeeded();
//            }
        }
    }
    
    
    func innerCalendarButton(cell: UITableViewCell, expandableImagetableCell: WUExpandableImageTableCell, didSelectCalendarButton button: UIButton, tabel: UITableView) {
        self.manageCalenderEvent()
    }
    
    func goToTopButtonClicked() {
        self.tableViewEventProfile.setContentOffset(.zero, animated: true)
    }
    
    func expandableImageTableCell(innerCell: UITableViewCell, didLoadImage image: UIImage) {
        if self.tableViewEventProfile.indexPath(for: innerCell) != nil{
            UIView.performWithoutAnimation  {
                self.tableViewEventProfile.reloadData();
                self.tableViewEventProfile.layoutIfNeeded();
            }
        }
    }
    func didSelectPhoto(cell: UITableViewCell, currentVisibleIndex: IndexPath) {
        
        if let vc = UIStoryboard.venue.get(WUVenueIndividualPhotoViewController.self){
            vc.photosindividual = self.eventProfileDetail.EventPhotoDetail
            vc.currentVisibleIndex = currentVisibleIndex.row
            vc.venueOrEvent = self.eventProfileDetail
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: -  Header expand Delegate
extension WUEventProfileViewController : WUExpandableSectionHeaderViewDelegate{
    func expandableSectionHeaderView(didSelectExpandableSectionHeaderView headerView: UIView) {
         Utill.printInTOConsole(printData:"expand header View ")
        let index = headerView.tag
        let sectionObject = self.arrEventProfilePropertyList[index]
        if self.isSectionExpanded(forSectionObj: sectionObject) == false {
            if sectionObject is WUEventPhotoDetail {
                (sectionObject as! WUEventPhotoDetail).isExpanded = true
            }else  if sectionObject is WUEventPromoterDetail  {
                (sectionObject as! WUEventPromoterDetail).isExpanded = true
            }else  if sectionObject is WUMoreEventDetail  {
                (sectionObject as! WUMoreEventDetail).isExpanded = true
            }else  if sectionObject is WUEventDirectionDetail  {
                (sectionObject as! WUEventDirectionDetail).isExpanded = true
            }else if sectionObject is WUMyEventListDetail {
                (sectionObject as! WUMyEventListDetail).isExpanded = true
            }else if sectionObject is WUEventAdmissionDetail {
                (sectionObject as! WUEventAdmissionDetail).isExpanded = true
            }
            if #available(iOS 11.0, *) {
                UIView.setAnimationsEnabled(false)
                self.tableViewEventProfile.beginUpdates()
                self.tableViewEventProfile.reloadSections(IndexSet(integer: index), with: .none)
                self.tableViewEventProfile.endUpdates()
                UIView.setAnimationsEnabled(true)
            }
            else {
                UIView.performWithoutAnimation  {
                    self.tableViewEventProfile.reloadData();
                    self.tableViewEventProfile.layoutIfNeeded();
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                if ((sectionObject is WUMoreEventDetail && (sectionObject as! WUMoreEventDetail).isExpanded == true) || (sectionObject is WUEventPromoterDetail && (sectionObject as! WUEventPromoterDetail).isExpanded == true)  || (sectionObject is WUEventAdmissionDetail && (sectionObject as! WUEventAdmissionDetail).isExpanded == true))
                {
                    if self.tableViewEventProfile.contentOffset.y+150 < self.tableViewEventProfile.contentSize.height
                    {
                        self.tableViewEventProfile.setContentOffset(CGPoint(x: 0, y: self.tableViewEventProfile.contentOffset.y+150), animated: false)
                    }
                    else {
                        self.tableViewEventProfile.setContentOffset(CGPoint(x: 0, y: self.tableViewEventProfile.contentOffset.y+50), animated: false)
                    }
                }
                else {
                    self.tableViewEventProfile.scrollToRow(at: IndexPath(row: 0, section: index), at: .none, animated: false)
                }
            })
        }
    }
    func expandableSectionHeaderView(didSelectViewAll headerView: UIView) {
        
        if let vc = UIStoryboard.venue.get(WUVenuePhotosViewController.self){
            vc.photos = self.eventProfileDetail.EventPhotoDetail
            vc.venueOrEvent = self.eventProfileDetail
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
