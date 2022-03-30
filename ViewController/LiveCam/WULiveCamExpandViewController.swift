//
//  WULiveCamExpandViewController.swift
//  Wussup
//
//  Created by MAC219 on 7/17/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
//MARK: - Delegate
protocol WULiveCamAnimationDelagate : class {
    func animateHeaderView(scrollview : CGFloat)
    func liveCamPlayButtonClicked(cell : WULiveCamExpandTableCell, withLiveCam obj : WUVenueLiveCams)
    func didSelectButtonNoResult()
}

extension WULiveCamExpandTableCellDelegate {
    func animateHeaderView(scrollview : CGFloat){
        
    }
    func liveCamPlayButtonClicked(cell : WULiveCamExpandTableCell, withLiveCam obj : WUVenueLiveCams){
        
    }
    func didSelectButtonNoResult(){
        
    }
}

class WULiveCamExpandViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableViewLiveCamExpand       : UITableView!
    @IBOutlet private weak var buttonGoToTop        : UIButton!
    @IBOutlet private weak var buttonNoResults      : UIButton!
    
    //MARK: - Variable
    var verticalContentOffset : CGFloat!
    weak var delegate : WULiveCamAnimationDelagate?
    var arrFilteredLiveCamList : [WUVenueLiveCams] = []
    var arrLiveCamList  : [WUVenueLiveCams] = [] {
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
        self.tableViewLiveCamExpand.isHidden = true
        self.buttonNoResults.setTitle(Text.Message.noDataFound, for: .normal)
    }
    
    private func manageNoResultLabel(){
        if self.arrFilteredLiveCamList.count > 0 {
            self.tableViewLiveCamExpand.isHidden = false
            self.buttonNoResults.isHidden = true
            if self.tableViewLiveCamExpand.contentSize.height  > (UIScreen.main.bounds.height - 125){
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
            self.tableViewLiveCamExpand.isHidden = true
            self.buttonGoToTop.isHidden = true
        }
        UIView.performWithoutAnimation  {
            self.tableViewLiveCamExpand.reloadData();
            self.tableViewLiveCamExpand.layoutIfNeeded();
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
    
    // MARK: - Action Methods
    @IBAction func buttonNoResultsAction(_ sender: Any) {
        if let delegate = self.delegate{
            delegate.didSelectButtonNoResult()
        }
    }
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.buttonGoToTop.isSelected = true
        self.tableViewLiveCamExpand.setContentOffset(CGPoint.zero, animated: true)
        if let delegate = self.delegate {
            delegate.animateHeaderView(scrollview: -5.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.buttonGoToTop.isSelected = false
            })
        }
        
    }
}
//MARK: - TableView
extension WULiveCamExpandViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFilteredLiveCamList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 181.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WULiveCamExpandTableCell())) as! WULiveCamExpandTableCell
        cell.delegate = self
        cell.liveCamVenue = self.arrFilteredLiveCamList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Utill.printInTOConsole(printData:"DAteRange Cell")
        FirebaseManager.sharedInstance.play_livecam_GUID_ios(parameter: nil, playLiveCamM: self.arrFilteredLiveCamList[indexPath.row])
        self.verticalContentOffset  = self.tableViewLiveCamExpand.contentOffset.y
        Utill.goToLivecamProfile(viewController: self, withLivecamM: self.arrFilteredLiveCamList[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableViewLiveCamExpand.contentSize.height  > (UIScreen.main.bounds.height - 125){
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
//MARK: - WULiveCamExpandTableCellDelegate
extension WULiveCamExpandViewController : WULiveCamExpandTableCellDelegate {
    func expandTableCellLiveCamPlayButtonClicked(cell: WULiveCamExpandTableCell, withLiveCam obj: WUVenueLiveCams) {
        if let delegate = self.delegate {
            delegate.liveCamPlayButtonClicked(cell: cell, withLiveCam: obj)
        }
    }
    
    
}
