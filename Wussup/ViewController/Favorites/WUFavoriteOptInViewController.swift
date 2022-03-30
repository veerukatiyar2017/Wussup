//
//  WUFavoriteOptInViewController.swift
//  Wussup
//
//  Created by MAC219 on 6/25/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUFavoriteOptInViewController: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var tableViewFavoriterOptIn  : UITableView!
    @IBOutlet private weak var buttonGoToTop    : UIButton!
    @IBOutlet private weak var buttonNoResults      : UIButton!

    weak var delegate : animationHeaderDelegate?
    fileprivate var oldStoredCell:PKSwipeTableViewCell?
    var verticalContentOffset : CGFloat!
    
    var arrFilteredFavoriteVenueList : [WUVenueDetail] = []
    var arrFavoriteVenueList         : [WUVenueDetail] = []{
        didSet{
            self.prepareFilterArrayFavoriteList(searchText: "")
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
        self.tableViewFavoriterOptIn.isHidden = true
self.buttonNoResults.setTitle(Text.Message.noDataFound, for: .normal)
    }
    
    private func manageNoResultLabel(){
        if self.arrFilteredFavoriteVenueList.count > 0 {
            self.tableViewFavoriterOptIn.isHidden = false
            self.buttonNoResults.isHidden = true
            if self.tableViewFavoriterOptIn.contentSize.height  > (UIScreen.main.bounds.height - 77){
                self.buttonGoToTop.isHidden = false
            }else{
                self.buttonGoToTop.isHidden = true
                self.buttonGoToTop.isSelected = false
            }
        }else{
            if let superView = (self.parent as? WUFavoriteHomeViewController) {
                if (superView.textFieldSearch.text?.count)! > 0 {
                    self.buttonNoResults.isUserInteractionEnabled = false
                }else{
                    self.buttonNoResults.isUserInteractionEnabled = true
                }
            }
            self.buttonNoResults.isHidden = false
            self.tableViewFavoriterOptIn.isHidden = true
            self.buttonGoToTop.isHidden = true
        }
//        self.tableViewFavoriterOptIn.reloadData()
        UIView.performWithoutAnimation  {
            self.tableViewFavoriterOptIn.reloadData();
            self.tableViewFavoriterOptIn.layoutIfNeeded();
        }
    }
    
    func prepareFilterArrayFavoriteList(searchText : String){
        self.arrFilteredFavoriteVenueList = self.arrFavoriteVenueList.clone()
        self.buttonGoToTop.isHidden = true
        self.buttonGoToTop.isSelected = false
        if searchText != ""{
            let filteredFavorite  = self.arrFilteredFavoriteVenueList.filter { $0.VenueName.containsIgnoringCase(find: searchText)}
            self.arrFilteredFavoriteVenueList = filteredFavorite
        }
        self.manageNoResultLabel()
    }
    
    // MARK: - Webservice calls
    private func callWS_favoriteVenue(indexPath : IndexPath){
        WEB_API.call_api_FavouriteVenue(user: GlobalShared.user, venueDetail: self.arrFilteredFavoriteVenueList[indexPath.row], isFavorite: false) { (response, success, message) in
            if success == true{
                if let count = response!["VenueFavoriteCount"].string {
                    let obj = self.arrFilteredFavoriteVenueList[indexPath.row]
                    let arr = self.arrFavoriteVenueList.filter{$0.VenueName == obj.VenueName}
                    if arr.count > 0, let index = self.arrFavoriteVenueList.index(of:arr.first!) {
                        self.arrFavoriteVenueList.remove(at: index)
                    }
                    self.delegate?.updateArrayWhenDeleteData(arrFavoriteVenueList: self.arrFavoriteVenueList)
                }
            }else{
                
            }
        }
    }
    
    // MARK: - Webservice calls
    private func callWS_UpdateUserFavoriteVenuesSetting(indexPath : IndexPath){
        
        WEB_API.call_api_UpdateUserFavoriteVenuesSetting(userNotification: self.arrFilteredFavoriteVenueList[indexPath.row].UserFavoriteVenueNotificationSettings) { (response, success, message) in
           Utill.printInTOConsole(printData:"response: \(response ?? "")")
            
            if success == true{
                let data = try! JSONSerialization.data(withJSONObject: response?["UserFavoriteVenuesSetting"].dictionaryObject ?? [:], options: [])
                
                self.arrFilteredFavoriteVenueList[indexPath.row].UserFavoriteVenueNotificationSettings = try! JSONDecoder().decode(WUUserFavNotificationSettings.self, from: data)
            }else{
                Utill.showAlertView(viewController: self, message: message)
                self.tableViewFavoriterOptIn.reloadData()
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
        self.tableViewFavoriterOptIn.setContentOffset(CGPoint.zero, animated: true)
        
        if let delegate = self.delegate {
            delegate.animateHeaderView(scrollview: -5.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.buttonGoToTop.isSelected = false
            })
        }
    }
    
    
}

//MARK: - TableView
extension WUFavoriteOptInViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFilteredFavoriteVenueList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 121.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUFavoriteOptInTableCell())) as! WUFavoriteOptInTableCell
        cell.delegate = self
        cell.favoriteVenue = self.arrFilteredFavoriteVenueList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = UIStoryboard.favorites.get(WUEditNotificationViewController.self){
//            vc.venueDetail = self.arrFilteredFavoriteVenueList[indexPath.row]
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        if self.arrFavoriteVenueList[indexPath.row].VenueStatusID == 1{
            if let vc = UIStoryboard.venue.get(WUVenueProfileViewController.self){
                vc.venueProfileDetail = self.arrFilteredFavoriteVenueList[(indexPath.row)]
                vc.isScreenFromFavoriteTab = true
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            Utill.goToClaimBussinessScreenWithVenue(viewController: self, venue: self.arrFavoriteVenueList[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableViewFavoriterOptIn.contentSize.height  > (UIScreen.main.bounds.height - 77){
            Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
            if self.buttonGoToTop.isSelected == false{
                if let delegate = self.delegate {
                    delegate.animateHeaderView(scrollview: scrollView.contentOffset.y)
                }
            }
        }else {
            if let superView = self.parent as? WUFavoriteHomeViewController {
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
//MARK: - WUVenueProfileViewControllerDelegate
extension WUFavoriteOptInViewController : WUVenueProfileViewControllerDelegate {
    func venueProfileUpdateRating_Favorite(venueProfile obj: WUVenueDetail) {
        if let delegate = self.delegate {
            delegate.venueProfileUpdateRating_Favorite(venueProfile: obj)
        }
    }
    
    func updateNewPromosValues(venueProfile Obj: WUVenueDetail) {
        if self.arrFilteredFavoriteVenueList.count > 0 {
            let promosFilter = self.arrFilteredFavoriteVenueList.index(where: {$0.FourSquareVenueID == Obj.FourSquareVenueID})
            if promosFilter != nil {
                if (promosFilter! < self.arrFilteredFavoriteVenueList.count) {
                    if (self.tableViewFavoriterOptIn.cellForRow(at: IndexPath(row: promosFilter!, section: 0)) as? WUFavoriteOptInTableCell) != nil{
                        let arrPromosData = self.arrFilteredFavoriteVenueList.filter({$0.FourSquareVenueID == Obj.FourSquareVenueID})
                        if arrPromosData.count > 0 {
                            let arrPrmotosFromNotifion = arrPromosData[0].Promotions.VenuePromotions.filter({$0.HasRead.toBool() == false})
                            for promos in arrPrmotosFromNotifion{
                                promos.HasRead = "True"
                            }
                            //                        cell.collectionViewSilder.reloadData()
                        }
                    }
                }
                if let superView = (self.parent as? WUFavoriteHomeViewController){
                    superView.favoriteDateRangeVC.arrFavoriteVenueList = self.arrFavoriteVenueList
                    superView.favoriteListVC.arrFavoriteVenueList = self.arrFavoriteVenueList
                }
            }
        }
    }
}

//MARK: - Swipe delete Delegate
extension WUFavoriteOptInViewController :  PKSwipeCellDelegateProtocol{
    
    func buttonRemoveClicked(cell: WUFavoriteOptInTableCell) {
        Utill.showAlert_OKCancle_View(viewController: self, message: Text.Message.deleteRowMsg) { (bool) in
            let indexPath = self.tableViewFavoriterOptIn.indexPath(for: cell)
            self.callWS_favoriteVenue(indexPath: indexPath!)
        }
    }
    
    func switchToggleClicked(cell: WUFavoriteOptInTableCell) {
        let indexPath = self.tableViewFavoriterOptIn.indexPath(for: cell)
        self.arrFilteredFavoriteVenueList[(indexPath?.row)!].UserFavoriteVenueNotificationSettings.IsSendPromotionalAlert = "\(cell.switchToggle.isOn)"
        self.callWS_UpdateUserFavoriteVenuesSetting(indexPath:indexPath!)
    }
    
    @objc func swipeBeginInCell(_ cell: PKSwipeTableViewCell) {
        oldStoredCell = cell
    }
    
    @objc func swipeDoneOnPreviousCell() -> PKSwipeTableViewCell?
    {
        guard let cell = oldStoredCell else {
            oldStoredCell?.resetCellState()
            return nil
        }
        return cell
    }
    
}
