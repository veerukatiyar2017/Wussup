//
//  WULiveCamSearchViewController.swift
//  Wussup
//
//  Created by MAC219 on 7/18/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

 // MARK: - Delegate
protocol WULiveCamSearchViewControllerDelegate : class {
    func searchBarDidBeginEditing(liveCamSearchViewController: WULiveCamSearchViewController)
    func searchBarDidEndEditing(liveCamSearchViewController: WULiveCamSearchViewController)
}

extension WULiveCamSearchViewControllerDelegate{
    func searchBarDidBeginEditing(liveCamSearchViewController: WULiveCamSearchViewController){
        
    }
    func searchBarDidEndEditing(liveCamSearchViewController: WULiveCamSearchViewController){
        
    }
}

class WULiveCamSearchViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var labelNavigationTitle     : UILabel!
    @IBOutlet private weak var stackView                    : UIStackView!
    @IBOutlet private weak var tableViewSuggestion          : UITableView!
    @IBOutlet private weak var viewFilter                   : UIView!
    @IBOutlet private weak var viewCategories               : UIView!
    @IBOutlet private weak var collectionViewFilter         : UICollectionView!
    @IBOutlet private weak var collectionViewCategories     : UICollectionView!
    @IBOutlet private weak var containerViewRecentSearch    : UIView!
    @IBOutlet private weak var containerViewSearchResult    : UIView!
    @IBOutlet private weak var containerViewFilterSearch    : UIView!
    @IBOutlet private weak var containerViewFilterSearchTop : NSLayoutConstraint!
    @IBOutlet private weak var buttonFilter                 : UIButton!
    @IBOutlet private weak var textFieldSearch              : UITextField!
    @IBOutlet private weak var buttonSearchClose            : UIButton!
    
    // MARK: - Variables
    var isTextFromHomeSearch  =  ""
    weak var delegate               : WULiveCamSearchViewControllerDelegate?
    
    var LiveCamSearchResultVC       : WULiveCamSearchResultViewController!
    var LiveCamRecentSearchVC       : WULiveCamRecentSearchViewController!
    var LiveCamFilterSearchVC       : WULiveCamSearchFilterViewController!
    
    var currentSearchedData         : SearchVenueAndEventData   = SearchVenueAndEventData()
    var arrayAllFilterCategory      : [WUSearchFilters]         = []
    var arraySearchSuggestion       : [WUVenueSuggestion]       = []
    var arraySuggestedCategories    : [WUCategory]              = []
    var arrayAllCategories          : [WUCategory]              = []
    var isFromSearchVC              : Bool                      = true
    
    //MARK: - Load Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetup()
        self.initialDataSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDel.setUpLocationManager(completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetup() {
        Utill.enableKeyboardManagement()
        self.labelNavigationTitle.font = UIFont.ProximaNovaMedium(20)
        self.viewFilter.backgroundColor = .DarkGrayColor
        self.viewCategories.backgroundColor = .DarkGrayColor
        self.containerViewFilterSearchTop.constant  = 493.0.propotionalHeight
        self.tableViewSuggestion.isHidden = true
        self.buttonSearchClose.isHidden = true
        
        self.collectionViewCategories.register(UINib(nibName: Utill.getClassNameFor(classType: WUCategoryCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType: WUCategoryCollectionCell()))
        
        self.tableViewSuggestion.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUTitleTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUTitleTableCell()))
    }
    
    private func initialDataSetup() {
        self.arrayAllFilterCategory = GlobalShared.arraySearchFilters.clone()
        self.arrayAllCategories = GlobalShared.arrayCategories.clone()
    }
    
    // MARK: - Reset Methods
    private func resetAllCategories(){
        for cat in self.arrayAllCategories {
            cat.isSelected = false
        }
        self.collectionViewCategories.reloadData()
    }
    
    // MARK: - Webservice Methods
    private func callWS_getSuggestionList(searchText : String){
        self.arraySearchSuggestion.removeAll()
        WEB_API.call_api_GetSearchSuggestions(searchText: searchText) { (response, status, message) in
            if status == true{
                let data = try! JSONSerialization.data(withJSONObject: response?["VenueSuggestionList"].arrayObject ?? [:], options: [])
                self.arraySearchSuggestion = try! JSONDecoder().decode([WUVenueSuggestion].self, from: data)
            }else{
                
            }
            self.tableViewSuggestion.reloadData()
        }
    }
    
    
    private func filterCategiesForSugestion(searchText : String){
        self.arraySuggestedCategories  = GlobalShared.arrayCategories.filter { $0.WussupName.containsIgnoringCase(find: searchText)}
        self.tableViewSuggestion.reloadData()
    }
    
    // MARK: - Action Methods
    @IBAction func buttonBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonFilterAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.showFilterViewWithAnimation(isShow: sender.isSelected)
    }
    @IBAction func buttonSearchCloseAction(_ sender: UIButton) {
        self.textFieldSearch.text = ""
        if self.textFieldSearch.text == ""{
            if self.tableViewSuggestion.isHidden == true{
                self.tableViewSuggestion.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }else {
                self.tableViewSuggestion.isHidden = true
                self.showRecentSearchContainerView(isShow: true)
            }
            self.resetAllCategories()
            // self.view.endEditing(true)
            self.viewFilter.isHidden = true
            self.viewCategories.isHidden = false
        }
    }
    
    // MARK: - Animation
    private func showFilterViewWithAnimation(isShow : Bool){
        if isShow == false {
            UIView.animate(withDuration: 0.3, animations: {
                if self.viewCategories.isHidden == true{
                    self.containerViewFilterSearchTop.constant  = 493.0.propotionalHeight
                }else{
                    self.containerViewFilterSearchTop.constant  = 398.0.propotionalHeight
                }
                self.view.layoutIfNeeded()
            }, completion: { (isBool) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.containerViewFilterSearch.isHidden = true
                    self.showSearchResultContainerView(isShow: true)
                })
            })
        }else{
            self.LiveCamFilterSearchVC.arrayAllFilterCategory = self.arrayAllFilterCategory
            self.containerViewFilterSearchTop.constant  = 0.0.propotionalHeight
            self.containerViewFilterSearch.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func showSearchResultContainerView(isShow : Bool){
        
        self.containerViewRecentSearch.isHidden = true
        self.containerViewSearchResult.isHidden = true
        self.tableViewSuggestion.isHidden = true
        self.viewFilter.isHidden = false
        if isShow == true {
            self.viewCategories.isHidden = true
            let arraySelectedFilter  = self.arrayAllFilterCategory.filter { $0.isSelected == true}
            self.currentSearchedData.selectedfilters = arraySelectedFilter
            if self.arraySuggestedCategories.count > 0 {
                self.currentSearchedData.selectedCategories = self.arraySuggestedCategories
            }else{
                let arraySelectedCategory = self.arrayAllCategories.filter { $0.isSelected == true}
                self.currentSearchedData.selectedCategories = arraySelectedCategory
            }
            self.LiveCamSearchResultVC.arraySearchVenues.removeAll()
            self.textFieldSearch.text = self.currentSearchedData.visibleText
            
            if self.currentSearchedData.searchText == "" &&  self.currentSearchedData.selectedfilters.count == 0 &&  self.currentSearchedData.selectedCategories.count == 0{
                self.viewCategories.isHidden = false
                self.showRecentSearchContainerView(isShow: true)
            }else{
                self.LiveCamSearchResultVC.searchedVenueData = self.currentSearchedData
                self.containerViewSearchResult.isHidden = false
            }
        }
    }
    
    private func showRecentSearchContainerView(isShow : Bool){
        self.containerViewRecentSearch.isHidden = true
        self.containerViewFilterSearch.isHidden = true
        self.containerViewSearchResult.isHidden = true
        self.tableViewSuggestion.isHidden = true
        if isShow == true {
            self.containerViewRecentSearch.isHidden = false
//            self.homeRecentSearchVC.callWS_getRecentSearchList()
        }
    }
    
    private func showSuggestionView(isShow : Bool){
        self.containerViewRecentSearch.isHidden = true
        self.containerViewFilterSearch.isHidden = true
        self.containerViewSearchResult.isHidden = true
        self.tableViewSuggestion.isHidden = true
        
        if isShow == true {
            self.tableViewSuggestion.isHidden = false
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Text.Segue.LiveCamSearchToRecentSearch {
            let liveCamRecentVC = segue.destination as! WULiveCamRecentSearchViewController
            liveCamRecentVC.homeSearchVC = self
            liveCamRecentVC.delegate = self
            self.LiveCamRecentSearchVC = liveCamRecentVC
        }
        if segue.identifier == Text.Segue.LiveCamSearchToSearchResult{
            self.LiveCamSearchResultVC = segue.destination as! WULiveCamSearchResultViewController
            LiveCamSearchResultVC.delegate = self
            self.view.endEditing(true)
        }
        if segue.identifier == Text.Segue.LiveCamSearchToFilterSearch{
            self.LiveCamFilterSearchVC = segue.destination as! WULiveCamSearchFilterViewController
            self.LiveCamFilterSearchVC.delegate = self
        }
    }
}
//MARK: - WUHomeRecentSearchViewControllerDelegate
extension WULiveCamSearchViewController : WULiveCamRecentSearchViewControllerDelegate{
    func didSelectRecentSearch(selectedData: String) {
        self.currentSearchedData.visibleText = selectedData
        self.currentSearchedData.searchText = selectedData
        self.showSearchResultContainerView(isShow: true)
        self.viewFilter.isHidden = false
        self.viewCategories.isHidden = true
    }
}

//MARK: -  WUHomeSearchFilterViewControllerDelegate
extension WULiveCamSearchViewController : WUHomeSearchFilterViewControllerDelegate{
    func filterDoneButtonSelected(arraySelectedFilter: [WUSearchFilters]) {
        self.currentSearchedData.selectedfilters = arraySelectedFilter
        self.collectionViewFilter.reloadData()
        let arraySelectedFilter  = self.arrayAllFilterCategory.filter { $0.isSelected == true}
        self.currentSearchedData.selectedfilters = arraySelectedFilter
        self.buttonFilter.isSelected = false
        self.showFilterViewWithAnimation(isShow: false)
    }
}
//MARK: - WUHomeRecentSearchViewControllerDelegate
extension WULiveCamSearchViewController : WULiveCamSearchResultViewControllerDelegate{
    func didSelectMoreButton(withVenue venue: Any) {
        if let vc = UIStoryboard.venue.get(WUVenueProfileViewController.self){
            vc.venue = venue
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - TableView
extension WULiveCamSearchViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = WUSearchSectionHeaderView.instanceFromNib()
        headerView.frame = CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 43.0.propotionalHeight))
        if section == 0 {
            headerView.labelSectionTitle.text = "Catergories"
        }else{
            headerView.labelSectionTitle.text = "Suggestions"
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && self.arraySuggestedCategories.count == 0 {
            return 0.0
        }
        return 40.0.propotionalHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0.propotional
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.arraySuggestedCategories.count
        }
        return self.arraySearchSuggestion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUSearchImageTableCell()), for: indexPath)as! WUSearchImageTableCell
            cell.searchText = self.textFieldSearch.text
            cell.category = self.arraySuggestedCategories[indexPath.row]
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUTitleTableCell()), for: indexPath)as! WUTitleTableCell
            //            cell.labelTitle.text = "\(indexPath.row + 1)"
            cell.searchText = self.textFieldSearch.text
            cell.venueSuggestion = self.arraySearchSuggestion[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.currentSearchedData.visibleText = self.arraySuggestedCategories[indexPath.row].WussupName
            self.arraySuggestedCategories.removeAll()
            
        }else{
            self.currentSearchedData.searchText = self.arraySearchSuggestion[indexPath.row].Name
            self.currentSearchedData.visibleText = self.arraySearchSuggestion[indexPath.row].Name
        }
        self.tableViewSuggestion.isHidden = true
        self.showSearchResultContainerView(isShow: true)
    }
}

