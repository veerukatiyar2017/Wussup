//
//  WUEventSelectedCategoryViewController.swift
//  Wussup
//
//  Created by MAC26 on 25/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUEventSelectedCategoryViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var labelNoResults           : UILabel!
    @IBOutlet private weak var buttonGoToTop            : UIButton!
    @IBOutlet private weak var labelTitle               : UILabel!
    @IBOutlet private weak var searchBar                : UISearchBar!
    @IBOutlet private weak var tableViewCategory        : UITableView!
    @IBOutlet private weak var textFieldSearch          : UITextField!
    @IBOutlet private weak var buttonSearchClose        : UIButton!
    @IBOutlet private weak var buttonSearch             : UIButton!
    @IBOutlet private weak var viewSearchHeightCont     : NSLayoutConstraint!
    
    //MARK: - Variables
    var selectedEventCategory       : WUEventCategories?
    var eventListData               : EventListData!
    var arrEventList                : [WUDateWiseEvents] = [] 
    var arrFilteredEventList        : [WUDateWiseEvents] = []
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetup()
        self.initialDataSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetup() {
        Utill.enableKeyboardManagement()
        self.buttonGoToTop.isHidden = true
        self.labelNoResults.text = Text.Message.noDataFound
        self.buttonSearchClose.isHidden = true
        
        self.tableViewCategory.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUTitleTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUTitleTableCell()))
        
        self.tableViewCategory.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUNoEventTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUNoEventTableCell()))
        
        self.tableViewCategory.contentInset = UIEdgeInsetsMake(00, 0, -20, 0);
        //        self.tableViewCategory.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewCategory.frame.size.width, height: 1))
        self.labelTitle.text = "\(self.selectedEventCategory?.Name.uppercased() ?? "") EVENTS"
        self.tableViewCategory.isHidden = false
        
        self.buttonSearch.isSelected = false
        self.viewSearchHeightCont.constant = 0.0
    }
    
    private func initialDataSetup(){
        self.callWS_getEventListForSelectedCategory()
    }
    
    private func manageNoResultLabel(){
        if self.arrFilteredEventList.count > 0 {
            self.tableViewCategory.isHidden = false
            self.buttonGoToTop.isHidden = false
            self.labelNoResults.isHidden = true
        }else{
            self.labelNoResults.isHidden = false
            self.tableViewCategory.isHidden = true
            self.buttonGoToTop.isHidden = true
        }
        self.tableViewCategory.reloadData()
    }
    
    // MARK: - Webservice calls
    private func callWS_getEventListForSelectedCategory(){
        WEB_API.call_api_GetEventList(user: GlobalShared.user, categoryId: (self.selectedEventCategory?.ID)!, date: Date(), searchData: SearchVenueAndEventData(), geolocationFilterData: GlobalShared.geolocationFilterData) { (response, success, message) in
            Utill.printInTOConsole(printData: "response : \(response ?? "")")
            if success == true{
                let data = try! JSONSerialization.data(withJSONObject: response?.dictionaryObject ?? [:], options: [])
                self.eventListData = try! JSONDecoder().decode(EventListData.self, from: data)
                self.arrEventList.removeAll()
                let arrDateWiseEvents = self.prepareArrayEventList()
                self.arrEventList = arrDateWiseEvents
                self.prepareFilterArrayEventList(searchText: "")
                self.tableViewCategory.isHidden = false
                self.tableViewCategory.reloadData()
            }else{
                self.manageNoResultLabel()
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
    
    private func prepareFilterArrayEventList(searchText : String){
        if self.arrEventList.count > 0 {
            self.arrFilteredEventList = arrEventList.clone()
            if searchText != ""{
                for dateWiseEvent in self.arrFilteredEventList{
                    if dateWiseEvent.Events.count > 0{
                        let filteredEvents  = dateWiseEvent.Events.filter { $0.Name.containsIgnoringCase(find: searchText)}
                        dateWiseEvent.Events = filteredEvents
                    }
                }
            }
        }
    }
    
    // MARK: - Action Methods
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.tableViewCategory.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func buttonBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSearchAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.textFieldSearch.text = ""
        if self.buttonSearch.isSelected == true {
            self.viewSearchHeightCont.constant = 39.0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                if self.buttonSearch.isSelected == false{
                    self.viewSearchHeightCont.constant = 0.0
                    self.view.layoutIfNeeded()
                }
            })
        }
        
        //        self.view.endEditing(true)
        //        if let vc = UIStoryboard.home.get(WUHomeSearchViewController.self){
        //            vc.isTextFromHomeSearch = self.textFieldSearchText.text!
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    @IBAction func buttonSearchCloseAction(_ sender: UIButton) {
        self.textFieldSearch.text = ""
        //        if self.textFieldSearch.text == ""{
        //            if self.tableViewSuggestion.isHidden == true{
        //                self.tableViewSuggestion.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //            }else {
        //                self.tableViewSuggestion.isHidden = true
        //                self.showRecentSearchContainerView(isShow: true)
        //            }
        //            self.resetAllCategories()
        //            // self.view.endEditing(true)
        //            self.viewFilter.isHidden = true
        //            self.viewCategories.isHidden = false
        //        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Text.Segue.eventSearchVCToDetailVC{
            let eventProfileVC = segue.destination as! WUEventProfileViewController
            let eventProfileObj = sender as! String
            eventProfileVC.selectedEventId = eventProfileObj
        }
    }
}

