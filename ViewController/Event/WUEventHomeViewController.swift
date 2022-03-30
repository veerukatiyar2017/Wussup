//
//  WuEventHomeViewController.swift
//  Wussup
//
//  Created by MAC219 on 5/23/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import EventKitUI
import IQKeyboardManagerSwift

struct EventListData : Codable {
    let TodayEvents                 : WUDateWiseEvents
    let TomorrowEvents              : WUDateWiseEvents
    let ThisWeekEvents              : WUDateWiseEvents
    let UpComingEvents              : WUDateWiseEvents
    let MoreEvents                  : WUDateWiseEvents
    let LiveCamBanners              : [WUHomeBannerList]
    
    enum EventListSection : Int {
        case todayEvents = 0
        case tomorrowEvents
        case thisWeekEvents
        case upComingEvents
        case moreEvents
        case liveCamBanners
    }
}

class WUEventHomeViewController: UIViewController {
    // MARK: - Constants
    let TopBarExpandHeight = CGFloat(125.0)
    let TopBarSmallHeight = CGFloat(77.0)

    // MARK: - IBOutlets
    @IBOutlet private weak var calendarView                     : FSCalendar!
    @IBOutlet private weak var topBarExpandView                 : UIView!
    @IBOutlet private weak var topBarSmallView                  : UIView!
    @IBOutlet private weak var constraintExpandTopBarHeight     : NSLayoutConstraint!
    @IBOutlet private weak var labelTitleEventList              : UILabel!
    @IBOutlet  weak var backButton                              : UIButton!
    @IBOutlet  weak var buttonEventExpnad                       : UIButton!
    @IBOutlet  weak var buttonEventList                         : UIButton!
    @IBOutlet  weak var buttonEventCategories                   : UIButton!
    @IBOutlet private weak var containerViewEventExpand         : UIView!
    @IBOutlet private weak var containerViewEventList           : UIView!
    @IBOutlet private weak var containerViewEventCategory       : UIView!
    @IBOutlet private weak var calendarContainerView            : UIView!
    @IBOutlet private weak var calendarBottomView               : UIView!
    @IBOutlet private weak var buttonNextMonth                  : UIButton!
    @IBOutlet private weak var buttonPrevMonth                  : UIButton!
    @IBOutlet private weak var calendarViewHeight               : NSLayoutConstraint!
    @IBOutlet private weak var containerTopSpace                : NSLayoutConstraint!
    @IBOutlet private weak var buttonToggleCalendar             : UIButton!
    @IBOutlet private weak var buttonSearchSmallView            : UIButton!
    @IBOutlet private weak var buttonSearchExpandView           : UIButton!
    @IBOutlet  weak var segmentViewHeightCont                   : NSLayoutConstraint!
    @IBOutlet  weak var segmentStackViewBottomCont              : NSLayoutConstraint!
    
    // Geolocation Filter
     @IBOutlet weak var locationFilterDistanceView                   : UIView!
     @IBOutlet weak var locationFilterCityView                       : UIView!
     @IBOutlet weak var locationTextField                            : UITextField!
     @IBOutlet weak var locationRadiusPickerOutlet                   : UIPickerView!
     @IBOutlet weak var showLocatinRadiusImage                       : UIImageView!
     @IBOutlet weak var locationRadius                               : UILabel!
     @IBOutlet weak var pickerView                                   : UIView!
     @IBOutlet weak var locationFilterViewHeight                     : NSLayoutConstraint!

    // MARK: - Variable
    var eventExpandVC                                           : WUEventExpandViewController!
    var eventListVC                                             : WUEventListViewController!
    var eventCategoryVC                                         : WUEventCategoriesViewController!
    var eventListData                                           : EventListData!
    var eventCategory : WUEventCategories!
    var index = 0
    var isFromSearchORPlayVideoVC : Bool = false
    let offset = CGPoint.init(x: 0, y:0)
    var isShowBackButton = false
    
