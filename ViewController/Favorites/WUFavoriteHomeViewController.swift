//
//  WUFavoriteHomeViewController.swift
//  Wussup
//
//  Created by MAC219 on 6/25/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol headerAnimationOnClickOfGoToTopDelegate : class {
    func manageSegmentView()
}
extension headerAnimationOnClickOfGoToTopDelegate {
    func manageSegmentView(){
        
    }
}

class WUFavoriteHomeViewController: UIViewController {
    
    // MARK: - Constants
    let TopBarExpandHeight = CGFloat(125.0)
    let TopBarSmallHeight = CGFloat(77.0)
    
    // MARK: - IBOutlet
    @IBOutlet private weak var topBarLongView                   : UIView!
    @IBOutlet private weak var topBarSmallView                  : UIView!
    @IBOutlet private weak var constraintExpandTopBarHeight     : NSLayoutConstraint!
    @IBOutlet private weak var labelNavTitle                    : UILabel!
    @IBOutlet  weak var buttonFavoriteDateRange                 : UIButton!
    @IBOutlet  weak var buttonFavoriteOptIn                     : UIButton!
    @IBOutlet  weak var buttonFavoriteList                      : UIButton!
    @IBOutlet private weak var containerViewFavoriteDateRange   : UIView!
    @IBOutlet private weak var containerViewFavoriteOptIn       : UIView!
    @IBOutlet private weak var containerViewFavoriteList        : UIView!
    @IBOutlet  weak var textFieldSearch                         : UITextField!
    @IBOutlet private weak var buttonSearchClose                : UIButton!
    @IBOutlet private weak var buttonSearchSmallView            : UIButton!
    @IBOutlet private weak var buttonSearchExpandView           : UIButton!
    @IBOutlet  weak var segmentViewHeightCont                   : NSLayoutConstraint!
    @IBOutlet  weak var segmentStackViewBottomCont              : NSLayoutConstraint!
    @IBOutlet private weak var viewSearchHeightCont             : NSLayoutConstraint!
    
    // MARK: - Variable
    var favoriteDateRangeVC     : WUFavoriteDateRangeViewController!
    var favoriteOptInVC         : WUFavoriteOptInViewController!
    var favoriteListVC          : WUFavoriteListViewController!
    var favoriteVenueListData   : [WUVenueDetail] = []
    var isFromProfile = false
    
    weak var delegate           : headerAnimationOnClickOfGoToTopDelegate?
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetUp()
        self.initialDataSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.manageContentOffset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        UIApplication.shared.isStatusBarHidden = false
        self.setSelectedButton(buttonToSelect: self.buttonFavoriteDateRange)
        self.segmentViewHeightCont.constant = 40.0
        self.segmentStackViewBottomCont.constant = 2.0
        self.buttonSearchClose.isHidden = true
        //        self.buttonSearchClose.imageView?.contentMode = .scaleAspectFit
        self.buttonSearchClose.frame = CGRect(x: (self.textFieldSearch.frame.size.width), y: 10.0.propotionalHeight, width: (self.buttonSearchClose.imageView?.image?.size.width)! + 10.0, height: 20.0)
        self.buttonSearchClose.addTarget(self, action: #selector(self.buttonSearchCloseAction(_:)), for: .touchUpInside)
        self.textFieldSearch.rightView = self.buttonSearchClose
        self.textFieldSearch.rightViewMode = .always
    }
    
    private func initialDataSetup(){
        self.callWS_GetUserFavoriteVenues(forDate: Date())
    }
    
