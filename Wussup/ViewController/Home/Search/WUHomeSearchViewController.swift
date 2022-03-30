//
//  WUHomeSearchViewController.swift
//  Wussup
//
//  Created by MAC26 on 27/04/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

// MARK: - Delegate
protocol WUHomeSearchViewControllerDelegate : class {
    func searchBarDidBeginEditing(homeSearchViewController: WUHomeSearchViewController)
    func searchBarDidEndEditing(homeSearchViewController: WUHomeSearchViewController)
    func updateHomeBasedOnRationgChanges()
}

extension WUHomeSearchViewControllerDelegate {
    func searchBarDidBeginEditing(homeSearchViewController: WUHomeSearchViewController){
        
    }
    func searchBarDidEndEditing(homeSearchViewController: WUHomeSearchViewController){
        
    }
    func updateHomeBasedOnRationgChanges(){
        
    }
}
// MARK: - Delegate
protocol WUHomeSearchDelegate : class {
    func updateHomeBasedOnRationgChanges()
}

extension WUHomeSearchDelegate{
    func updateHomeBasedOnRationgChanges(){
        
    }
}
struct SearchVenueAndEventData {
    var searchText : String = ""
    var visibleText : String = ""
    var selectedCategories : [WUCategory] = []
    var selectedfilters : [WUSearchFilters] = []
}

class WUHomeSearchViewController: UIViewController {
    
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
    @IBOutlet private weak var containerViewFoodCategory    : UIView!
    @IBOutlet private weak var containerViewFilterSearchTop : NSLayoutConstraint!
    @IBOutlet private weak var buttonFilter                 : UIButton!
    @IBOutlet private weak var textFieldSearch              : UITextField!
    @IBOutlet private weak var buttonSearchClose            : UIButton!
    // MARK: - Variables
    var isTextFromHomeSearch  =  ""
    weak var delegate           : WUHomeSearchViewControllerDelegate?
    weak var delegateRating           : WUHomeSearchDelegate?
    var homeSearchResultVC      : WUHomeSearchResultViewController!
    var homeRecentSearchVC      : WUHomeRecentSearchViewController!
    var homeFilterSearchVC      : WUHomeSearchFilterViewController!
    var homeFoodCategoryVC      : WUHomeSearchFoodCategoryViewController!
    var currentSearchedData     : SearchVenueAndEventData = SearchVenueAndEventData()
    var arrayAllFilterCategory  : [WUSearchFilters] = []
    var arraySearchSuggestion   : [WUVenueSuggestion] = []
    var arraySuggestedCategories : [WUCategory] = []
    var arrayAllCategories       : [WUCategory] = []
    var isFromSearchVC : Bool = false
    
    //MARK: - Load Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        FirebaseManager.sharedInstance.HomeSearchScreenShow(parameter: nil)
        self.initialInterfaceSetup()
        self.initialDataSetup()
        