    // Geolocation Filter
    private var keyboardHeight                  : Int!
    private var indexOfSelectedRadius           : Int!
    private var arraySearchSuggestion           : [WUVenueSuggestion] = []
    private var citiesAutocompleteList          : WUCityList!
    private var geolocationFilterData           : WUGeolocationFilterData!
    private var cityLocationData                : WUCityLocationData!
    private var autocompleteTable               : UITableView?
    private var isCitySelected                  : Bool = false
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetUp()
       //self.initialDataSetup()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.buttonSearchSmallView.isSelected = false
        self.buttonSearchExpandView.isSelected = false
        
        if isNeedUpdateLocationData(){
            initialDataSetup()
        }
        
//        if self.isFromSearchORPlayVideoVC == true {
            if self.buttonEventExpnad.isSelected == true{
                if self.eventExpandVC.verticalContentOffset != nil {
                    DispatchQueue.main.async {
                       Utill.printInTOConsole(printData:"*** \(self.eventExpandVC.verticalContentOffset)")
                        let offset = CGPoint.init(x: 0, y:self.eventExpandVC.verticalContentOffset)
                        self.eventExpandVC.tableViewEvent.setContentOffset(offset, animated: false)
                    }
                }
            } else if self.buttonEventList.isSelected == true {
                
                if self.eventListVC.verticalContentOffset != nil {
                    
                    self.eventListVC.arrEventList = self.prepareArrayEventList()
                    DispatchQueue.main.async {
                       Utill.printInTOConsole(printData:"*** \(self.eventListVC.verticalContentOffset)")
                        let offset = CGPoint.init(x: 0, y:self.eventListVC.verticalContentOffset)
                        self.eventListVC.tableViewEventList.setContentOffset(offset, animated: false)
                    }
                }
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
  
           self.hidePickerView()
           self.hideAutocompleteCitiesList()
       }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp()
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        if isShowBackButton {
            backButton.isHidden = false
        } else {
            backButton.isHidden = true
        }
        self.setSelectedButton(buttonToSelect: self.buttonEventExpnad)
        self.calendarContainerView.dropShadow(color: UIColor.gray, opacity: 1.0, offSet:CGSize(width: 0.0, height: 2.0), radius: 2.0, scale:true)
        self.segmentViewHeightCont.constant = 40.0
        self.segmentStackViewBottomCont.constant = 2.0
        self.installCalendar()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.containerTopSpace.constant = self.calendarContainerView.frame.size.height
        })
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
             if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                   keyboardHeight = Int(keyboardSize.height)
             }

       }
    
    private func initialDataSetup(){
        
        self.geolocationFilterData = GlobalShared.geolocationFilterData
        self.stupLocationFilterUI()
        self.locationTextField.font = UIFont(name: "Helvetica", size: 18)

        if self.eventExpandVC.selectedCalenderDate == nil
        {
            self.eventExpandVC.selectedCalenderDate = Date()
            self.eventListVC.selectedCalenderDate = Date()
            self.callWS_getEventList(forDate: Date())
        }
        else {
            self.callWS_getEventList(forDate: self.eventExpandVC.selectedCalenderDate)
        }
//        self.callWS_getEventCategories()
    }
    
    private func updateEventList(){
        self.callWS_getEventList(forDate: self.eventExpandVC.selectedCalenderDate)
    }
    
    private func installCalendar() {
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.appearance.selectionColor = .black
        self.calendarView.appearance.todayColor = .SearchBarYellowColor
        self.calendarView.appearance.titleTodayColor = .black
        self.calendarView.appearance.todaySelectionColor = .black
        self.calendarView.appearance.titleSelectionColor = .SearchBarYellowColor
        self.calendarView.appearance.headerTitleFont = UIFont.ProximaNovaMedium(16.0)
        self.calendarView.appearance.weekdayFont = UIFont.ProximaNovaRegular(10.0)
        self.calendarView.appearance.caseOptions = .weekdayUsesUpperCase
        self.calendarView.appearance.titleFont = UIFont.ProximaNovaThin(25)
        self.calendarView.appearance.headerDateFormat = "MMMM YYYY"
//        self.calendarView.appearance.caseOptions = .headerUsesUpperCase
        self.calendarView.headerHeight = 35.0
        self.calendarView.weekdayHeight = 30.0
        self.calendarView.placeholderType = .fillHeadTail
        self.calendarView.calendarHeaderView.backgroundColor = UIColor(hexString: "F4F4F4")
        self.calendarView.scope = .week
        self.calendarView.select(Date())
        self.calendarView.calendarHeaderView.scrollEnabled = false
        self.setPrevNextMonthforDate(date: self.calendarView.currentPage)
        Utill.drawLineFromPoint(start: CGPoint(x: 0, y: self.calendarView.headerHeight), toPoint: CGPoint(x: self.view.frame.width, y: self.calendarView.headerHeight), ofColor: UIColor(hexString: "979797"), inView: self.calendarView.calendarHeaderView)
    }
    
    // MARK: - Webservice calls
     func callWS_getEventList(forDate date : Date)
     {
        WEB_API.call_api_GetEventList(user: GlobalShared.user, categoryId: "0", date: date, geolocationFilterData: self.geolocationFilterData) { (response, success, message) in
            Utill.printInTOConsole(printData: "\(String(describing: response))")
            self.eventExpandVC.tableViewEvent.setContentOffset(self.offset, animated: false)
            self.eventListVC.tableViewEventList.setContentOffset(self.offset, animated: false)
            if success == true {
                let data = try! JSONSerialization.data(withJSONObject: response?.dictionaryObject ?? [:], options: [])
                self.eventListData = try! JSONDecoder().decode(EventListData.self, from: data)
                
                Utill.printInTOConsole(printData:"response -> : \(String(describing: self.eventListData) )")

                let todayEvents = self.eventListData.TodayEvents.Events
                for event in todayEvents {
                    if let endDate = event.EndDate.dateFromCustomString(withFormat: "MM/dd/yyyy HH:mm a") {
                        if endDate.timeIntervalSince1970 > Date().timeIntervalSince1970 {
                            self.eventListData.UpComingEvents.Events = self.eventListData.UpComingEvents.Events.filter(){$0 != event}
                        }
                    }
                }
                
                // remove Events Without Latitude and Longitude
                self.eventListData.TodayEvents.Events = self.removeEventsWithoutDistance(self.eventListData.TodayEvents.Events)
                self.eventListData.TomorrowEvents.Events = self.removeEventsWithoutDistance(self.eventListData.TomorrowEvents.Events)
                self.eventListData.ThisWeekEvents.Events = self.removeEventsWithoutDistance(self.eventListData.ThisWeekEvents.Events)
                self.eventListData.UpComingEvents.Events = self.removeEventsWithoutDistance(self.eventListData.UpComingEvents.Events)
                self.eventListData.MoreEvents.Events = self.removeEventsWithoutDistance(self.eventListData.MoreEvents.Events)

                Utill.saveHomeBannerModel(self.eventListData.LiveCamBanners)
                let arrDateWiseEvents = self.prepareArrayEventList()
                self.eventExpandVC.arrEventList = arrDateWiseEvents
                self.eventListVC.arrEventList = arrDateWiseEvents
                
            } else {
//                if response != nil {
                    self.eventExpandVC.arrEventList = []
                    self.eventListVC.arrEventList = []
//                }
            }
        }
    }
    
    private func removeEventsWithoutDistance(_ events : [WUEvent]) -> [WUEvent]
    {
        var tempEvents = [WUEvent]()
        for event in events {
            if event.Latitude != "0.0000" && event.Longitude != "0.0000" {
                tempEvents.append(event)
            }
        }
        
        return tempEvents
    }
    
     func callWS_getEventCategories()
     {
        WEB_API.call_api_GetEventCategories{ (response, success, message) in
             Utill.printInTOConsole(printData: "\(response ?? "")")
            self.eventCategoryVC.tableViewEventCategory.setContentOffset(self.offset, animated: false)

            if success == true {
                let data = try! JSONSerialization.data(withJSONObject: (response!["EventCategory"]).arrayObject ?? [], options: [])
                let arrCategoris = try! JSONDecoder().decode([WUEventCategories].self, from: data)
                
                 self.eventCategoryVC.arrEventCategoryList = arrCategoris
            } else {
                self.eventCategoryVC.arrEventCategoryList = []
            }
        }
    }
    
    private func prepareArrayEventList() -> [WUDateWiseEvents]
    {
        var arrEventList = [WUDateWiseEvents]()
        
        arrEventList.append(self.eventListData.TodayEvents)
        arrEventList.append(self.eventListData.TomorrowEvents)
        arrEventList.append(self.eventListData.ThisWeekEvents)
        arrEventList.append(self.eventListData.UpComingEvents)
        arrEventList.append(self.eventListData.MoreEvents)
        
        return arrEventList
    }
    
    // MARK: - Action Methods
    
    @IBAction func radiusButtonAction(_ sender: UIButton) {
        if locationFilterViewHeight.constant < 50{
           showPickerView()
        }else{
            hidePickerView()
        }
    }
    
    @IBAction func locationRadiusDoneButtonAction(_ sender: UIButton) {
         hidePickerView()
         let lastIndexOfRadiusValueOptions = WUText.WUSearchFilterNames().radiusValueOptions.count - 1
         locationRadius.text = WUText.WUSearchFilterNames().radiusValueOptions[(self.indexOfSelectedRadius ?? lastIndexOfRadiusValueOptions)] + " m"
         let radiusString = WUText.WUSearchFilterNames().radiusValueOptions[(self.indexOfSelectedRadius ?? lastIndexOfRadiusValueOptions)]
         self.geolocationFilterData.Radius = radiusString.contains("+") ? 90 : Int(radiusString)!
         call_api_SaveLatLongDetails()
     }
    
    @IBAction func nearbyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.hidePickerView()
        self.geolocationFilterData.IsNearBy = true
        self.geolocationFilterData.Latitude = String(GlobalShared.currentLocationCoordinate.latitude)
        self.geolocationFilterData.Longitude = String(GlobalShared.currentLocationCoordinate.longitude)
        self.locationTextField.text = Text.WUSearchFilterNames().nearby
        self.geolocationFilterData.CityData.City = Text.WUSearchFilterNames().nearby
        self.call_api_SaveLatLongDetails()
    }
    
    
    @IBAction func buttonBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSearchAction(_ sender: UIButton) {
        self.buttonSearchSmallView.isSelected = true
        self.buttonSearchExpandView.isSelected = true
        
        if self.buttonEventExpnad.isSelected == true {
            self.eventExpandVC.verticalContentOffset  = self.eventExpandVC.tableViewEvent.contentOffset.y
            Utill.printInTOConsole(printData: ":::\(String(describing: self.eventExpandVC.verticalContentOffset))")
        }else{
            self.eventListVC.verticalContentOffset  = self.eventListVC.tableViewEventList.contentOffset.y
            Utill.printInTOConsole(printData:":::\(String(describing: self.eventListVC.verticalContentOffset))")
        }
        self.performSegue(withIdentifier: Text.Segue.eventToEventSearchVC, sender: nil)
    }
    
    @IBAction func buttonEventExpandAction(_ sender: UIButton) {
        self.setSelectedButton(buttonToSelect: sender)
    }
    
    @IBAction func buttonEventListAction(_ sender: UIButton) {
        self.setSelectedButton(buttonToSelect: sender)
    }
    
    @IBAction func buttonEventCategoryAction(_ sender: UIButton) {
        if sender.isSelected == false{
            self.callWS_getEventCategories()
        }
        self.setSelectedButton(buttonToSelect: sender)
    }
    
    @IBAction func buttonNextMonthAction(_ sender: UIButton) {
        let gregorian = Calendar(identifier: .gregorian)
        let date = gregorian.date(byAdding: .month, value: +1, to: self.calendarView.currentPage)
        self.calendarView.setCurrentPage(date!, animated: true)
    }
    
    @IBAction func buttonPrevMonthAction(_ sender: UIButton) {
        let gregorian = Calendar(identifier: .gregorian)
        let date = gregorian.date(byAdding: .month, value: -1, to: self.calendarView.currentPage)
        self.calendarView.setCurrentPage(date!, animated: true)
    }
    
    @IBAction func buttonToggleCalendarAction(sender: AnyObject) {
        if self.calendarView.scope == .month {
            (sender as! UIButton).isSelected = false
            self.calendarBottomView.backgroundColor = .white
            self.calendarView.setScope(.week, animated: true)
        } else {
            (sender as! UIButton).isSelected = true
            self.calendarBottomView.backgroundColor = UIColor(hexString: "F4F4F4")
            self.calendarView.setScope(.month, animated: true)
        }
    }
    
    private func setSelectedButton(buttonToSelect : UIButton){
        self.buttonEventExpnad.isSelected = false
        self.buttonEventList.isSelected = false
        self.buttonEventCategories.isSelected = false
        buttonToSelect.isSelected = true
        
        self.topBarSmallView.isHidden = false
        self.topBarExpandView.isHidden = true
        
        self.containerViewEventExpand.isHidden = true
        self.containerViewEventList.isHidden = true
        self.containerViewEventCategory.isHidden = true
        self.calendarContainerView.isHidden = false
        self.containerTopSpace.constant = self.calendarContainerView.frame.size.height
        if buttonToSelect == buttonEventExpnad{
            self.constraintExpandTopBarHeight.constant = self.TopBarExpandHeight
            self.topBarSmallView.isHidden = true
            self.topBarExpandView.isHidden = false
            self.containerViewEventExpand.isHidden = false

        }else if buttonToSelect == buttonEventList{
            self.constraintExpandTopBarHeight.constant = self.TopBarSmallHeight
            self.labelTitleEventList.text = Text.Label.text_EventList
            self.containerViewEventList.isHidden = false
        }else{
            self.constraintExpandTopBarHeight.constant = self.TopBarSmallHeight
            self.containerTopSpace.constant = 0.0
            self.calendarContainerView.isHidden = true
            self.labelTitleEventList.text = Text.Label.text_EventCategoties
            self.containerViewEventCategory.isHidden = false
        }
    }

    private func manageSegmentAnimationHeader(scrollVW : CGFloat){
        if scrollVW > 0 {
            self.segmentStackViewBottomCont.constant = 0.0
            self.segmentViewHeightCont.constant = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                if scrollVW <= 0 {
                    self.segmentViewHeightCont.constant = 40.0
                    self.segmentStackViewBottomCont.constant = 2.0
                    self.view.layoutIfNeeded()
                }
            })
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == Text.Segue.evenExpandVC {
            self.eventExpandVC = segue.destination as! WUEventExpandViewController
            self.eventExpandVC.delegate = self
        }else if segue.identifier == Text.Segue.eventListVC {
            self.eventListVC = segue.destination as! WUEventListViewController
            self.eventListVC.delegate = self
        }else if segue.identifier == Text.Segue.eventCategoryVC{
            self.eventCategoryVC = segue.destination as! WUEventCategoriesViewController
            self.eventCategoryVC.delegate = self
        }else if segue.identifier ==  Text.Segue.eventHomeToSelectedCategory{
            let eventSelectedCategoryVC = segue.destination as! WUEventSelectedCategoryViewController
            if let categoryObj = sender as? WUEventCategories {
                eventSelectedCategoryVC.selectedEventCategory = categoryObj
            }
        }else if segue.identifier == Text.Segue.eventHomeToEventDetail{
            let eventProfileVC = segue.destination as! WUEventProfileViewController
            if self.buttonEventExpnad.isSelected == true {
                self.eventExpandVC.verticalContentOffset  = self.eventExpandVC.tableViewEvent.contentOffset.y
               Utill.printInTOConsole(printData:":::\(self.eventExpandVC.verticalContentOffset)")
            }else{
                self.eventListVC.verticalContentOffset  = self.eventListVC.tableViewEventList.contentOffset.y
               Utill.printInTOConsole(printData:":::\(self.eventListVC.verticalContentOffset)")
            }
            let eventProfileObj = sender as! String
            eventProfileVC.selectedEventId = eventProfileObj
        }
    }
}

 // MARK: - WUEventCategoriesViewControllerDelegate
