//
//  WUHomeSearchResultViewController.swift
//  Wussup
//
//  Created by MAC219 on 5/2/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WUHomeSearchResultViewControllerDelegate : class {
    func didSelectMoreButton(withVenue venue : Any)
    func HomeSearchResultViewControllerLiveCamButtonClicked( withVenueCategory venueCategory : Any)
}
extension WUHomeSearchResultViewControllerDelegate {
    func didSelectMoreButton(withVenue venue : Any) {
        
    }
    func HomeSearchResultViewControllerLiveCamButtonClicked( withVenueCategory venueCategory : Any) {
        
    }
}

class WUHomeSearchResultViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var buttonGoToTop    : UIButton!
    @IBOutlet weak var tableViewSearchResult    : UITableView!
    @IBOutlet private weak var labelNoResults   : UILabel!
    
    enum TypeCell: Int {
        case searchResult = 0
        case placeholder
    }
    
    // MARK: - Variables
    var verticalContentOffset           : CGFloat!
    var placeholderCardAdsIndex         : Int?
    var typeCell                        : TypeCell = .searchResult
    weak var delegate                   : WUHomeSearchResultViewControllerDelegate?
    var arraySearchVenues               : [WUVenue] = []
    var arrayFilterSearchVenues         : [WUVenue] = []
    var placeholderCardAds              : WUPlaceholder!

    var searchedVenueData : SearchVenueAndEventData! {
        didSet{
            self.callWS_getSearchedVenueList()
        }
    }
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        if self.searchedVenueData != nil {
        //            self.callWS_getSearchedVenueList()
        //        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetup() {
        
        self.tableViewSearchResult.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUSearchResultTableCell()),
                                                       bundle: nil),
                                            forCellReuseIdentifier: Utill.getClassNameFor(classType: WUSearchResultTableCell()))
        
        self.tableViewSearchResult.register(UINib.init(nibName: Utill.getClassNameFor(classType: PlaceholderTableCell()),
                                                       bundle: nil),
                                            forCellReuseIdentifier: Utill.getClassNameFor(classType: PlaceholderTableCell()))
        
        self.tableViewSearchResult.tableFooterView?.isHidden = true
        self.buttonGoToTop.isHidden = true
        self.labelNoResults.text = Text.Message.noDataFound
    }
    
    func prepareFilterArrayResultList(searchText : String) {
        
        self.arrayFilterSearchVenues.removeAll()
        
        if self.arraySearchVenues.count > 0 {
            self.typeCell = .searchResult
            self.arrayFilterSearchVenues = self.arraySearchVenues.clone()
            if searchText != "" {
                let filteredResult  = self.arraySearchVenues.filter { $0.VenueName.containsIgnoringCase(find: searchText)}
                self.arrayFilterSearchVenues = filteredResult
            }
            self.addPlaceholderToArrayFilterSearchVenues()
        } else {
            self.typeCell = .placeholder
            self.showNoResult()
        }
        self.tableViewSearchResult.reloadData()
    }
    
    private func addPlaceholderToArrayFilterSearchVenues() {
        
        for i in 0..<self.arrayFilterSearchVenues.count {
            // I find when they start simple accounts
            if self.arrayFilterSearchVenues[i].IsSponseredVenues == "False" {
                self.placeholderCardAdsIndex = i
                let venue = WUVenue(original: self.arrayFilterSearchVenues.first!)
                // added object to arrayFilterSearchVenues by index before simple accounts
                self.arrayFilterSearchVenues.insert(venue, at: i)
                return
            }
        }
    }
    
    //MARK: - Show Label Of No Result Found
    private func showNoResult() {
        
        self.labelNoResults.isHidden = false
        self.tableViewSearchResult.isScrollEnabled = false
        self.buttonGoToTop.isHidden = true
        self.labelNoResults.text = Text.Message.noDataFound
    }
    
    // MARK: - Webservice Methods
    private func callWS_getSearchedVenueList(){
        self.arraySearchVenues.removeAll()
        self.arrayFilterSearchVenues.removeAll()
        self.tableViewSearchResult.reloadData()
        
        //        FirebaseManager.sharedInstance.HomeSearchResultsScreenShow(parameter: nil)
        self.tableViewSearchResult.contentOffset = CGPoint.zero
        WEB_API.call_api_SearchVenues(user: GlobalShared.user, searchData: self.searchedVenueData)
        { (response, status, message) in
            if status == true {
                Utill.printInTOConsole(printData:"response: \(response ?? "")")
                let bannerListData = try! JSONSerialization.data(withJSONObject: response?["LiveCamBanners"].arrayObject ?? [],
                                                                 options: [])
                let arrayLivecamBannerList = try! JSONDecoder().decode([WUHomeBannerList].self, from: bannerListData)
                Utill.saveHomeBannerModel(arrayLivecamBannerList)
                
                let searchedVenuesData = try! JSONSerialization.data(withJSONObject: response?["SearchedVenues"].arrayObject
                    ?? [:], options: [])
                self.arraySearchVenues = try! JSONDecoder().decode([WUVenue].self, from: searchedVenuesData)
                self.prepareFilterArrayResultList(searchText: "")
                
                let cardAds = WUPlaceholder.TypePlaceholder.CardAds.stringValue
                let placeholderData = try! JSONSerialization.data(withJSONObject: response?[cardAds].dictionaryObject
                    ?? [:], options: [])
                self.placeholderCardAds = try! JSONDecoder().decode(WUPlaceholder.self, from: placeholderData)
                
            } else {
                Utill.showAlertView(viewController: self, message: message)
            }
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.tableViewSearchResult.setContentOffset(CGPoint.zero, animated: true)
    }
}