//MARK: - CollectionView
extension WULiveCamSearchViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewFilter{
            return self.arrayAllFilterCategory.count - 1 
        }else {
            return self.arrayAllCategories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewFilter{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType: WUSearchFilterCollectionCell()), for: indexPath)as! WUSearchFilterCollectionCell
            cell.setFilterData = self.arrayAllFilterCategory[indexPath.row]
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUCategoryCollectionCell()), for: indexPath)as! WUCategoryCollectionCell
            cell.setCategory = self.arrayAllCategories[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewFilter{
            let filterObject  = self.arrayAllFilterCategory[indexPath.row]
            filterObject.isSelected = !filterObject.isSelected
            let cell = collectionView.cellForItem(at: indexPath) as! WUSearchFilterCollectionCell
            cell.setFilterData = filterObject
            self.buttonFilter.isSelected = false
            if self.containerViewFilterSearch.isHidden == false{
                self.showFilterViewWithAnimation(isShow: self.buttonFilter.isSelected)
            }
            self.showSearchResultContainerView(isShow: true)
        }else{
            
            let categoryObject  = self.arrayAllCategories[indexPath.row]
            if categoryObject.isSelected == false{
                let arrFilterCategoies = self.arrayAllCategories.filter{$0.isSelected == true}
                if arrFilterCategoies.count > 0{
                    for category in arrFilterCategoies{
                        category.isSelected = false
                    }
                }
            }
            
            categoryObject.isSelected = !categoryObject.isSelected
            let cell = collectionView.cellForItem(at: indexPath)as!WUCategoryCollectionCell
            cell.setCategory = categoryObject
            
            self.viewCategories.isHidden = true
            self.currentSearchedData.visibleText = self.arrayAllCategories[indexPath.row].WussupName
            self.showSearchResultContainerView(isShow: true)
            self.collectionViewCategories.reloadData()
        }
        
        
    }
    
    private func resetFilterData(){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewFilter{
            return CGSize(width: 86.0, height: 38.0)
        }else{
            return CGSize(width: 90.0, height: 101.0)
        }
    }
}