extension WUEventHomeViewController : WUEventCategoriesViewControllerDelegate{
    func didSelectCategoryTableCell(cell: WUTitleTableCell, eventObj: WUEventCategories) {
        self.performSegue(withIdentifier: Text.Segue.eventHomeToSelectedCategory, sender: eventObj)
    }
    func animateHeaderView(scrollview: CGFloat) {
        self.manageSegmentAnimationHeader(scrollVW: scrollview)
    }
    func didSelectButtonNoResultAction() {
//        self.eventCategoryVC.verticalContentOffset = 0
        self.callWS_getEventCategories()
    }
}

// MARK: - WUEventListViewControllerDelegate
extension WUEventHomeViewController : WUEventListViewControllerDelegate{
   
    func didSelectListTableCell(cell: UITableViewCell, eventSelectedCategoryId : String) {
//        self.isFromSearchORPlayVideoVC = false
        self.performSegue(withIdentifier: Text.Segue.eventHomeToEventDetail, sender: eventSelectedCategoryId)
    }
    func animateSegmentHeaderView(scrollview: CGFloat) {
        self.manageSegmentAnimationHeader(scrollVW: scrollview)
    }
    func eventVCLiveCamButtonClicked(cell: WUEventTabelCell, withEvent event: WUEvent) {
        self.eventExpandVC.verticalContentOffset  = self.eventExpandVC.tableViewEvent.contentOffset.y
        Utill.goToLivecamProfile(viewController: self, withLivecamM: event.LiveCamsURL[0])

       /* if let vc = UIStoryboard.home.get(WUPlayLiveCamViewController.self){
            self.eventExpandVC.verticalContentOffset  = self.eventExpandVC.tableViewEvent.contentOffset.y
            Utill.printInTOConsole(printData : ":::\(self.eventExpandVC.verticalContentOffset)")
            vc.hidesBottomBarWhenPushed = true
            vc.playLiveCamArray = event.LiveCamsURL
            self.navigationController?.pushViewController(vc, animated: false)
        }*/
    }
    func didSelectButtonNoResult() {
         self.eventExpandVC.verticalContentOffset = 0
         self.eventListVC.verticalContentOffset = 0
       self.initialDataSetup()
    }
}

 // MARK: - FSCalendar