//MARK: - TableView
extension WUHomeSearchResultViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.typeCell {
        case .searchResult:
            return self.arrayFilterSearchVenues.count
            
        case .placeholder:
            return 1 // Placeholder
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.typeCell {
        case .searchResult:
            if self.placeholderCardAdsIndex == indexPath.row { // create placeholder by indexPath.row
                let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: PlaceholderTableCell()),
                                                         for: indexPath)as! PlaceholderTableCell
                cell.placeholderCardAds = self.placeholderCardAds
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUSearchResultTableCell()), for: indexPath)as! WUSearchResultTableCell
                cell.delegate = self
                cell.searchedVenueData = self.searchedVenueData
                cell.venue = self.arrayFilterSearchVenues[indexPath.row]
                return cell
            }

        case .placeholder:
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: PlaceholderTableCell()),
                                                     for: indexPath)as! PlaceholderTableCell
            cell.placeholderCardAds = self.placeholderCardAds
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch self.typeCell {
        case .searchResult:
            if self.placeholderCardAdsIndex == indexPath.row { // placeholder height
                return 262.0
            } else {
                return 270.0
            }
        case .placeholder:
            return 262.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.typeCell {
        case .searchResult:
            if self.placeholderCardAdsIndex == indexPath.row { // tap to placeholder
                if let vc = UIStoryboard.home.get(WUClaimABusinessViewController.self) {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                let venueObject = self.arrayFilterSearchVenues[indexPath.row]
                if let delegate = self.delegate{
                    delegate.didSelectMoreButton(withVenue: venueObject)
                }
            }
            
        case .placeholder: // tap to placeholder
            if let vc = UIStoryboard.home.get(WUClaimABusinessViewController.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
           // self.performSegue(withIdentifier:Text.Segue.homeSearchToClaimBusiness, sender: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
    }
}

//MARK: - WUSearchResultTableCellDelegate
extension WUHomeSearchResultViewController : WUSearchResultTableCellDelegate {
    
    func searchResultTableCellLiveCamButtonClicked(cell: WUSearchResultTableCell, withVenueCategory venueCategory: Any) {
        if let delegate = self.delegate{
            delegate.HomeSearchResultViewControllerLiveCamButtonClicked(withVenueCategory: venueCategory)
        }
    }
    
    func didSelectMoreButton(searchResultCell: WUSearchResultTableCell) {
        let indexPath = tableViewSearchResult.indexPath(for: searchResultCell)
        let venueObject = self.arrayFilterSearchVenues[(indexPath?.row)!]
        if let delegate = self.delegate{
            delegate.didSelectMoreButton(withVenue: venueObject)
        }
    }
    
    func goToClaimBussinessScreenWithVenue(_ venue : WUVenue) {
        if let vc = UIStoryboard.home.get(WUClaimABusinessPromptViewController.self){
            vc.venue = venue
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


