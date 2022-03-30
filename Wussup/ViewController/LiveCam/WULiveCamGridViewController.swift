//
//  WULiveCamGridViewController.swift
//  Wussup
//
//  Created by MAC219 on 7/17/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class WULiveCamGridViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableViewLiveCamGrid                     : UITableView!
    @IBOutlet private weak var imageViewIcon                    : UIImageView!
    @IBOutlet private weak var labelTitle                       : UILabel!
    @IBOutlet private weak var viewSeparator                    : UIView!
    @IBOutlet private weak var collectionViewLiveCamGrid        : UICollectionView!
    @IBOutlet private weak var buttonGoToTop                    : UIButton!
    @IBOutlet private weak var viewFooter                       : UIView!
    @IBOutlet private weak var buttonNoResults                  : UIButton!
    
    //MARK: - Variable
    var verticalContentOffset   : CGFloat!
    var tapGesture              = UITapGestureRecognizer()
    weak var delegate           : WULiveCamAnimationDelagate?
    private var arrCollectionDataCopy : [WUVenueLiveCams] = []
    var arrFilteredLiveCamList : [WUVenueLiveCams] = []
    var arrLiveCamList         : [WUVenueLiveCams] = [] {
        didSet{
            self.prepareFilterArrayLiveCamList(searchText: "")
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
        self.viewSeparator.backgroundColor = .LiveCamSepratorColor
        self.tableViewLiveCamGrid.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.tableViewLiveCamGrid.frame.width, height: 209.0)
        self.tableViewLiveCamGrid.isHidden = true
        self.buttonNoResults.setTitle(Text.Message.noDataFound, for: .normal)
    }
    
    private func manageNoResultLabel(){
        if self.arrFilteredLiveCamList.count > 0 {
            self.prepareViewForTableviewHeader()
            self.tableViewLiveCamGrid.isHidden = false
            self.buttonNoResults.isHidden = true
            if self.tableViewLiveCamGrid.contentSize.height  > (UIScreen.main.bounds.height - 77){
                self.buttonGoToTop.isHidden = false
            }else{
                self.buttonGoToTop.isHidden = true
                self.buttonGoToTop.isSelected = false
            }
        }else{
            if let superView = (self.parent as? WULiveCamHomeViewController) {
                if (superView.textFieldSearch.text?.count)! > 0 {
                    self.buttonNoResults.isUserInteractionEnabled = false
                }else{
                    self.buttonNoResults.isUserInteractionEnabled = true
                }
            }
            self.buttonNoResults.isHidden = false
            self.tableViewLiveCamGrid.isHidden = true
            self.buttonGoToTop.isHidden = true
        }
        self.collectionViewLiveCamGrid.reloadData()
        
        if self.arrCollectionDataCopy.count % 2 == 0 {
            self.tableViewLiveCamGrid.tableFooterView?.frame = CGRect(x: 0, y: 0, width: Int(self.tableViewLiveCamGrid.frame.width), height:((self.arrCollectionDataCopy.count/2)*172))
        }else {
            self.tableViewLiveCamGrid.tableFooterView?.frame = CGRect(x: 0, y: 0, width: Int(self.tableViewLiveCamGrid.frame.width), height:(((self.arrCollectionDataCopy.count + 1)/2)*172))
        }
        self.tableViewLiveCamGrid.tableFooterView = self.viewFooter
        UIView.performWithoutAnimation  {
            self.tableViewLiveCamGrid.reloadData();
            self.tableViewLiveCamGrid.layoutIfNeeded();
        }
    }
    
    func prepareFilterArrayLiveCamList(searchText : String){
        self.arrFilteredLiveCamList = self.arrLiveCamList.clone()
        self.buttonGoToTop.isHidden = true
        self.buttonGoToTop.isSelected = false
        if searchText != ""{
            let filteredLiveCam  = self.arrFilteredLiveCamList.filter { $0.Name.containsIgnoringCase(find: searchText)}
            self.arrFilteredLiveCamList = filteredLiveCam
        }
        self.manageNoResultLabel()
    }
    
    private func prepareViewForTableviewHeader(){
        //        if self.arrFilteredLiveCamList.count > 0 {
        //
        //        }
        self.arrCollectionDataCopy = self.arrFilteredLiveCamList.map { $0 }
        self.imageViewIcon.sd_imageIndicator = SDWebImageActivityIndicator.white
//        self.imageViewIcon.sd_setIndicatorStyle(.white)
//        self.imageViewIcon.sd_setShowActivityIndicatorView(true)
        self.imageViewIcon.sd_setImage(with: URL(string: self.arrCollectionDataCopy[0].ImageURL), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: .refreshCached)
        self.labelTitle.text = self.arrCollectionDataCopy[0].Name
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerDidSelect(_:)))
        self.tapGesture.numberOfTapsRequired = 1
        self.tableViewLiveCamGrid.tableHeaderView?.addGestureRecognizer(self.tapGesture)
        self.arrCollectionDataCopy =  Array(self.arrFilteredLiveCamList.dropFirst())
    }
    
    // MARK: - Action Methods
    @IBAction func buttonNoResultsAction(_ sender: Any) {
        if let delegate = self.delegate{
            delegate.didSelectButtonNoResult()
        }
    }
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton){
        self.buttonGoToTop.isSelected = true
        self.tableViewLiveCamGrid.setContentOffset(CGPoint.zero, animated: true)
        if let delegate = self.delegate {
            delegate.animateHeaderView(scrollview: -5.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.buttonGoToTop.isSelected = false
            })
        }
    }
    
    @objc func headerDidSelect(_ sender : UITapGestureRecognizer) {
        self.verticalContentOffset  = self.tableViewLiveCamGrid.contentOffset.y
        Utill.goToLivecamProfile(viewController: self, withLivecamM:  self.arrFilteredLiveCamList[0])
    }
    
}
//MARK: - TableView
extension WULiveCamGridViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout , UITableViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCollectionDataCopy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WULiveCamGridCollectionCell()), for: indexPath)as! WULiveCamGridCollectionCell
        cell.liveCamVenue = self.arrCollectionDataCopy[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.verticalContentOffset  = self.tableViewLiveCamGrid.contentOffset.y
        Utill.goToLivecamProfile(viewController: self, withLivecamM: self.arrCollectionDataCopy[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:((UIScreen.main.bounds.size.width - (2*10))/2) , height: 172.0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableViewLiveCamGrid.contentSize.height  > (UIScreen.main.bounds.height - 77){
            Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
            if self.buttonGoToTop.isSelected == false{
                if let delegate = self.delegate {
                    delegate.animateHeaderView(scrollview: scrollView.contentOffset.y)
                }
            }
        }else {
            if let superView = self.parent as? WULiveCamHomeViewController {
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