extension WUEventHomeViewController : FSCalendarDelegate, FSCalendarDataSource
{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool)
    {
        self.calendarViewHeight.constant = bounds.height
        self.containerTopSpace.constant = self.calendarViewHeight.constant + 35
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date) -> Bool {
        return true
            //calendar.isDate(date, equalTo: calendar.currentPage, to: FSCalendarUnit.month)
    }
    
 
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
      self.setPrevNextMonthforDate(date: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
       
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        var dateToSend = date
        if date.isToday() {
            dateToSend = Date()
        }
        self.eventExpandVC.selectedCalenderDate = dateToSend
        self.eventListVC.selectedCalenderDate = dateToSend
        if self.calendarView.scope == .month{
            self.buttonToggleCalendarAction(sender: self.buttonToggleCalendar)
        }
        self.callWS_getEventList(forDate: dateToSend)
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    private func setPrevNextMonthforDate(date : Date){
        
        let FinalDateToShowMonth = Calendar.current.date(byAdding: .day, value: 3, to: date)
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: FinalDateToShowMonth!)
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: FinalDateToShowMonth!)
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let preMonth = dateFormatter.string(from: previousMonth!)
        self.buttonPrevMonth.setTitle(preMonth.uppercased(), for: .normal)
        
        let neMonth = dateFormatter.string(from: nextMonth!)
        self.buttonNextMonth.setTitle(neMonth.uppercased(), for: .normal)
    }
    
}