// MARK: - UITableView
extension WUEventSelectedCategoryViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrFilteredEventList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = WUEventSectionHeaderView.instanceFromNib()
        headerView.frame = CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 100.0))
        var dateWiseEvents : WUDateWiseEvents!
        dateWiseEvents = self.arrFilteredEventList[section]
        headerView.dateWiseEvent = dateWiseEvents
        switch section {
        case 0:
            headerView.labelTitle.text = Text.Label.text_Today
            break
        case 1:
            headerView.labelTitle.text = Text.Label.text_Tomorrow
            break
        case 2:
            headerView.labelTitle.text = Text.Label.text_ThisWeekend
            break
        case 3:
            headerView.labelTitle.text = Text.Label.text_ComingUp
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
        return self.arrFilteredEventList[section].Events.count > 0 ? self.arrFilteredEventList[section].Events.count : 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.arrFilteredEventList[indexPath.section].Events .count > 0 {
            return UITableViewAutomaticDimension
        }else{
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.arrFilteredEventList[indexPath.section].Events .count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUTitleTableCell()), for: indexPath)as! WUTitleTableCell
            cell.selectionStyle = .none
            cell.event = self.arrFilteredEventList[indexPath.section].Events[indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUNoEventTableCell())) as! WUNoEventTableCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableViewCategory.cellForRow(at: indexPath)
        if !(cell is WUNoEventTableCell) {
            if self.selectedEventCategory != nil {
                self.performSegue(withIdentifier: Text.Segue.eventSearchVCToDetailVC, sender: self.arrFilteredEventList[indexPath.section].Events[indexPath.row].ID)
            }else{
                self.performSegue(withIdentifier: Text.Segue.eventSearchVCToDetailVC, sender: self.arrEventList[indexPath.section].Events[indexPath.row].ID)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
    }
}

//MARK: - SearchBar
extension WUEventSelectedCategoryViewController : UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newText = searchBar.text! + text
        if text == "" || text == "\n"{
            newText = String(newText.dropLast())
            self.tableViewCategory.isHidden = false
            self.prepareFilterArrayEventList(searchText: newText)
            self.tableViewCategory.reloadData()
        }else{
            if newText.count > 0 {
                self.tableViewCategory.isHidden = false
                self.prepareFilterArrayEventList(searchText: newText)
                self.tableViewCategory.reloadData()
            }
        }
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}

//MARK: - UITextField
extension WUEventSelectedCategoryViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if ((textField.text?.count)! > 0){
            self.buttonSearchClose.isHidden = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! + string
        if string == "" || string == "\n"{
            newText = String(newText.dropLast())
            self.tableViewCategory.isHidden = false
            self.prepareFilterArrayEventList(searchText: newText)
            self.tableViewCategory.reloadData()
        }else{
            if newText.count > 0 {
                self.tableViewCategory.isHidden = false
                self.prepareFilterArrayEventList(searchText: newText)
                self.tableViewCategory.reloadData()
            }
        }
        if (newText.count > 0){
            self.buttonSearchClose.isHidden = false
        }else {
            self.buttonSearchClose.isHidden = true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.buttonSearchClose.isHidden = true
        self.view.endEditing(true)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        self.buttonSearchClose.isHidden = true
        self.view.endEditing(true)
        return true
    }
}