    private func manageContentOffset(){
        if self.buttonFavoriteDateRange.isSelected == true{
            if self.favoriteDateRangeVC.verticalContentOffset != nil {
                DispatchQueue.main.async {
                    let offset = CGPoint.init(x: 0, y:self.favoriteDateRangeVC.verticalContentOffset)
                    self.favoriteDateRangeVC.tableViewFavoriterDateRange.setContentOffset(offset, animated: false)
                }
            }
        } else if self.buttonFavoriteOptIn.isSelected == true{
            if self.favoriteOptInVC.verticalContentOffset != nil{
                DispatchQueue.main.async {
                    let offset = CGPoint.init(x: 0, y:self.favoriteOptInVC.verticalContentOffset)
                    self.favoriteOptInVC.tableViewFavoriterOptIn.setContentOffset(offset, animated: false)
                }
            }
        }else {
            if self.favoriteListVC.verticalContentOffset != nil{
                DispatchQueue.main.async {
                    let offset = CGPoint.init(x: 0, y:self.favoriteListVC.verticalContentOffset)
                    self.favoriteListVC.tableViewFavoriterList.setContentOffset(offset, animated: false)
                }
            }
        }
    }
    
    func updateUIForProfielToFav() {
        self.buttonFavoriteOptInAction(self.buttonFavoriteOptIn)
        self.isFromProfile = false
    }
    