//MARK: - Picker

extension WUEventHomeViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString(string:  WUText.WUSearchFilterNames().radiusValueOptions[row] + " miles", attributes: [NSAttributedStringKey.foregroundColor : UIColor.LightYellowAppColor])
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.locationRadiusPickerOutlet{
            return WUText.WUSearchFilterNames().radiusValueOptions.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView == self.locationRadiusPickerOutlet{
            return WUText.WUSearchFilterNames().radiusValueOptions[row] + " miles"
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         self.indexOfSelectedRadius = row
    }
    
}

//MARK: - TextFieldDelegate
extension WUEventHomeViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.view.endEditing(true)
        self.hidePickerView()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.hidePickerView()
        self.hideAutocompleteCitiesList()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard textField.text!.count >= 2  else {return true}

        WEB_API.call_api_GetListOfCities(strLocationKey: (textField.text! + string)) { (response, success, message) in
  
            let data = try! JSONSerialization.data(withJSONObject: response?.dictionaryObject ?? [:], options: [])
            self.citiesAutocompleteList = try! JSONDecoder().decode(WUCityList.self, from: data)
           
            _ = self.autocompleteTable == nil ? self.showAutocompleteCitiesList():nil
            
            self.autocompleteTable?.reloadData()
        }
        return true
    }
    
    private func showAutocompleteCitiesList(){
        self.isCitySelected = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false

    
        let height = CGFloat(keyboardHeight)
        let width = locationFilterCityView.frame.width
        let x = locationFilterCityView.frame.minX
        let y: CGFloat = self.view.frame.size.height - (pickerView.superview!.frame.height + height) + 1
        
        autocompleteTable = UITableView(frame: CGRect(x: x, y: y, width: width, height: height), style: UITableViewStyle.plain)
        autocompleteTable?.backgroundColor = .DarkGreyAppColor
        autocompleteTable?.separatorStyle = .none
        autocompleteTable?.delegate = self
        autocompleteTable?.dataSource = self
        autocompleteTable?.layer.cornerRadius = 10
        
        if #available(iOS 11.0, *) {
            autocompleteTable?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }

        
        
        self.view.addSubview(autocompleteTable!)
    }
    
    
    private func hideAutocompleteCitiesList(){
        autocompleteTable?.removeFromSuperview()
        autocompleteTable = nil
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
    }
 
}