extension WULiveCamSearchViewController : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.viewFilter.isHidden = true
        self.viewCategories.isHidden = false
        self.showRecentSearchContainerView(isShow: true)
        self.delegate?.searchBarDidEndEditing(liveCamSearchViewController: self)
        if ((textField.text?.count)! > 0)
        {
            self.buttonSearchClose.isHidden = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! + string
        if string == ""{
            newText = String(newText.dropLast())
            
            if (textField.text!).count == 1 {
                self.viewCategories.isHidden = false
            }else if (textField.text!).count > 1 {
                self.viewCategories.isHidden = true
                if(textField.text!).count - 1 < 3{
                    self.tableViewSuggestion.isHidden = true
                }else{
                    self.callWS_getSuggestionList(searchText: newText)
                    self.filterCategiesForSugestion(searchText: newText )
                }
            }
        }else{
            if newText.count > 0 {
                self.viewCategories.isHidden = true
                if newText.count > 2{
                    self.tableViewSuggestion.isHidden = false
                    self.tableViewSuggestion.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(KEYBOARD_SIZE), right: 0)
                    self.callWS_getSuggestionList(searchText: newText)
                    self.filterCategiesForSugestion(searchText: newText )
                }
            }
        }
        if (newText.count > 0)
        {
            self.buttonSearchClose.isHidden = false
        }
        else {
            self.buttonSearchClose.isHidden = true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewFilter.isHidden = false
        if self.currentSearchedData.visibleText == "" {
            self.viewCategories.isHidden = false
        }
        self.buttonSearchClose.isHidden = true
        self.delegate?.searchBarDidEndEditing(liveCamSearchViewController: self)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if (textField.text?.isEmpty)! {
            self.showToast(message: "Enter Text To Search")
            self.viewCategories.isHidden = false
        }else {
            if self.tableViewSuggestion.isHidden == false {
                self.tableViewSuggestion.isHidden = true
            }
            self.currentSearchedData.searchText = textField.text!
            self.currentSearchedData.visibleText = textField.text!
            
            self.showSearchResultContainerView(isShow: true)
            self.viewFilter.isHidden = false
            self.viewCategories.isHidden = true
        }
        self.textFieldSearch.resignFirstResponder()
        self.buttonSearchClose.isHidden = true
        return true
    }
}

