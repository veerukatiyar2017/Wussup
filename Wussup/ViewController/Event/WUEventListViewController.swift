//
//  WUEventListViewController.swift
//  Wussup
//
//  Created by MAC26 on 24/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WUEventListViewControllerDelegate : class{
    func didSelectListTableCell(cell : UITableViewCell , eventSelectedCategoryId : String)
    func animateSegmentHeaderView(scrollview: CGFloat)
    func eventVCLiveCamButtonClicked(cell : WUEventTabelCell, withEvent event : WUEvent)
    func didSelectButtonNoResult()
    
}
extension WUEventListViewControllerDelegate {
    func didSelectListTableCell(cell : UITableViewCell , eventSelectedCategoryId : String){
        
    }
    func animateSegmentHeaderView(scrollview: CGFloat){
        
    }
    func eventVCLiveCamButtonClicked(cell : WUEventTabelCell, withEvent event : WUEvent){
        
    }
    func didSelectButtonNoResult(){
        
    }
}

class WUEventListViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var buttonGoToTop        : UIButton!
    @IBOutlet  weak var tableViewEventList          : UITableView!
    @IBOutlet private weak var buttonNoResults      : UIButton!
    
    //MARK: - Variables
    var verticalContentOffset : CGFloat!
    weak var delegate               : WUEventListViewControllerDelegate?
    var selectedCalenderDate        : Date!
    var arrEventList                : [WUDateWiseEvents] = [] {
        didSet{
            self.manageNoResultLabel()
        }
    }
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        self.buttonGoToTop.isHidden = true
        self.buttonGoToTop.isSelected = false
        self.tableViewEventList.isHidden = true
        self.buttonNoResults.setTitle(Text.Message.noDataFound, for: .normal)
        self.tableViewEventList.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUTitleTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUTitleTableCell()))
        self.tableViewEventList.contentInset = UIEdgeInsetsMake(00, 0, -20, 0);
        self.tableViewEventList.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUNoEventTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUNoEventTableCell()))
    }
    
    private func manageNoResultLabel(){
        if self.arrEventList.count > 0 {
            self.tableViewEventList.isHidden = false
            self.buttonNoResults.isHidden = true
            if self.tableViewEventList.contentSize.height  > (UIScreen.main.bounds.height - 77){
                self.buttonGoToTop.isHidden = false
            }else{
                self.buttonGoToTop.isHidden = true
                self.buttonGoToTop.isSelected = false
            }
        }else{
            self.buttonNoResults.isHidden = false
            self.tableViewEventList.isHidden = true
            self.buttonGoToTop.isHidden = true
        }
        self.tableViewEventList.reloadData()
    }
    
    // MARK: - Action Methods
    @IBAction func buttonNoResultsAction(_ sender: Any) {
        if let delegate = self.delegate{
            delegate.didSelectButtonNoResult()
        }
    }
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.buttonGoToTop.isSelected = true
        self.tableViewEventList.setContentOffset(CGPoint.zero, animated: true)
        
        if let delegate = self.delegate {
            delegate.animateSegmentHeaderView(scrollview: -5.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.buttonGoToTop.isSelected = false
            })
        }
    }
}

//MARK: -  UITableView
extension WUEventListViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrEventList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = WUEventSectionHeaderView.instanceFromNib()
        headerView.frame = CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 100.0))
        let dateWiseEvents = self.arrEventList[section]
        headerView.dateWiseEvent = dateWiseEvents
        switch section {
        case 0:
            if self.selectedCalenderDate.isToday(){
                headerView.labelTitle.text = Text.Label.text_Today
            }else if self.selectedCalenderDate.isTommorow(){
                headerView.labelTitle.text = Text.Label.text_Tomorrow
            }else{
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
        return self.arrEventList[section].Events.count > 0 ? self.arrEventList[section].Events.count : 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.arrEventList[indexPath.section].Events .count > 0 {
            return UITableViewAutomaticDimension
        }else{
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.arrEventList[indexPath.section].Events .count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUTitleTableCell()), for: indexPath)as! WUTitleTableCell
            cell.labelTitle.textColor = UIColor.blackColor
            
            cell.selectionStyle = .none
            cell.event = self.arrEventList[indexPath.section].Events[indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUNoEventTableCell())) as! WUNoEventTableCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableViewEventList.cellForRow(at: indexPath)
        if !(cell is WUNoEventTableCell) {
            let cell = self.tableViewEventList.cellForRow(at: indexPath) as! WUTitleTableCell
            cell.labelTitle.textColor = UIColor.AddToCalenderSelectedColor
            if let delegate = self.delegate {
                delegate.didSelectListTableCell(cell: cell, eventSelectedCategoryId:self.arrEventList[indexPath.section].Events[indexPath.row].ID )
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.buttonGoToTop.isSelected == false{
            if self.tableViewEventList.contentSize.height  > (UIScreen.main.bounds.height - 77){
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
