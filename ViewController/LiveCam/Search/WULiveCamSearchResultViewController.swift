//
//  WULiveCamSearchResultViewController.swift
//  Wussup
//
//  Created by MAC219 on 7/18/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WULiveCamSearchResultViewControllerDelegate : class {
    func didSelectMoreButton(withVenue venue : Any)
}
extension WULiveCamSearchResultViewControllerDelegate {
    func didSelectMoreButton(withVenue venue : Any){
        
    }
}

class WULiveCamSearchResultViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var buttonGoToTop                : UIButton!
    @IBOutlet private weak var tableViewSearchResult        : UITableView!
    @IBOutlet private weak var labelNoResults               : UILabel!
    
    // MARK: - Variables
    weak var delegate : WULiveCamSearchResultViewControllerDelegate?
    var arraySearchVenues : [WUVenue] = []
    var searchedVenueData : SearchVenueAndEventData!{
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
        if self.searchedVenueData != nil {
            self.callWS_getSearchedVenueList()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetup() {
        self.tableViewSearchResult.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUSearchResultTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUSearchResultTableCell()))
        self.tableViewSearchResult.tableFooterView?.isHidden = true
        self.buttonGoToTop.isHidden = true
        self.labelNoResults.text = Text.Message.noResultsFound
    }
    
    //MARK: - Show Label Of No Result Found
    private func showNoResult(show : Bool ,message : String ){
        if show{
            self.labelNoResults.isHidden = false
            self.tableViewSearchResult.isScrollEnabled = false
            self.buttonGoToTop.isHidden = true
        }else{
            self.labelNoResults.isHidden = true
            self.buttonGoToTop.isHidden = false
            self.tableViewSearchResult.isScrollEnabled = true
        }
        self.labelNoResults.text = message
    }
    
    // MARK: - Webservice Methods
    private func callWS_getSearchedVenueList(){
        self.tableViewSearchResult.contentOffset = CGPoint.zero
        WEB_API.call_api_SearchVenues(user: GlobalShared.user, searchData: self.searchedVenueData) { (response, status, message) in
            if status == true{
                self.arraySearchVenues.removeAll()
                 Utill.printInTOConsole(printData:"response: \(response ?? "")")
                let data = try! JSONSerialization.data(withJSONObject: response?["SearchedVenues"].arrayObject ?? [:], options: [])
                self.arraySearchVenues = try! JSONDecoder().decode([WUVenue].self, from: data)
                if self.arraySearchVenues.count == 0 {
                    self.showNoResult(show: true, message: Text.Message.noResultsFound)
                }else{
                    self.showNoResult(show: false, message: Text.Message.noResultsFound)
                }
                self.tableViewSearchResult.reloadData()
            }else {
                Utill.showAlertView(viewController: self, message: message)
                self.arraySearchVenues.removeAll()
                self.tableViewSearchResult.reloadData()
            }
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.tableViewSearchResult.setContentOffset(CGPoint.zero, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//MARK: - TableView
extension WULiveCamSearchResultViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arraySearchVenues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUSearchResultTableCell()), for: indexPath)as! WUSearchResultTableCell
        if self.arraySearchVenues.count > 0{
            cell.venue = self.arraySearchVenues[indexPath.row]
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let venueObject = self.arraySearchVenues[indexPath.row]
        if let delegate = self.delegate{
            delegate.didSelectMoreButton(withVenue: venueObject)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
    }
}
extension WULiveCamSearchResultViewController : WUSearchResultTableCellDelegate {
    func searchResultTableCellLiveCamButtonClicked(cell: WUSearchResultTableCell, withVenueCategory venueCategory: Any) {
    }
    
    func didSelectMoreButton(searchResultCell: WUSearchResultTableCell) {
        let indexPath = tableViewSearchResult.indexPath(for: searchResultCell)
        let venueObject = self.arraySearchVenues[(indexPath?.row)!]
        if let delegate = self.delegate{
            delegate.didSelectMoreButton(withVenue: venueObject)
        }
    }
}
