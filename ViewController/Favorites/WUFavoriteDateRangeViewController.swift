//
//  WUFavoriteDateRangeViewController.swift
//  Wussup
//
//  Created by MAC219 on 6/25/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol  animationHeaderDelegate : class {
    func animateHeaderView(scrollview: CGFloat)
    func favoriteDateRangeTableCellLiveCamButtonClicked(cell : WUFavoriteDateRangeTableCell, withFavorite obj : Any)
    func updateArrayWhenDeleteData(arrFavoriteVenueList : [WUVenueDetail])
    func venueProfileUpdateRating_Favorite(venueProfile obj : WUVenueDetail)
    func didSelectButtonNoResult()
}

extension animationHeaderDelegate {
    func animateHeaderView(scrollview: CGFloat){
        
    }
    func favoriteDateRangeTableCellLiveCamButtonClicked(cell : WUFavoriteDateRangeTableCell, withFavorite obj : Any){
        
    }
    func updateArrayWhenDeleteData(arrFavoriteVenueList : [WUVenueDetail]) {
        
    }
    func venueProfileUpdateRating_Favorite(venueProfile obj : WUVenueDetail){
        
    }
    func didSelectButtonNoResult(){
        
    }
}

//MARK: - class WUFavoriteDateRangeViewController
class WUFavoriteDateRangeViewController: UIViewController {
    
    @IBOutlet  weak var tableViewFavoriterDateRange             : UITableView!
    @IBOutlet private weak var buttonGoToTop                    : UIButton!
    @IBOutlet private weak var buttonNoResults      : UIButton!
    
    let viewTimeSheet = WUTimeSheetView.instanceFromNib()
    var verticalContentOffset : CGFloat!
    var verticalScrollContentOffset : CGFloat  = 0.0

    weak var delegate : animationHeaderDelegate?
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
        self.tableViewFavoriterDateRange.isHidden = true
        self.buttonNoResults.setTitle(Text.Message.noDataFound, for: .normal)
    }
    
    private func manageNoResultLabel(){
        if self.arrFilteredFavoriteVenueList.count > 0 {
            self.tableViewFavoriterDateRange.isHidden = false
            self.buttonNoResults.isHidden = true
            if self.tableViewFavoriterDateRange.contentSize.height  > (UIScreen.main.bounds.height - 125){
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
            self.tableViewFavoriterDateRange.isHidden = true
            self.buttonGoToTop.isHidden = true
            self.buttonGoToTop.isSelected = false
        }
        
        UIView.performWithoutAnimation  {
            self.tableViewFavoriterDateRange.reloadData();
            self.tableViewFavoriterDateRange.layoutIfNeeded();
        }
    }
    
    func prepareFilterArrayFavoriteList(searchText : String){
        self.viewTimeSheet.removeFromSuperview()
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
        self.tableViewFavoriterDateRange.setContentOffset(CGPoint.zero, animated: true)
        
        if let delegate = self.delegate {
            delegate.animateHeaderView(scrollview: -5.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.buttonGoToTop.isSelected = false
            })
        }
    }
}