    // MARK: - Webservice calls
    func callWS_GetUserFavoriteVenues(forDate date : Date){
        self.buttonSearchExpandView.isSelected = false
        self.buttonSearchSmallView.isSelected = false
        self.viewSearchHeightCont.constant = 0.0
        WEB_API.call_api_GetUserFavoriteVenues(user: GlobalShared.user, date: date, searchText: "") { (response, success, message) in
           Utill.printInTOConsole(printData:"response GetUserFavoriteVenues: \(response ?? "")")
            
            if success == true{
                let bannerListData = try! JSONSerialization.data(withJSONObject: response?["LiveCamBanners"].arrayObject ?? [], options: [])
                let arrayLivecamBannerList = try! JSONDecoder().decode([WUHomeBannerList].self, from: bannerListData)
                Utill.saveHomeBannerModel(arrayLivecamBannerList)
                
                let data = try! JSONSerialization.data(withJSONObject: response?["FavoriteVenues"].arrayObject ?? [], options: [])
                self.favoriteVenueListData = try! JSONDecoder().decode([WUVenueDetail].self, from: data)
                self.favoriteDateRangeVC.arrFavoriteVenueList = self.favoriteVenueListData
                self.favoriteOptInVC.arrFavoriteVenueList = self.favoriteVenueListData
                self.favoriteListVC.arrFavoriteVenueList = self.favoriteVenueListData
                self.textFieldSearch.text = ""
                if self.isFromProfile == true{
                    self.updateUIForProfielToFav()
                }
            }else{
                self.favoriteDateRangeVC.arrFavoriteVenueList = []
                self.favoriteOptInVC.arrFavoriteVenueList = []
                self.favoriteListVC.arrFavoriteVenueList = []
            }
        }
    }
    
    
    // MARK: - Action Methods
    @IBAction func buttonSearchAction(_ sender: UIButton) {
        
        if self.buttonFavoriteDateRange.isSelected == true {
            self.favoriteDateRangeVC.verticalContentOffset  = self.favoriteDateRangeVC.tableViewFavoriterDateRange.contentOffset.y
        }else if self.buttonFavoriteOptIn.isSelected == true  {
            self.favoriteOptInVC.verticalContentOffset  = self.favoriteOptInVC.tableViewFavoriterOptIn.contentOffset.y
        }else {
            self.favoriteListVC.verticalContentOffset  = self.favoriteListVC.tableViewFavoriterList.contentOffset.y
        }
        sender.isSelected = !sender.isSelected
        self.buttonSearchExpandView.isSelected = sender.isSelected
        self.buttonSearchSmallView.isSelected = sender.isSelected
        self.textFieldSearch.text = ""
        if sender.isSelected == true {
            self.viewSearchHeightCont.constant = 39.0
            self.textFieldSearch.becomeFirstResponder()
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                if sender.isSelected == false{
                    self.viewSearchHeightCont.constant = 0.0
                    self.textFieldSearch.resignFirstResponder()
                    self.view.endEditing(true)
                    self.view.layoutIfNeeded()
                    self.favoriteDateRangeVC.prepareFilterArrayFavoriteList(searchText: self.textFieldSearch.text!)
                    self.favoriteOptInVC.prepareFilterArrayFavoriteList(searchText: self.textFieldSearch.text!)
                    self.favoriteListVC.prepareFilterArrayFavoriteList(searchText: self.textFieldSearch.text!)
                }
            })
        }
    }
    
    @IBAction func buttonSearchCloseAction(_ sender: UIButton) {
        self.textFieldSearch.text = ""
        self.buttonSearchClose.isHidden = true
        self.favoriteDateRangeVC.prepareFilterArrayFavoriteList(searchText: self.textFieldSearch.text!)
        self.favoriteOptInVC.prepareFilterArrayFavoriteList(searchText: self.textFieldSearch.text!)
        self.favoriteListVC.prepareFilterArrayFavoriteList(searchText: self.textFieldSearch.text!)
    }
    
    @IBAction func buttonFavoriteDateRangeAction(_ sender: UIButton) {
        if sender.isSelected == false{
            self.favoriteDateRangeVC.viewTimeSheet.removeFromSuperview()
        }
        self.setSelectedButton(buttonToSelect: sender)
    }
    
    @IBAction func buttonFavoriteOptInAction(_ sender: UIButton) {
        self.setSelectedButton(buttonToSelect: sender)
    }
    
    @IBAction func buttonFavoriteListAction(_ sender: UIButton) {
        self.setSelectedButton(buttonToSelect: sender)
    }
    
    private func setSelectedButton(buttonToSelect : UIButton){
        
        self.buttonFavoriteDateRange.isSelected = false
        self.buttonFavoriteOptIn.isSelected = false
        self.buttonFavoriteList.isSelected = false
        buttonToSelect.isSelected = true
        
        self.topBarSmallView.isHidden = false
        self.topBarLongView.isHidden = true
        
        self.containerViewFavoriteDateRange.isHidden = true
        self.containerViewFavoriteOptIn.isHidden = true
        self.containerViewFavoriteList.isHidden = true
        
        if buttonToSelect == buttonFavoriteDateRange{
            self.constraintExpandTopBarHeight.constant = self.TopBarExpandHeight
            self.topBarSmallView.isHidden = true
            self.topBarLongView.isHidden = false
            self.containerViewFavoriteDateRange.isHidden = false
        }else if buttonToSelect == buttonFavoriteOptIn{
            self.constraintExpandTopBarHeight.constant = self.TopBarSmallHeight
            self.labelNavTitle.text = Text.Label.text_FavoriteOptIn
            self.containerViewFavoriteOptIn.isHidden = false
        }else{
            self.constraintExpandTopBarHeight.constant = self.TopBarSmallHeight
            self.labelNavTitle.text = Text.Label.text_FavoriteList
            self.containerViewFavoriteList.isHidden = false
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Text.Segue.favoriteDateRangeVC {
            self.favoriteDateRangeVC = segue.destination as! WUFavoriteDateRangeViewController
            self.favoriteDateRangeVC.delegate = self
        }else if segue.identifier == Text.Segue.favoriteOptInVC {
            self.favoriteOptInVC = segue.destination as! WUFavoriteOptInViewController
            self.favoriteOptInVC.delegate = self
        }else if segue.identifier == Text.Segue.favoriteListVC{
            self.favoriteListVC = segue.destination as! WUFavoriteListViewController
            self.favoriteListVC.delegate = self
        }
    }
}
// MARK: - animationHeaderDelegate
extension WUFavoriteHomeViewController : animationHeaderDelegate {
    func animateHeaderView(scrollview: CGFloat) {
        if scrollview > 0 {
            self.segmentStackViewBottomCont.constant = 0.0
            self.segmentViewHeightCont.constant = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                if scrollview <= 0 {
                    self.segmentViewHeightCont.constant = 40.0
                    self.segmentStackViewBottomCont.constant = 2.0
                    self.view.layoutIfNeeded()
                }
            })
        }
    }
    
    func favoriteDateRangeTableCellLiveCamButtonClicked(cell: WUFavoriteDateRangeTableCell, withFavorite obj: Any) {
          self.favoriteDateRangeVC.verticalContentOffset  = self.favoriteDateRangeVC.tableViewFavoriterDateRange.contentOffset.y
        Utill.goToLivecamProfile(viewController: self, withLivecamM:  (obj as! [WUVenueLiveCams])[0])

       /* if let vc = UIStoryboard.home.get(WUPlayLiveCamViewController.self){
            self.favoriteDateRangeVC.verticalContentOffset  = self.favoriteDateRangeVC.tableViewFavoriterDateRange.contentOffset.y
            vc.hidesBottomBarWhenPushed = true
            vc.playLiveCamArray = obj as! [WUVenueLiveCams]
            self.navigationController?.pushViewController(vc, animated: false)
        }*/
    }
    
    func updateArrayWhenDeleteData(arrFavoriteVenueList : [WUVenueDetail]) {
        self.favoriteDateRangeVC.arrFavoriteVenueList = arrFavoriteVenueList
        self.favoriteOptInVC.arrFavoriteVenueList = arrFavoriteVenueList
        self.favoriteListVC.arrFavoriteVenueList = arrFavoriteVenueList
        self.textFieldSearch.text = ""
    }
    
    func venueProfileUpdateRating_Favorite(venueProfile obj: WUVenueDetail) {
        if self.favoriteVenueListData.count > 0 {
            let sectionTemp = self.favoriteVenueListData.index(where: {$0.FourSquareVenueID  == obj.FourSquareVenueID})
            if (sectionTemp! < self.favoriteVenueListData.count){
                
                let arrTopVenueRating = self.favoriteVenueListData.filter({$0.FourSquareVenueID == obj.FourSquareVenueID})
                if arrTopVenueRating.count > 0 {
                    if arrTopVenueRating.first?.IsUserFavoriteVenue != obj.IsUserFavoriteVenue{
                        //                        arrTopVenueRating.first?.IsUserFavoriteVenue = obj.IsUserFavoriteVenue
                        //                        let index = self.favoriteVenueListData.index(of: arrTopVenueRating.first!)
                        self.favoriteVenueListData.remove(at: sectionTemp!)
                        self.favoriteDateRangeVC.arrFavoriteVenueList = self.favoriteVenueListData
                        self.favoriteOptInVC.arrFavoriteVenueList = self.favoriteVenueListData
                        self.favoriteListVC.arrFavoriteVenueList = self.favoriteVenueListData
                        self.textFieldSearch.text = ""
                    }
                }
            }
        }
    }
    
    func didSelectButtonNoResult() {
        self.favoriteDateRangeVC.verticalContentOffset = 0
        self.favoriteOptInVC.verticalContentOffset = 0
        self.favoriteListVC.verticalContentOffset = 0
        self.initialDataSetup()
    }
}

// MARK: - UITextFieldDelegate
extension WUFavoriteHomeViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if ((textField.text?.count)! > 0) {
            self.buttonSearchClose.isHidden = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textRange = Range(range, in: textField.text!) {
            let finalText = textField.text!.replacingCharacters(in: textRange,with: string)
            self.favoriteDateRangeVC.prepareFilterArrayFavoriteList(searchText: finalText)
            self.favoriteOptInVC.prepareFilterArrayFavoriteList(searchText: finalText)
            self.favoriteListVC.prepareFilterArrayFavoriteList(searchText: finalText)
            if (finalText.count > 0) {
                self.buttonSearchClose.isHidden = false
            }else {
                self.buttonSearchClose.isHidden = true
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.buttonSearchClose.isHidden = true
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        self.buttonSearchClose.isHidden = true
        self.view.endEditing(true)
        return true
    }
}