extension WUEventHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if tableView == autocompleteTable{
            return citiesAutocompleteList?.predictions.count ?? 0
            }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == autocompleteTable{
            let cell = UITableViewCell()
            let citiesAutocompleteArray = citiesAutocompleteList?.predictions.map({$0.nameOfCityAndState}) ?? []
                  
            cell.backgroundColor = .DarkGreyAppColor
            cell.textLabel?.text = citiesAutocompleteArray[indexPath.row]
            cell.textLabel?.textColor = .LightYellowAppColor
            cell.imageView?.image = UIImage(named: "location - yellow bright")
                  
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == autocompleteTable{
            self.view.endEditing(true)
            self.isCitySelected = true
            self.hidePickerView()
            self.hideAutocompleteCitiesList()
           
            var longName = ""
            var shortName = ""
            var fullName = ""
            
            if citiesAutocompleteList.predictions[indexPath.row].terms.count == 1{
                longName = citiesAutocompleteList.predictions[indexPath.row].terms[0].value
                fullName = "\(longName)"
            }else{
                longName = citiesAutocompleteList.predictions[indexPath.row].terms[0].value
                shortName = citiesAutocompleteList.predictions[indexPath.row].terms[1].value
                fullName = "\(longName), \(shortName)"
            }
            
            self.locationTextField.text = fullName
            self.geolocationFilterData.IsNearBy = false
            self.geolocationFilterData.CityData.City = longName
            self.geolocationFilterData.CityData.State.ShortName = shortName
            self.call_api_GetLocationOfCity(strPlace_id: citiesAutocompleteList.predictions[indexPath.row].place_id)
        }
    }
}

