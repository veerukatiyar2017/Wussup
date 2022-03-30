//
//  WUEventExpandViewController.swift
//  Wussup
//
//  Created by MAC26 on 24/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUEventExpandViewController: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet private weak var buttonGoToTop        : UIButton!
    @IBOutlet  weak var tableViewEvent              : UITableView!
    @IBOutlet private weak var buttonNoResults      : UIButton!
    
    //MARK: - Variables
    var verticalContentOffset : CGFloat!
    weak var delegate           : WUEventListViewControllerDelegate?
    var selectedCalenderDate    : Date!
    var arrEventList            : [WUDateWiseEvents] = []{
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
       self.manageSliderTimerToStartAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.manageSliderTimerTOStop()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        self.buttonGoToTop.isHidden = true
        self.buttonGoToTop.isSelected = false
        self.tableViewEvent.isHidden = true
        self.buttonNoResults.setTitle(Text.Message.noDataFound, for: .normal)
        self.tableViewEvent.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUNoEventTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUNoEventTableCell()))
        self.tableViewEvent.contentInset = UIEdgeInsetsMake(00, 0, -20, 0);
    }
    
    private func manageNoResultLabel(){
        if self.arrEventList.count > 0 {
            self.tableViewEvent.isHidden = false
            self.buttonNoResults.isHidden = true
            if self.tableViewEvent.contentSize.height  > (UIScreen.main.bounds.height - 125){
                self.buttonGoToTop.isHidden = false
            }else{
                self.buttonGoToTop.isHidden = true
                self.buttonGoToTop.isSelected = false
            }
        }else{
            self.buttonNoResults.isHidden = false
            self.tableViewEvent.isHidden = true
            self.buttonGoToTop.isHidden = true
        }
        self.tableViewEvent.reloadData()
    }
    
    func manageSliderTimerTOStop(){
        if self.arrEventList.count > 0 {
            if self.selectedCalenderDate.isToday(){
                if let cell = self.tableViewEvent.cellForRow(at: IndexPath(row: 0, section: 0)) as? WUEventTabelCell
                {
                    cell.stopTimerForLocalPromotion()
                }
            }
            if self.selectedCalenderDate.isTommorow(){
                if let cell = self.tableViewEvent.cellForRow(at: IndexPath(row: 0, section: 0)) as? WUEventTabelCell
                {
                    cell.stopTimerForLocalPromotion()
                }
            }
        }
    }
    
    func manageSliderTimerToStartAnimation(){
        if self.arrEventList.count > 0 {
            if self.selectedCalenderDate.isToday(){
                if let cell = self.tableViewEvent.cellForRow(at: IndexPath(row: 0, section: 0)) as? WUEventTabelCell
                {
                    cell.startTimerForchangeLocalPromotionImageAnimation()
                }
            }
            if self.selectedCalenderDate.isTommorow(){
                if let cell = self.tableViewEvent.cellForRow(at: IndexPath(row: 0, section: 0)) as? WUEventTabelCell
                {
                    cell.startTimerForchangeLocalPromotionImageAnimation()
                }
            }
        }
    }
    
    
    // MARK: - Action Methods
    @IBAction func buttonNoResultsAction(_ sender: Any) {
        if let delegate = self.delegate{
            delegate.didSelectButtonNoResult()
        }
    }
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.buttonGoToTop.isSelected = true
        self.tableViewEvent.setContentOffset(CGPoint.zero, animated: true)
        
        if let delegate = self.delegate {
            delegate.animateSegmentHeaderView(scrollview: -5.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.buttonGoToTop.isSelected = false
            })
        }
    }
}

// MARK: - TableView
extension WUEventExpandViewController : UITableViewDataSource ,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrEventList.count
    }
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            if self.selectedCalenderDate.isWeekendDays()
            {
                return 1
            }
        }
        else if section == 1 {
            if self.selectedCalenderDate.isWeekendDays(){
                return 1
            }
        }
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
            }
            else if self.selectedCalenderDate.isTommorow(){
                headerView.labelTitle.text = Text.Label.text_Tomorrow
            }
            else {
                headerView.labelTitle.text = Date.dateObject(dateStr: dateWiseEvents.EventDate)?.stringDate
            }
            break
            
        case 1:
            if self.selectedCalenderDate.isToday(){
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
        if section == 0
        {
            if self.selectedCalenderDate.isWeekendDays()
            {
                return 0
            }
        }
        else if section == 1 {
            if self.selectedCalenderDate.isWeekendDays(){
                return 0
            }
        }
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
        }else{
            return 50.0
        }
    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let cell = self.tableViewEvent.cellForRow(at: indexPath) as! WUTitleTableCell
    //        if let delegate = self.delegate {
    //            delegate.didSelectListTableCell(cell: cell, eventSelectedCategoryId:self.arrEventList[indexPath.section].Events[indexPath.row].CategoryID )
    //        }
    //    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        if let localCell = cell as? WUEventTabelCell
//        {
//            if self.selectedCalenderDate.isToday() || self.selectedCalenderDate.isTommorow(){
//                localCell.startTimerForchangeLocalPromotionImageAnimation()
//                localCell.updateImage()
//            }
//            Utill.printInTOConsole(printData: "WULocalPromotionTableCell**/*/*/ willDisplay")
//        }
//    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if let localCell = cell as? WUEventTabelCell
//        {
//            if self.selectedCalenderDate.isTommorow() ||  self.selectedCalenderDate.isToday(){
//                localCell.stopTimerForLocalPromotion()
//            }
//            Utill.printInTOConsole(printData: "WULocalPromotionTableCell didEndDisplaying")
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.buttonGoToTop.isSelected == false{
            if self.tableViewEvent.contentSize.height  > (UIScreen.main.bounds.height - 125){
                Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
                if let delegate = self.delegate {
                    delegate.animateSegmentHeaderView(scrollview: scrollView.contentOffset.y)
                }
            }
        }else {
            if let superView = self.parent as? WUEventHomeViewController {
                UIView.animate(withDuration: 0.3, animations: {
                    if scrollView.contentOffset.y <= 0 {
                        superView.segmentViewHeightCont.constant = 40.0
                        superView.segmentStackViewBottomCont.constant = 2.0
                        self.view.layoutIfNeeded()
                    }
                })
            }
            self.buttonGoToTop.isHidden = true
            self.buttonGoToTop.isSelected = false
        }
    }
}

//MARK: - WUEventTabelCellDelegate
extension WUEventExpandViewController : WUEventTabelCellDelegate {
    func didSelectListTableCell(cell: WUEventTabelCell, eventSelectedCategoryId: String) {
        if let delegate = self.delegate {
            delegate.didSelectListTableCell(cell: cell, eventSelectedCategoryId:eventSelectedCategoryId )
        }
    }
    
    func eventTableCellLiveCamButtonClicked(cell: WUEventTabelCell, withEvent event: WUEvent) {
        //            self.performSegue(withIdentifier: Text.Segue.homeToplayLivecamVC, sender: (venueCategory as! WUVenueLiveCams).LiveCamURL)
        if let delegate = self.delegate {
            delegate.eventVCLiveCamButtonClicked(cell: cell, withEvent: event)
        }
    }
}