        if containerViewSearchResult.isHidden == false {
            if self.homeSearchResultVC.verticalContentOffset != nil {
                DispatchQueue.main.async {
                    let offset = CGPoint.init(x: 0, y:self.homeSearchResultVC.verticalContentOffset)
                    self.homeSearchResultVC.tableViewSearchResult.setContentOffset(offset, animated: false)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if GlobalShared.arrayCategories.count == 0{
            self.callWS_getCategoryList()
        }else {
            self.arrayAllCategories = GlobalShared.arrayCategories.clone()
        }
        
        AppDel.setUpLocationManager(completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetup() {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        
        self.labelNavigationTitle.font = UIFont.ProximaNovaMedium(20)
        self.viewFilter.backgroundColor = .DarkGrayColor
        self.viewCategories.backgroundColor = .DarkGrayColor
        
        if self.isTextFromHomeSearch == ""{
            self.showRecentSearchContainerView(isShow: true)
        }else {
            self.textFieldSearch.text = self.isTextFromHomeSearch
            self.currentSearchedData.searchText = self.textFieldSearch.text ?? ""
            self.currentSearchedData.visibleText = self.textFieldSearch.text ?? ""
            self.showSearchResultContainerView(isShow: true)
        }
        self.containerViewFilterSearchTop.constant  = 493.0.propotionalHeight
        self.tableViewSuggestion.isHidden = true
        self.buttonSearchClose.isHidden = true
        
        self.buttonSearchClose.imageView?.contentMode = .scaleAspectFill
        self.buttonSearchClose.frame = CGRect(x: (self.textFieldSearch.frame.size.width), y: 10.0.propotionalHeight, width: (self.buttonSearchClose.imageView?.image?.size.width)! + 10.0, height: 20.0)
        self.buttonSearchClose.addTarget(self, action: #selector(self.buttonSearchCloseAction(_:)), for: .touchUpInside)
        self.textFieldSearch.rightView = self.buttonSearchClose
//        self.textFieldSearch.rightView?.backgroundColor = UIColor.cyan
//        self.buttonSearchClose.backgroundColor = UIColor.GreenColor
        self.textFieldSearch.rightViewMode = .always
        
        self.collectionViewCategories.register(UINib(nibName: Utill.getClassNameFor(classType: WUCategoryCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType: WUCategoryCollectionCell()))
        
        self.tableViewSuggestion.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUTitleTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUTitleTableCell()))
    }
    
    private func initialDataSetup() {
        self.arrayAllFilterCategory = GlobalShared.arraySearchFilters.clone()
//        self.arrayAllCategories = GlobalShared.arrayCategories.clone()
    }
    
    // MARK: - Reset Methods
    private func resetAllCategories(){
        for cat in self.arrayAllCategories {
            cat.isSelected = false
        }
        self.collectionViewCategories.reloadData()
    }
    
    // MARK: - Webservice Methods
    
    private func callWS_getCategoryList() {
        WEB_API.call_api_GetCategoryList { (response,status,message) in
            if status == true{
                let data = try! JSONSerialization.data(withJSONObject: (response!["Categories"]).arrayObject ?? [], options: [])
                let arrCategoris = try! JSONDecoder().decode([WUCategory].self, from: data)
                GlobalShared.arrayCategories = arrCategoris
                Utill.printInTOConsole(printData:"\(arrCategoris)")
                self.arrayAllCategories = GlobalShared.arrayCategories.clone()
                self.collectionViewCategories.reloadData()
            }else {
                Utill.showAlertView(viewController: self, message: message)
            }
        }
    }
    
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
        if self.isFromSearchVC == true{
            if let delegate = self.delegateRating {
                delegate.updateHomeBasedOnRationgChanges()
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonFilterAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.showFilterViewWithAnimation(isShow: sender.isSelected)
    }
    
    @IBAction func buttonSearchCloseAction(_ sender: UIButton) {
        self.textFieldSearch.text = ""
        self.buttonSearchClose.isHidden = true
        if self.isCheckFoodCategoryIsSelected() {
            self.homeFoodCategoryVC.prepareFilterArrayFoodCategoryList(searchText: "")
        }else if self.containerViewSearchResult.isHidden == false{
            if self.homeSearchResultVC.arraySearchVenues.count > 0 {
                self.homeSearchResultVC.prepareFilterArrayResultList(searchText: "")
            }else {
                self.tableViewSuggestion.isHidden = false
                self.callWS_getSuggestionList(searchText: "")
                self.filterCategiesForSugestion(searchText: "" )
            }
        }
        else{
            self.tableViewSuggestion.isHidden = true
            //            self.callWS_getSuggestionList(searchText: "")
            //            self.filterCategiesForSugestion(searchText:"")
        }
        self.viewFilter.isHidden = true
    }
    
    // MARK: - Animation
    private func showFilterViewWithAnimation(isShow : Bool){
        if isShow == false {
            UIView.animate(withDuration: 0.3, animations: {
                self.containerViewFilterSearchTop.constant  = 398.0.propotionalHeight
                self.view.layoutIfNeeded()
            }, completion: { (isBool) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.containerViewFilterSearch.isHidden = true
                    self.showSearchResultContainerView(isShow: true)
                })
            })
        }else{
            self.homeFilterSearchVC.arrayAllFilterCategory = self.arrayAllFilterCategory
            self.containerViewFilterSearchTop.constant  = 0.0.propotionalHeight
            self.containerViewFilterSearch.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func showSearchResultContainerView(isShow : Bool){
        
        self.containerViewRecentSearch.isHidden = true
        self.containerViewSearchResult.isHidden = true
        self.containerViewFoodCategory.isHidden = true
        self.tableViewSuggestion.isHidden = true
        self.viewFilter.isHidden = false
        if isShow == true {
            let arraySelectedFilter  = self.arrayAllFilterCategory.filter {$0.filterId != WUSearchFilterID.FoodCategory.rawValue && $0.filterId != WUSearchFilterID.LiveMusic.rawValue && $0.isSelected == true}
            
            let arrFoodCategory = self.arrayAllFilterCategory.filter{$0.filterId == WUSearchFilterID.FoodCategory.rawValue && $0.isSelected == true}
            
            self.currentSearchedData.selectedfilters = arraySelectedFilter
            if self.arraySuggestedCategories.count > 0 && self.currentSearchedData.selectedCategories.count == 0{
                let arraySelectedSuggestedCategory = self.arraySuggestedCategories.filter { $0.WussupName.caseInsensitiveCompare(self.currentSearchedData.visibleText) == .orderedSame}
                if arraySelectedSuggestedCategory.count > 0{
                    self.currentSearchedData.selectedCategories = self.arraySuggestedCategories
                }else {
                    self.currentSearchedData.selectedCategories = []
                }
            }
            
            self.homeSearchResultVC.arraySearchVenues.removeAll()
            self.textFieldSearch.text = ""
            
            if arrFoodCategory.count > 0 && self.currentSearchedData.selectedCategories.count == 0{
                self.labelNavigationTitle.text = "Food Category".uppercased()
                self.showFoodCategoryView(isShow: true)
                self.currentSearchedData.searchText = ""
                self.currentSearchedData.visibleText = ""
                self.homeFoodCategoryVC.callWS_getFoodCategory()
            }else if self.currentSearchedData.searchText == "" &&  self.currentSearchedData.selectedfilters.count == 0 &&  self.currentSearchedData.selectedCategories.count == 0{
                self.labelNavigationTitle.text = "SEARCH".uppercased()
                self.showRecentSearchContainerView(isShow: true)
            }else{
                self.labelNavigationTitle.text = "SEARCH".uppercased()
                if self.currentSearchedData.visibleText.count > 0{
                    self.labelNavigationTitle.text = self.currentSearchedData.visibleText.uppercased()
                }
                self.homeSearchResultVC.searchedVenueData = self.currentSearchedData
                self.containerViewSearchResult.isHidden = false
            }
        }
    }
    
    private func showRecentSearchContainerView(isShow : Bool){
        self.containerViewRecentSearch.isHidden = true
        self.containerViewFilterSearch.isHidden = true
        self.containerViewSearchResult.isHidden = true
        self.containerViewFoodCategory.isHidden = true
        self.tableViewSuggestion.isHidden = true
        if isShow == true {
            self.containerViewRecentSearch.isHidden = false
            self.homeRecentSearchVC.callWS_getRecentSearchList()
        }
    }
    
    private func showSuggestionView(isShow : Bool){
        self.containerViewRecentSearch.isHidden = true
        self.containerViewFilterSearch.isHidden = true
        self.containerViewSearchResult.isHidden = true
        self.containerViewFoodCategory.isHidden = true
        self.tableViewSuggestion.isHidden = true
        
        if isShow == true {
            self.tableViewSuggestion.isHidden = false
        }
    }
    
    private func showFoodCategoryView(isShow : Bool){
        self.containerViewRecentSearch.isHidden = true
        self.containerViewFilterSearch.isHidden = true
        self.containerViewSearchResult.isHidden = true
        self.containerViewFoodCategory.isHidden = true
        self.tableViewSuggestion.isHidden = true
        
        if isShow == true {
            self.containerViewFoodCategory.isHidden = false
        }
    }
    
    private func setDataForLiveMusicCategory(searchText : String){
        let arrFilterCategoies = self.arrayAllCategories.filter{$0.isSelected == true}
        if arrFilterCategoies.count > 0{
            for category in arrFilterCategoies{
                category.isSelected = false
            }
            self.collectionViewCategories.reloadData()
        }
        let arrLiveMusic = self.arrayAllFilterCategory.filter{$0.filterId == WUSearchFilterID.LiveMusic.rawValue && $0.isSelected == true}
        if arrLiveMusic.count > 0{
            let arraySelectedCategory = self.arrayAllCategories.filter { $0.ID == String(VenueCategoryID.Music.rawValue)}
            if arraySelectedCategory.count > 0 {
                self.currentSearchedData.searchText = ""
                self.currentSearchedData.visibleText = searchText
                self.currentSearchedData.selectedCategories = arraySelectedCategory
            }
        }
    }
    
    private func setDataForSearchTextAndCategory(searchText : String) {
        let arrLiveMusic = self.arrayAllFilterCategory.filter{$0.filterId == WUSearchFilterID.LiveMusic.rawValue && $0.isSelected == true}
        if arrLiveMusic.count > 0 {
            for filter in arrLiveMusic {
                filter.isSelected = false
            }
            self.collectionViewFilter.reloadData()
        }
        let arrFilterCategoies = self.arrayAllCategories.filter{$0.isSelected == true}
        if arrFilterCategoies.count > 0 {
            for category in arrFilterCategoies{
                category.isSelected = false
            }
        }
        let arraySelectedCategory = self.arrayAllCategories.filter { $0.WussupName.caseInsensitiveCompare(searchText) == .orderedSame}
        if arraySelectedCategory.count > 0 {
            self.currentSearchedData.searchText = ""
            self.currentSearchedData.visibleText = searchText
            
            for category in arraySelectedCategory {
                category.isSelected = true
            }
            self.currentSearchedData.selectedCategories = arraySelectedCategory
            self.labelNavigationTitle.text = searchText.uppercased()
        }else {
            self.currentSearchedData.searchText = searchText
            self.currentSearchedData.visibleText = searchText
            self.currentSearchedData.selectedCategories = []
        }
        self.collectionViewCategories.reloadData()
    }
    
    private func isCheckFoodCategoryIsSelected() -> Bool {
        if self.arrayAllFilterCategory.count > 0 {
            let arrFoodCategory = self.arrayAllFilterCategory.filter{$0.filterId == WUSearchFilterID.FoodCategory.rawValue && $0.isSelected == true}
            if arrFoodCategory.count > 0 {
                return true
            }
        }
        return false
    }
    
    func updateClaimBusinessDataWithVenue(_ venue : WUVenue)
    {
        if self.homeSearchResultVC.arraySearchVenues.count > 0  {
            let index = self.homeSearchResultVC.arraySearchVenues.index(where: {$0.FourSquareVenueID == venue.FourSquareVenueID})
            if index! < self.homeSearchResultVC.arraySearchVenues.count{
                self.homeSearchResultVC.arraySearchVenues[index!].IsClaimVenue = "True"

                let indexFilter = self.homeSearchResultVC.arrayFilterSearchVenues.index(where: {$0.FourSquareVenueID == venue.FourSquareVenueID})
                if indexFilter! < self.homeSearchResultVC.arrayFilterSearchVenues.count{
                        self.homeSearchResultVC.arrayFilterSearchVenues[index!].IsClaimVenue = "True"
                        self.homeSearchResultVC.tableViewSearchResult.beginUpdates()
                        self.homeSearchResultVC.tableViewSearchResult.reloadRows(at: [IndexPath(row: indexFilter!, section: 0)], with: .none)
                        self.homeSearchResultVC.tableViewSearchResult.endUpdates()
//                        self.isFromSearchVC = true
                }
            }
        }
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Text.Segue.homeSearchToRecentSearch {
            let homeRecentVC = segue.destination as! WUHomeRecentSearchViewController
            homeRecentVC.homeSearchVC = self
            homeRecentVC.delegate = self
            self.homeRecentSearchVC = homeRecentVC
        }
        if segue.identifier == Text.Segue.homeSearchToSearchResult{
            self.homeSearchResultVC = segue.destination as! WUHomeSearchResultViewController
            homeSearchResultVC.delegate = self
            self.view.endEditing(true)
        }
        if segue.identifier == Text.Segue.homeSearchToFilterSearch{
            self.homeFilterSearchVC = segue.destination as! WUHomeSearchFilterViewController
            self.homeFilterSearchVC.delegate = self
        }
        if segue.identifier == Text.Segue.homeSearchToFoodCategory{
            self.homeFoodCategoryVC = segue.destination as! WUHomeSearchFoodCategoryViewController
            self.homeFoodCategoryVC.delegate = self
        }
        if segue.identifier == Text.Segue.searchResultVCToPlayLivecamVC{
            let vcPlayLiveCam = segue.destination as! WUPlayLiveCamViewController
            vcPlayLiveCam.hidesBottomBarWhenPushed = true
            vcPlayLiveCam.playLiveCamArray = [sender as! WUVenueLiveCams]
        }
    }
}
//MARK: - WUHomeRecentSearchViewControllerDelegate
extension WUHomeSearchViewController : WUHomeRecentSearchViewControllerDelegate{
    func didSelectRecentSearch(selectedData: String) {
        self.setDataForSearchTextAndCategory(searchText: selectedData)
        self.showSearchResultContainerView(isShow: true)
        self.viewFilter.isHidden = false
        self.textFieldSearch.resignFirstResponder()
    }
}

//MARK: -  WUHomeSearchFilterViewControllerDelegate
extension WUHomeSearchViewController : WUHomeSearchFilterViewControllerDelegate{
    func filterDoneButtonSelected(arraySelectedFilter: [WUSearchFilters]) {
        self.currentSearchedData.selectedfilters = arraySelectedFilter
        let arr = self.arrayAllFilterCategory.filter{$0.filterId == WUSearchFilterID.LiveMusic.rawValue && $0.isSelected == true}
        if arr.count > 0 {
            self.setDataForLiveMusicCategory(searchText: arr.first!.filterName)
        }
        let arrFood = self.arrayAllFilterCategory.filter{$0.filterId == WUSearchFilterID.FoodCategory.rawValue && $0.isSelected == true}
        if arrFood.count > 0{
            self.currentSearchedData.searchText = ""
            self.currentSearchedData.visibleText = ""
            self.currentSearchedData.selectedCategories = []
        }
        self.collectionViewFilter.reloadData()
        self.buttonFilter.isSelected = false
        self.showFilterViewWithAnimation(isShow: false)
    }
}
//MARK: - WUHomeRecentSearchViewControllerDelegate
extension WUHomeSearchViewController : WUHomeSearchResultViewControllerDelegate{
    func HomeSearchResultViewControllerLiveCamButtonClicked(withVenueCategory venueCategory: Any) {
        self.homeSearchResultVC.verticalContentOffset  = self.homeSearchResultVC.tableViewSearchResult.contentOffset.y
        
        if venueCategory is WUVenueLiveCams{
            Utill.goToLivecamProfile(viewController: self, withLivecamM: (venueCategory as! WUVenueLiveCams))
        }
        if venueCategory is WUVenue{
            Utill.goToLivecamProfile(viewController: self, withLivecamM: (venueCategory as! WUVenue).LiveCamsURLs[0])
        }
    }
    
    func didSelectMoreButton(withVenue venue: Any) {
        if (venue as! WUVenue).VenueStatusID == 1 {
            if let vc = UIStoryboard.venue.get(WUVenueProfileViewController.self){
                vc.delegate = self
                vc.venue = venue as! WUVenue
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            Utill.goToClaimBussinessScreenWithVenue(viewController: self, venue: venue as! WUVenue)
        }
    }
}

extension WUHomeSearchViewController : WUVenueProfileViewControllerDelegate {
    func venueProfileUpdateRating_Favorite(venueProfile obj: WUVenueDetail) {
        if self.homeSearchResultVC.arraySearchVenues.count > 0  {
            let index = self.homeSearchResultVC.arraySearchVenues.index(where: {$0.FourSquareVenueID == obj.FourSquareVenueID})
            if index! < self.homeSearchResultVC.arraySearchVenues.count{
                if self.homeSearchResultVC.arraySearchVenues[index!].VenueRating != obj.VenueRating {
                    self.homeSearchResultVC.arraySearchVenues[index!].VenueRating = obj.VenueRating
                }
                let indexFilter = self.homeSearchResultVC.arrayFilterSearchVenues.index(where: {$0.FourSquareVenueID == obj.FourSquareVenueID})
                if indexFilter! < self.homeSearchResultVC.arrayFilterSearchVenues.count{
                    if self.homeSearchResultVC.arrayFilterSearchVenues[indexFilter!].VenueRating != obj.VenueRating {
                        self.homeSearchResultVC.arrayFilterSearchVenues[indexFilter!].VenueRating = obj.VenueRating
                        self.homeSearchResultVC.tableViewSearchResult.beginUpdates()
                        self.homeSearchResultVC.tableViewSearchResult.reloadRows(at: [IndexPath(row: indexFilter!, section: 0)], with: .none)
                        self.homeSearchResultVC.tableViewSearchResult.endUpdates()
                        self.isFromSearchVC = true
                    }
                }
            }
        }
    }
}

//MARK: - WUHomeSearchFoodCategoryViewControllerDelegate
extension WUHomeSearchViewController : WUHomeSearchFoodCategoryViewControllerDelegate{
    
    func didSelectFoodCategorySearch(selectedCategoryData : WUCategory) {
        let arrFoodCategory = self.arrayAllFilterCategory.filter{$0.filterId == WUSearchFilterID.FoodCategory.rawValue && $0.isSelected == true}
        for filter in arrFoodCategory {
            filter.isSelected = false
        }
        self.collectionViewFilter.reloadData()
        self.currentSearchedData.searchText = ""
        self.currentSearchedData.visibleText = selectedCategoryData.Name
        self.currentSearchedData.selectedCategories = [selectedCategoryData]
        self.showSearchResultContainerView(isShow: true)
    }
}
//MARK: - TableView
extension WUHomeSearchViewController : UITableViewDelegate , UITableViewDataSource {
    
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
        return 60.0
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
            cell.searchText = self.textFieldSearch.text
            cell.venueSuggestion = self.arraySearchSuggestion[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var visibleText = ""
        if indexPath.section == 0 {
            visibleText = self.arraySuggestedCategories[indexPath.row].WussupName
            self.arraySuggestedCategories.removeAll()
        }else{
            visibleText = self.arraySearchSuggestion[indexPath.row].Name
        }
        self.tableViewSuggestion.isHidden = true
        self.setDataForSearchTextAndCategory(searchText: visibleText)
        self.showSearchResultContainerView(isShow: true)
        self.textFieldSearch.resignFirstResponder()
    }
}

//MARK: - CollectionView
extension WUHomeSearchViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewFilter{
            let arrFoodCategory = self.arrayAllFilterCategory.filter{$0.filterId == WUSearchFilterID.FoodCategory.rawValue && $0.isSelected == true}
            if arrFoodCategory.count > 0{
                return arrFoodCategory.count
            }
            return self.arrayAllFilterCategory.count
        }else {
            return self.arrayAllCategories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewFilter{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType: WUSearchFilterCollectionCell()), for: indexPath)as! WUSearchFilterCollectionCell
            let arrFoodCategory = self.arrayAllFilterCategory.filter{$0.filterId == WUSearchFilterID.FoodCategory.rawValue && $0.isSelected == true}
            if arrFoodCategory.count > 0{
                cell.setFilterData = arrFoodCategory[indexPath.row]
                cell.viewSeprator.isHidden = true
            }else {
                cell.setFilterData = self.arrayAllFilterCategory[indexPath.row]
                cell.viewSeprator.isHidden = true
                if indexPath.row < self.arrayAllFilterCategory.count - 1
                {
                    cell.viewSeprator.isHidden = false
                }
            }
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
            if self.containerViewFilterSearch.isHidden == false {
                self.showFilterViewWithAnimation(isShow: self.buttonFilter.isSelected)
            }
            if filterObject.filterId == WUSearchFilterID.FoodCategory.rawValue && filterObject.isSelected == true {
                let arrSelectedCategory  = self.arrayAllCategories.filter{$0.isSelected == true}
                for category in arrSelectedCategory {
                    category.isSelected = false
                }
                self.collectionViewCategories.reloadData()
                self.currentSearchedData.selectedCategories = []
                
                let arrSelectedFilter  = self.arrayAllFilterCategory.filter{$0.filterId != WUSearchFilterID.FoodCategory.rawValue && $0.isSelected == true}
                for filter in arrSelectedFilter{
                    filter.isSelected = false
                }
            }
            self.setDataForLiveMusicCategory(searchText: filterObject.filterName)
            self.showSearchResultContainerView(isShow: true)
            self.collectionViewFilter.reloadData()
        }else{
            let categoryObject  = self.arrayAllCategories[indexPath.row]
            categoryObject.isSelected = !categoryObject.isSelected
            let cell = collectionView.cellForItem(at: indexPath)as!WUCategoryCollectionCell
            cell.setCategory = categoryObject
            let arrFoodCategory = self.arrayAllFilterCategory.filter{$0.filterId == WUSearchFilterID.FoodCategory.rawValue && $0.isSelected == true}
            for filter in arrFoodCategory {
                filter.isSelected = false
            }
            if arrFoodCategory.count > 0 {
                self.collectionViewFilter.reloadData()
            }
            self.viewCategories.isHidden = true
            self.setDataForSearchTextAndCategory(searchText: self.arrayAllCategories[indexPath.row].WussupName)
            self.showSearchResultContainerView(isShow: true)
            self.textFieldSearch.resignFirstResponder()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewFilter{
            return CGSize(width: 100.0, height: 38.0)
        }else{
            return CGSize(width: 90.0, height: 101.0)
        }
    }
}
//MARK: - UITextField
extension WUHomeSearchViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {        
        self.viewFilter.isHidden = true
        self.viewCategories.isHidden = false
        if self.isCheckFoodCategoryIsSelected(){
            self.showFoodCategoryView(isShow: true)
        }else if self.containerViewSearchResult.isHidden == true {
            self.showRecentSearchContainerView(isShow: true)
            self.delegate?.searchBarDidBeginEditing(homeSearchViewController: self)
        }
        
        if ((textField.text?.count)! > 0) {
            self.buttonSearchClose.isHidden = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! + string
        if string == ""{
            newText = String(newText.dropLast())
        }
        
        if self.isCheckFoodCategoryIsSelected(){
            self.homeFoodCategoryVC.prepareFilterArrayFoodCategoryList(searchText: newText)
        }else if self.containerViewSearchResult.isHidden == false{
            if self.homeSearchResultVC.arraySearchVenues.count > 0 {
                self.homeSearchResultVC.prepareFilterArrayResultList(searchText: newText)
            }else {
                self.tableViewSuggestion.isHidden = false
                self.callWS_getSuggestionList(searchText: newText)
                self.filterCategiesForSugestion(searchText: newText )
            }
        }
        else if newText.count < 3{
            
            self.tableViewSuggestion.isHidden = true
        }else{
            self.tableViewSuggestion.isHidden = false
            self.callWS_getSuggestionList(searchText: newText)
            self.filterCategiesForSugestion(searchText: newText )
        }
        
        if (newText.count > 0) {
            self.buttonSearchClose.isHidden = false
        }else {
            self.buttonSearchClose.isHidden = true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewFilter.isHidden = false
        self.buttonSearchClose.isHidden = true
        self.delegate?.searchBarDidEndEditing(homeSearchViewController: self)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if self.isCheckFoodCategoryIsSelected()
        {
            self.viewCategories.isHidden = true
            self.homeFoodCategoryVC.prepareFilterArrayFoodCategoryList(searchText: textField.text!)
        }
        else if self.containerViewSearchResult.isHidden == false && self.tableViewSuggestion.isHidden == true
        {
            self.viewCategories.isHidden = true
            self.homeSearchResultVC.prepareFilterArrayResultList(searchText: textField.text!)
        }
        else if (textField.text?.isEmpty)! {
            self.showToast(message: "Enter Text To Search")
        }
        else {
            self.viewCategories.isHidden = true
            if self.tableViewSuggestion.isHidden == false {
                self.tableViewSuggestion.isHidden = true
            }
            self.setDataForSearchTextAndCategory(searchText: textField.text!)
            self.showSearchResultContainerView(isShow: true)
            self.viewFilter.isHidden = false
        }
        self.buttonSearchClose.isHidden = true
        self.textFieldSearch.resignFirstResponder()
        return true
    }
}