// MARK: - Geolocation Filter View methods

extension WUEventHomeViewController{
    
    private func showPickerView(){
        self.view.endEditing(true)
        self.locationFilterDistanceView.borderColor = .LightYellowAppColor

        self.showLocatinRadiusImage.image = UIImage(named: "arrow - up - yellow dark") // "▲"
        self.locationRadiusPickerOutlet.selectRow((indexOfSelectedRadius ?? 1), inComponent: 0, animated: false)
        pickerView.isHidden = false
        locationFilterViewHeight.constant = locationFilterViewHeight.constant*5
    }
    
    private func hidePickerView(){
        self.view.endEditing(true)
        pickerView.isHidden = true
        self.locationFilterDistanceView.borderColor = .DarkYellowAppColor
        self.showLocatinRadiusImage.image = UIImage(named: "arrow - down - yellow dark")  // "▼"
        locationFilterViewHeight.constant = 45
        
        if locationTextField.text!.count < 3 || !isCitySelected{
            
            let cityName = GlobalShared.geolocationFilterData.IsNearBy ? Text.WUSearchFilterNames().nearby : GlobalShared.geolocationFilterData.FullName
            locationTextField.text = cityName
        }
    }
    
    private func stupLocationFilterUI(){
        guard GlobalShared.geolocationFilterData != nil else {return}
        
        let cityName = GlobalShared.geolocationFilterData.IsNearBy ? Text.WUSearchFilterNames().nearby : GlobalShared.geolocationFilterData.FullName
        self.locationTextField.text = cityName
        let radius = GlobalShared.geolocationFilterData.Radius
        self.locationRadius.text = radius == 90 ? "+\(radius) m": "\(radius) m"
    }
    