//MARK: - TableView
extension WUFavoriteDateRangeViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFilteredFavoriteVenueList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
        
        let favoriteVenue = self.arrFilteredFavoriteVenueList[indexPath.row]
        if favoriteVenue.Promotions.VenuePromotions.count > 0 && favoriteVenue.VenueOpenHours.count > 0{
            return 364
        }
        else if favoriteVenue.Promotions.VenuePromotions.count == 0 && favoriteVenue.VenueOpenHours.count > 0{
            return 262.0
        }
        else if favoriteVenue.Promotions.VenuePromotions.count > 0 && favoriteVenue.VenueOpenHours.count == 0{
            if favoriteVenue.Promotions.VenuePromotions.count == 1 {
               return 330
            }else{
                return 364
            }
        }
        else{ //if favoriteVenue.Promotions.VenuePromotions.count == 0 && favoriteVenue.VenueOpenHours.count == 0
           return 228.0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUFavoriteDateRangeTableCell())) as! WUFavoriteDateRangeTableCell
        cell.delegate = self

        cell.favoriteVenue = self.arrFilteredFavoriteVenueList[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewTimeSheet.removeFromSuperview()
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
    
    private func markNewPromosAsRead(scrollView: UIScrollView){
        
        if scrollView.contentOffset.y > self.verticalScrollContentOffset{  // Scroll Down
            if  tableViewFavoriterDateRange.visibleCells.count > 0{

                if (tableViewFavoriterDateRange.visibleCells.first is WUFavoriteDateRangeTableCell){
                    let cell = (tableViewFavoriterDateRange.visibleCells.first as! WUFavoriteDateRangeTableCell)

                    if cell.collectionViewSilder.visibleCells.first is WUHomeSliderCollectionCell{
                        (cell.collectionViewSilder.visibleCells.first as! WUHomeSliderCollectionCell).markPromoAsRead()
                        let indexPath = tableViewFavoriterDateRange.indexPathsForVisibleRows!.first!

                        if let iPath = cell.collectionViewSilder?.indexPathsForVisibleItems.first {
                            self.arrFilteredFavoriteVenueList[indexPath.row].Promotions.VenuePromotions[iPath.row].HasRead = "True"
                        }
                    }
                }
            }
        }else{  // Scroll Up
            if  tableViewFavoriterDateRange.visibleCells.count > 0{

                if (tableViewFavoriterDateRange.visibleCells.last is WUFavoriteDateRangeTableCell){
                    let cell = (tableViewFavoriterDateRange.visibleCells.last as! WUFavoriteDateRangeTableCell)

                    if cell.collectionViewSilder.visibleCells.first is WUHomeSliderCollectionCell{
                        (cell.collectionViewSilder.visibleCells.first as! WUHomeSliderCollectionCell).markPromoAsRead()
                        let indexPath = tableViewFavoriterDateRange.indexPathsForVisibleRows!.last!

                        if let iPath = cell.collectionViewSilder?.indexPathsForVisibleItems.first {
                            self.arrFilteredFavoriteVenueList[indexPath.row].Promotions.VenuePromotions[iPath.row].HasRead = "True"
                        }
                    }
                }
            }
        }

        self.verticalScrollContentOffset = scrollView.contentOffset.y
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         
        // Mark New Promos As Read
        self.markNewPromosAsRead(scrollView: scrollView)
        
        
        if self.tableViewFavoriterDateRange.contentSize.height  > (UIScreen.main.bounds.height - 125){
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

//MARK: - WUFavoriteDateRangeTableCellDelegate
extension WUFavoriteDateRangeViewController : WUFavoriteDateRangeTableCellDelegate {
    
    func buttonTimeSheetClicked(cell: UITableViewCell) {
        
        let indexPath = self.tableViewFavoriterDateRange.indexPath(for: cell)
        viewTimeSheet.favoriteVenueTimeSheet = self.arrFilteredFavoriteVenueList[(indexPath?.row)!]
        if (indexPath?.row)! == self.arrFilteredFavoriteVenueList.count - 1 {
            let pointY = cell.frame.origin.y + ((cell as! WUFavoriteDateRangeTableCell).frame.height - 30)
            viewTimeSheet.isLastRow = true
            viewTimeSheet.showInView(superView: self.tableViewFavoriterDateRange, atPointY: pointY)
        }else{
            let pointY = cell.frame.origin.y + ((cell as! WUFavoriteDateRangeTableCell).frame.height - 74)
            viewTimeSheet.isLastRow = false
            viewTimeSheet.showInView(superView: self.tableViewFavoriterDateRange, atPointY: pointY)
        }
        self.viewTimeSheet.layer.shadowColor = UIColor.gray.cgColor
        self.viewTimeSheet.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.viewTimeSheet.layer.shadowOpacity = 1
        self.viewTimeSheet.layer.shadowRadius = 1.0
        self.viewTimeSheet.layer.masksToBounds = false
    }
    
    func favoriteDateRangeTableCellLiveCamButtonClicked(cell: WUFavoriteDateRangeTableCell, withFavorite obj: Any) {
        if let delegate = self.delegate {
            delegate.favoriteDateRangeTableCellLiveCamButtonClicked(cell: cell, withFavorite: obj)
        }
    }
}

extension WUFavoriteDateRangeViewController : WUVenueProfileViewControllerDelegate {
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
                    if let cell = self.tableViewFavoriterDateRange.cellForRow(at: IndexPath(row: promosFilter!, section: 0)) as? WUFavoriteDateRangeTableCell{
                        let arrPromosData = self.arrFilteredFavoriteVenueList.filter({$0.FourSquareVenueID == Obj.FourSquareVenueID})
                        if arrPromosData.count > 0 {
                            let arrPrmotosFromNotifion = arrPromosData[0].Promotions.VenuePromotions.filter({$0.HasRead.toBool() == false})
                            for promos in arrPrmotosFromNotifion{
                                promos.HasRead = "True"
                            }
                            cell.collectionViewSilder.reloadData()
                        }
                    }
                }
                
                if let superView = (self.parent as? WUFavoriteHomeViewController){
                    superView.favoriteOptInVC.arrFavoriteVenueList = self.arrFavoriteVenueList
                    superView.favoriteListVC.arrFavoriteVenueList = self.arrFavoriteVenueList
                }
            }
        }
    }
}
