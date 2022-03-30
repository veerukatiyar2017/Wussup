//
//  WUEventSearchResultViewController.swift
//  Wussup
//
//  Created by MAC219 on 6/13/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUEventSearchResultViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var calendarView                 : FSCalendar!
    @IBOutlet private weak var calendarContainerView        : UIView!
    @IBOutlet private weak var calendarBottomView           : UIView!
    @IBOutlet private weak var buttonNextMonth              : UIButton!
    @IBOutlet private weak var buttonPrevMonth              : UIButton!
    @IBOutlet private weak var calendarViewHeight           : NSLayoutConstraint!
    @IBOutlet private weak var buttonGoToTop                : UIButton!
    @IBOutlet private weak var tableViewEventSearchResult   : UITableView!
    @IBOutlet private weak var labelNoResults               : UILabel!
    @IBOutlet private weak var containerTopSpace            : NSLayoutConstraint!
    @IBOutlet private weak var buttonToggleCalendar         : UIButton!
    
    weak var delegate                               : WUEventListViewControllerDelegate?
    var selectedCalenderDate                        : Date! = Date()
    var eventListData                               : EventListData!
    
    var searchEvent : SearchVenueAndEventData!{
        didSet{
            self.callWS_getEventList(forDate: Date(), searchData: self.searchEvent)
        }
    }
    var arrEventList : [WUDateWiseEvents] = []{
        didSet{
            self.manageNoResultLabel()
        }
    }
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.eventListData != nil {
            self.callWS_getEventList(forDate: Date(), searchData: self.searchEvent)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        self.calendarContainerView.dropShadow(color: UIColor.gray, opacity: 1.0, offSet:CGSize(width: 0.0, height: 2.0), radius: 2.0, scale:true)
        self.installCalendar()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.containerTopSpace.constant = self.calendarContainerView.frame.size.height
        })
        
        self.buttonGoToTop.isHidden = true
        self.tableViewEventSearchResult.isHidden = true
        self.labelNoResults.text = Text.Message.noResultsFound
        self.tableViewEventSearchResult.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUNoEventTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUNoEventTableCell()))
        self.tableViewEventSearchResult.contentInset = UIEdgeInsetsMake(00, 0, -20, 0);
    }
    
    private func installCalendar(){
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
    
    private func manageNoResultLabel(){
        if self.arrEventList.count > 0 {
            self.tableViewEventSearchResult.isHidden = false
            self.labelNoResults.isHidden = true
        }else{
            self.labelNoResults.isHidden = false
            self.tableViewEventSearchResult.isHidden = true
        }
        self.tableViewEventSearchResult.reloadData()
    }
    
    // MARK: - Webservice calls
    private func callWS_getEventList(forDate date : Date , searchData : SearchVenueAndEventData ){
        WEB_API.call_api_GetEventList(user: GlobalShared.user, categoryId: "0", date: date,searchData: searchData, geolocationFilterData: GlobalShared.geolocationFilterData) { (response, success, message) in
           Utill.printInTOConsole(printData:"response: \(response ?? "")")
            
            if success == true{
                let data = try! JSONSerialization.data(withJSONObject: response?.dictionaryObject ?? [:], options: [])
                self.eventListData = try! JSONDecoder().decode(EventListData.self, from: data)
                let arrDateWiseEvents = self.prepareArrayEventList()
                self.arrEventList = arrDateWiseEvents
            }else{
                self.arrEventList = []
            }
        }
    }
    
    private func prepareArrayEventList() -> [WUDateWiseEvents]{
        var arrEventList = [WUDateWiseEvents]()
        arrEventList.append(self.eventListData.TodayEvents)
        arrEventList.append(self.eventListData.TomorrowEvents)
        arrEventList.append(self.eventListData.ThisWeekEvents)
        arrEventList.append(self.eventListData.UpComingEvents)
        arrEventList.append(self.eventListData.MoreEvents)
        return arrEventList
    }
    
    // MARK: - Action Methods
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
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.tableViewEventSearchResult.setContentOffset(CGPoint.zero, animated: true)
    }
}