    private func isNeedUpdateLocationData() -> Bool{
        guard GlobalShared.geolocationFilterData != nil else {return false}

         if ((self.locationTextField.text != GlobalShared.geolocationFilterData.FullName) && (!GlobalShared.geolocationFilterData.IsNearBy)){
             return true
         }else if !(self.locationRadius.text?.containsIgnoringCase(find: String(GlobalShared.geolocationFilterData.Radius)))!{
             return true
         }else if (GlobalShared.geolocationFilterData.IsNearBy && self.locationTextField.text != Text.WUSearchFilterNames().nearby){
             return true
         }else{
             return false
         }
         
     }
    

    private func call_api_GetLocationOfCity(strPlace_id: String){

        WEB_API.call_api_GetLocationOfCity(strPlace_id: strPlace_id) { (response, success, message) in
            
            let data = try! JSONSerialization.data(withJSONObject: response?["result"].dictionaryObject ?? [:], options: [])
            self.cityLocationData = try! JSONDecoder().decode(WUCityLocationData.self, from: data)
            
            self.geolocationFilterData.Latitude = String(self.cityLocationData.geometry.location.lat)
            self.geolocationFilterData.Longitude = String(self.cityLocationData.geometry.location.lng)
            self.geolocationFilterData.IsNearBy = false
            
            self.call_api_SaveLatLongDetails()
        }
    }
    
    private func call_api_SaveLatLongDetails(){
         
        WEB_API.call_api_SaveLatLongDetails(user: GlobalShared.user,
                                             latitude: geolocationFilterData.Latitude,
                                             longitude: geolocationFilterData.Longitude,
                                             radius: String(geolocationFilterData.Radius),
                                             isNearBy: geolocationFilterData.IsNearBy) { (response,status,message) in
                                                
            GlobalShared.geolocationFilterData = self.geolocationFilterData
            self.updateEventList()
         }
     }
}
