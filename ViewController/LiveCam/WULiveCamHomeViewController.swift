//
//  WULiveCamHomeViewController.swift
//  Wussup
//
//  Created by MAC219 on 7/17/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WULiveCamHomeViewController: UIViewController {
    
    // MARK: - Constants
    let TopBarExpandHeight = CGFloat(125.0)
    let TopBarSmallHeight = CGFloat(77.0)
    
    // MARK: - IBOutlet
    @IBOutlet private weak var topBarLongView                   : UIView!
    @IBOutlet private weak var topBarSmallView                  : UIView!
    @IBOutlet private weak var constraintExpandTopBarHeight     : NSLayoutConstraint!
    @IBOutlet private weak var labelNavTitle                    : UILabel!
    @IBOutlet weak var buttonLiveCamExpand                      : UIButton!
    @IBOutlet weak var buttonLiveCamGrid                        : UIButton!
    @IBOutlet weak var buttonLiveCamList                        : UIButton!
    @IBOutlet private weak var containerViewLiveCamExpand       : UIView!
    @IBOutlet private weak var containerViewLiveCamGrid         : UIView!
    @IBOutlet private weak var containerViewLiveCamList         : UIView!
    @IBOutlet  weak var segmentViewHeightCont                   : NSLayoutConstraint!
    @IBOutlet  weak var segmentStackViewBottomCont              : NSLayoutConstraint!
    @IBOutlet private weak var buttonSearchSmallView            : UIButton!
    @IBOutlet private weak var buttonSearchExpandView           : UIButton!
    @IBOutlet  weak var textFieldSearch                         : UITextField!
    @IBOutlet private weak var buttonSearchClose                : UIButton!
    @IBOutlet private weak var viewSearchHeightCont             : NSLayoutConstraint!
    
    
    // MARK: - Variable
    var LiveCamExpandVC     : WULiveCamExpandViewController!
    var LiveCamGridVC       : WULiveCamGridViewController!
    var LiveCamListVC       : WULiveCamListViewController!
    var liveCamData         : [WUVenueLiveCams]   = []
    var bannerData         : [WUHomeBannerList]   = []
    
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
        self.setSelectedButton(buttonToSelect: self.buttonLiveCamExpand)
        self.segmentViewHeightCont.constant = 40.0
        self.segmentStackViewBottomCont.constant = 2.0
        
        self.buttonSearchClose.isHidden = true
        self.buttonSearchClose.frame = CGRect(x: (self.textFieldSearch.frame.size.width), y: 10.0.propotionalHeight, width: (self.buttonSearchClose.imageView?.image?.size.width)! + 10.0, height: 20.0)
        self.buttonSearchClose.addTarget(self, action: #selector(self.buttonSearchCloseAction(_:)), for: .touchUpInside)
        self.textFieldSearch.rightView = self.buttonSearchClose
        self.textFieldSearch.rightViewMode = .always
        
        
        self.callWS_GetLiveCamList()
    }
    
    private func initialDataSetup(){
        self.callWS_GetLiveCamList()
    }
    
    private func manageContentOffset(){
        if self.buttonLiveCamExpand.isSelected == true{
            if self.LiveCamExpandVC.verticalContentOffset != nil {
                DispatchQueue.main.async {
                    let offset = CGPoint.init(x: 0, y:self.LiveCamExpandVC.verticalContentOffset)
                    self.LiveCamExpandVC.tableViewLiveCamExpand.setContentOffset(offset, animated: false)
                }
            }
        }else if self.buttonLiveCamGrid.isSelected == true {
            if self.LiveCamGridVC.verticalContentOffset != nil {
                DispatchQueue.main.async {
                    let offset = CGPoint.init(x: 0, y:self.LiveCamGridVC.verticalContentOffset)
                    self.LiveCamGridVC.tableViewLiveCamGrid.setContentOffset(offset, animated: false)
                }
            }
        }else {
            if self.buttonLiveCamGrid.isSelected == true {
                if self.LiveCamListVC.verticalContentOffset != nil {
                    DispatchQueue.main.async {
                        let offset = CGPoint.init(x: 0, y:self.LiveCamListVC.verticalContentOffset)
                        self.LiveCamListVC.tableViewLiveCamList.setContentOffset(offset, animated: false)
                    }
                }
            }
        }
    }
    
    // MARK: - Webservice calls
    func callWS_GetLiveCamList(){
        self.buttonSearchExpandView.isSelected = false
        self.buttonSearchSmallView.isSelected = false
        self.viewSearchHeightCont.constant = 0.0
        
        WEB_API.call_api_GetLiveCamList { (response, success, message) in
            Utill.printInTOConsole(printData:"response: \(response ?? "")")
            if success == true{
                let bannerListData = try! JSONSerialization.data(withJSONObject: response?["BannerList"].arrayObject ?? [], options: [])
                self.bannerData = try! JSONDecoder().decode([WUHomeBannerList].self, from: bannerListData)
                Utill.saveHomeBannerModel(self.bannerData)
                
                let data = try! JSONSerialization.data(withJSONObject: response?["LiveCamsURLs"].arrayObject ?? [], options: [])
                self.liveCamData = try! JSONDecoder().decode([WUVenueLiveCams].self, from: data)
                self.LiveCamExpandVC.arrLiveCamList = self.liveCamData
                self.LiveCamGridVC.arrLiveCamList = self.liveCamData
                self.LiveCamListVC.arrLiveCamList = self.liveCamData
                
            }else{
                self.LiveCamExpandVC.arrLiveCamList = []
                self.LiveCamGridVC.arrLiveCamList = []
                self.LiveCamListVC.arrLiveCamList = []
            }
        }
    }
    
    
    // MARK: - Action Methods
    @IBAction func buttonSearchAction(_ sender: UIButton) {
        if self.buttonLiveCamExpand.isSelected == true {
            self.LiveCamExpandVC.verticalContentOffset  = self.LiveCamExpandVC.tableViewLiveCamExpand.contentOffset.y
        }
        else if self.buttonLiveCamGrid.isSelected == true  {
            self.LiveCamGridVC.verticalContentOffset  = self.LiveCamGridVC.tableViewLiveCamGrid.contentOffset.y
        }else {
            self.LiveCamListVC.verticalContentOffset  = self.LiveCamListVC.tableViewLiveCamList.contentOffset.y
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
                    self.LiveCamExpandVC.prepareFilterArrayLiveCamList(searchText: self.textFieldSearch.text!)
                    self.LiveCamGridVC.prepareFilterArrayLiveCamList(searchText: self.textFieldSearch.text!)
                    self.LiveCamListVC.prepareFilterArrayLiveCamList(searchText: self.textFieldSearch.text!)
                }
            })
        }
    }
    
    @IBAction func buttonSearchCloseAction(_ sender: UIButton) {
        self.textFieldSearch.text = ""
        self.buttonSearchClose.isHidden = true
        self.LiveCamExpandVC.prepareFilterArrayLiveCamList(searchText: self.textFieldSearch.text!)
        self.LiveCamGridVC.prepareFilterArrayLiveCamList(searchText: self.textFieldSearch.text!)
        self.LiveCamListVC.prepareFilterArrayLiveCamList(searchText: self.textFieldSearch.text!)
    }
    
    @IBAction func buttonLiveCamExpandAction(_ sender: UIButton) {
        self.setSelectedButton(buttonToSelect: sender)
    }
    
    @IBAction func buttonLiveCamGridAction(_ sender: UIButton) {
        self.setSelectedButton(buttonToSelect: sender)
    }
    
    @IBAction func buttonLiveCamListAction(_ sender: UIButton) {
        self.setSelectedButton(buttonToSelect: sender)
    }
    
    private func setSelectedButton(buttonToSelect : UIButton){
        self.buttonLiveCamExpand.isSelected = false
        self.buttonLiveCamGrid.isSelected = false
        self.buttonLiveCamList.isSelected = false
        buttonToSelect.isSelected = true
        
        self.topBarSmallView.isHidden = false
        self.topBarLongView.isHidden = true
        
        self.containerViewLiveCamExpand.isHidden = true
        self.containerViewLiveCamGrid.isHidden = true
        self.containerViewLiveCamList.isHidden = true
        
        if buttonToSelect == buttonLiveCamExpand{
            self.constraintExpandTopBarHeight.constant = self.TopBarExpandHeight
            self.topBarSmallView.isHidden = true
            self.topBarLongView.isHidden = false
            self.containerViewLiveCamExpand.isHidden = false
            
        }else if buttonToSelect == buttonLiveCamGrid{
            self.constraintExpandTopBarHeight.constant = self.TopBarSmallHeight
            self.labelNavTitle.text = Text.Label.text_LiveCamGrid
            self.containerViewLiveCamGrid.isHidden = false
        }else{
            self.constraintExpandTopBarHeight.constant = self.TopBarSmallHeight
            self.labelNavTitle.text = Text.Label.text_LiveCamList
            self.containerViewLiveCamList.isHidden = false
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Text.Segue.LiveCamExpandVC {
            self.LiveCamExpandVC = segue.destination as! WULiveCamExpandViewController
            self.LiveCamExpandVC.delegate = self
        }else if segue.identifier == Text.Segue.LiveCamGridVC {
            self.LiveCamGridVC = segue.destination as! WULiveCamGridViewController
            self.LiveCamGridVC.delegate = self
        }else if segue.identifier == Text.Segue.LiveCamListVC{
            self.LiveCamListVC = segue.destination as! WULiveCamListViewController
            self.LiveCamListVC.delegate = self
        }
    }
}

//MARK:- WULiveCamAnimationDelagate
extension WULiveCamHomeViewController : WULiveCamAnimationDelagate {
    
    func liveCamPlayButtonClicked(cell: WULiveCamExpandTableCell, withLiveCam obj: WUVenueLiveCams) {
        Utill.goToLivecamProfile(viewController: self, withLivecamM:  obj)
    }
    
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
    
    func didSelectButtonNoResult() {
        self.LiveCamExpandVC.verticalContentOffset = 0
        self.LiveCamGridVC.verticalContentOffset = 0
        self.LiveCamListVC.verticalContentOffset = 0
        self.callWS_GetLiveCamList()
    }
}

// MARK: - UITextFieldDelegate
extension WULiveCamHomeViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if ((textField.text?.count)! > 0) {
            self.buttonSearchClose.isHidden = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textRange = Range(range, in: textField.text!) {
            let finalText = textField.text!.replacingCharacters(in: textRange,with: string)
            self.LiveCamExpandVC.prepareFilterArrayLiveCamList(searchText: finalText)
            self.LiveCamGridVC.prepareFilterArrayLiveCamList(searchText: finalText)
            self.LiveCamListVC.prepareFilterArrayLiveCamList(searchText: finalText)
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