// MARK: - TableView
extension WUEventSearchResultViewController : UITableViewDataSource ,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrEventList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = WUEventSectionTitleView.instanceFromNib()
        headerView.frame = CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 40.0))
        let dateWiseEvents = self.arrEventList[section]
        switch section {
        case 0:
            if self.selectedCalenderDate.isToday(){
                headerView.labelTitle.text = Text.Label.text_Today
            }else{
                headerView.labelTitle.text = Date.dateObject(dateStr: dateWiseEvents.EventDate)?.stringDate
            }
            break
            
        case 1:
            if self.selectedCalenderDate.isFriday() {
                if self.selectedCalenderDate.isInThisWeek(){
                    headerView.labelTitle.text = Text.Label.text_ThisWeekend
                }else if self.selectedCalenderDate.isInNexWeek(){
                    headerView.labelTitle.text = Text.Label.text_NextWeekend
                }else{
                    headerView.labelTitle.text = Text.Label.text_Weekend
                }
            }else if self.selectedCalenderDate.isToday(){
                headerView.labelTitle.text = Text.Label.text_Tomorrow
            }else{
                headerView.labelTitle.text = Date.dateObject(dateStr: dateWiseEvents.EventDate)?.stringDate
            }
            break
            
        case 2:
            if self.selectedCalenderDate.isToday(){
                headerView.labelTitle.text = Text.Label.text_ThisWeekend
            }else{
                headerView.labelTitle.text = "\(self.selectedCalenderDate.stringDate!) + \(Text.Label.text_Weekend)"
            }
            break
            
        case 3:
            if self.selectedCalenderDate.isToday(){
                headerView.labelTitle.text = Text.Label.text_ComingUp
            }else{
                headerView.labelTitle.text = "\(self.selectedCalenderDate.stringDate!) + \(Text.Label.text_ComingSoon)"
            }
            break
            
        case 4:
            headerView.labelTitle.text = Text.Label.text_More
            break
            
        default:
            break
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateWiseEvents = self.arrEventList[indexPath.section]
        if dateWiseEvents.Events.count > 0  {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUEventTabelCell())) as! WUEventTabelCell
            cell.dateWiseEvents = dateWiseEvents
            cell.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUNoEventTableCell())) as! WUNoEventTableCell
            cell.shadow = true
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dateWiseEvents = self.arrEventList[indexPath.section]
        if dateWiseEvents.Events.count > 0  {
            return 284.0 // UITableViewAutomaticDimension
        }
        else{
            return 50.0
        }
    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let cell = self.tableViewEvent.cellForRow(at: indexPath) as! WUTitleTableCell
    //        if let delegate = self.delegate {
    //            delegate.didSelectListTableCell(cell: cell, eventSelectedCategoryId:self.arrEventList[indexPath.section].Events[indexPath.row].CategoryID )
    //        }
    //    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
    }
}
// MARK: - WUEventTabelCellDelegate
extension WUEventSearchResultViewController : WUEventTabelCellDelegate {
    
    func didSelectListTableCell(cell: WUEventTabelCell, eventSelectedCategoryId: String) {
        if let delegate = self.delegate {
            delegate.didSelectListTableCell(cell: cell, eventSelectedCategoryId:eventSelectedCategoryId )
        }
    }
}

// MARK: - FSCalendar
extension WUEventSearchResultViewController : FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarViewHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date) -> Bool {
        return calendar.isDate(date, equalTo: calendar.currentPage, to: FSCalendarUnit.month)
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.setPrevNextMonthforDate(date: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        var dateToSend = date
        if date.isToday(){
            dateToSend = Date()
        }
        self.selectedCalenderDate = dateToSend
        if self.calendarView.scope == .month{
            self.buttonToggleCalendarAction(sender: self.buttonToggleCalendar)
        }
        self.callWS_getEventList(forDate: dateToSend, searchData: self.searchEvent)
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
