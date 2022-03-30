//
//  WUFavoriteListViewController.swift
//  Wussup
//
//  Created by MAC219 on 6/25/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUFavoriteListViewController: UIViewController {
    
    @IBOutlet weak var tableViewFavoriterList   : UITableView!
    @IBOutlet private weak var buttonGoToTop    : UIButton!
    @IBOutlet private weak var buttonNoResults      : UIButton!

    weak var delegate : animationHeaderDelegate?
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
        self.tableViewFavoriterList.isHidden = true
        self.buttonNoResults.setTitle(Text.Message.noDataFound, for: .normal)
        //        self.tableViewFavoriterList.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
    }
    
    private func manageNoResultLabel(){
        if self.arrFilteredFavoriteVenueList.count > 0 {
            self.tableViewFavoriterList.isHidden = false
            self.buttonNoResults.isHidden = true
            if self.tableViewFavoriterList.contentSize.height  > (UIScreen.main.bounds.height - 77){
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
            self.tableViewFavoriterList.isHidden = true
            self.buttonGoToTop.isHidden = true
        }
        UIView.performWithoutAnimation  {
            self.tableViewFavoriterList.reloadData();
            self.tableViewFavoriterList.layoutIfNeeded();
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
    
    // MARK: - Action Methods
    @IBAction func buttonNoResultsAction(_ sender: Any) {
        if let delegate = self.delegate{
            delegate.didSelectButtonNoResult()
        }
    }
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.buttonGoToTop.isSelected = true
        self.tableViewFavoriterList.setContentOffset(CGPoint.zero, animated: true)
        
        if let delegate = self.delegate {
            delegate.animateHeaderView(scrollview: -5.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.buttonGoToTop.isSelected = false
            })
        }
    }
}

//MARK: - TableView
extension WUFavoriteListViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFilteredFavoriteVenueList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUFavoriteListTableCell())) as! WUFavoriteListTableCell
        cell.favoriteVenue = self.arrFilteredFavoriteVenueList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.arrFavoriteVenueList[indexPath.row].VenueStatusID == 1{
            if let vc = UIStoryboard.venue.get(WUVenueProfileViewController.self){
                vc.venueProfileDetail = self.arrFilteredFavoriteVenueList[indexPath.row]
                vc.isScreenFromFavoriteTab = true
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
             Utill.goToClaimBussinessScreenWithVenue(viewController: self, venue: self.arrFavoriteVenueList[indexPath.row])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
        
        if self.tableViewFavoriterList.contentSize.height  > (UIScreen.main.bounds.height - 77){
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
extension WUFavoriteListViewController : WUVenueProfileViewControllerDelegate {
    func venueProfileUpdateRating_Favorite(venueProfile obj: WUVenueDetail) {
        if let delegate = self.delegate {
            delegate.venueProfileUpdateRating_Favorite(venueProfile: obj)
        }
    }
    func updateNewPromosValues(venueProfile Obj: WUVenueDetail) {
        if self.arrFilteredFavoriteVenueList.count > 0 {
            let promosFilter = self.arrFilteredFavoriteVenueList.index(where: {$0.FourSquareVenueID == Obj.FourSquareVenueID})
            if promosFilter != nil{
                if (promosFilter! < self.arrFilteredFavoriteVenueList.count) {
                    if (self.tableViewFavoriterList.cellForRow(at: IndexPath(row: promosFilter!, section: 0)) as? WUFavoriteListTableCell) != nil{
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
                    superView.favoriteOptInVC.arrFavoriteVenueList = self.arrFavoriteVenueList
                }
            }
        }
    }
}
