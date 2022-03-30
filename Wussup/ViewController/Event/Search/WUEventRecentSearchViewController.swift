//
//  WUEventRecentSearchViewController.swift
//  Wussup
//
//  Created by MAC219 on 6/13/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUEventRecentSearchViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var buttonGoToTop            : UIButton!
    @IBOutlet private weak var labelNoResults           : UILabel!
    @IBOutlet private weak var tableViewRecentSearch    : UITableView!
    @IBOutlet private weak var buttonClear              : UIButton!
    
    // MARK: - Variables
    private var arrayRecentSearchList : [String]! = []
    var eventSearchVC : WUEventSearchViewController!
    weak var delegate : WUHomeRecentSearchViewControllerDelegate?
    
    var refreshRecentSearch = false{
        didSet{
            if self.refreshRecentSearch{
                //                self.getRecentSearchList()
            }
        }
    }
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetup()
        self.getRecentSearchList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetup() {
        self.tableViewRecentSearch.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUTitleTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUTitleTableCell()))
        eventSearchVC.delegate = self
        self.tableViewRecentSearch.tableFooterView?.isHidden = true
        self.buttonGoToTop.isHidden = true
        self.labelNoResults.text = Text.Message.noDataFound
    }
    
    //MARK: - Show Label Of No Result Found
    private func showNoResult(show : Bool){
        if show{
            self.buttonClear.isHidden = true
            self.labelNoResults.isHidden = false
            self.tableViewRecentSearch.isScrollEnabled = false
            self.buttonGoToTop.isHidden = true
        }else{
            self.buttonClear.isHidden = false
            self.labelNoResults.isHidden = true
            self.buttonGoToTop.isHidden = false
            self.tableViewRecentSearch.isScrollEnabled = true
        }
    }
    
    // MARK: - Webservice Methods
    func getRecentSearchList(){
        WEB_API.call_api_GetRecentEventSearchList(user: GlobalShared.user) { (response, success, message) in
            if success{
                let data = try! JSONSerialization.data(withJSONObject: response?["RecentSearchList"].arrayObject ?? [:], options: [])
                self.arrayRecentSearchList = try! JSONDecoder().decode([String].self, from: data)
                self.tableViewRecentSearch.reloadData()
                if self.arrayRecentSearchList.count == 0 {
                    self.showNoResult(show: true)
                }else{
                    self.showNoResult(show: false)
                }
                 Utill.printInTOConsole(printData:"response: \(response ?? "")")
            }
        }
    }
    
    private func clearRecentSearchList(){
        WEB_API.call_api_ClearEventRecentSearchList(user: GlobalShared.user) { (response, success, message) in
            if success{
                self.arrayRecentSearchList.removeAll()
                self.tableViewRecentSearch.reloadData()
                self.showNoResult(show: true)
                 Utill.printInTOConsole(printData:"response: \(response ?? "")")
            }
        }
    }
    
    // MARK: - Action Methods
    @IBAction func buttonClearAction(_ sender: UIButton) {
        self.clearRecentSearchList()
    }
    @IBAction func buttonGoToTopAction(_ sender: Any) {
        self.tableViewRecentSearch.setContentOffset(CGPoint.zero, animated: true)
    }
}

//MARK: - TableView
extension WUEventRecentSearchViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayRecentSearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUTitleTableCell()), for: indexPath)as! WUTitleTableCell
        cell.labelTitle.text = self.arrayRecentSearchList[indexPath.row]
        if indexPath.row == self.arrayRecentSearchList.count - 1 {
            if self.tableViewRecentSearch.contentSize.height > self.tableViewRecentSearch.frame.size.height{
                self.tableViewRecentSearch.tableFooterView?.isHidden = false
            }else{
                self.tableViewRecentSearch.tableFooterView?.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delegate != nil {
            self.delegate?.didSelectRecentSearch(selectedData: arrayRecentSearchList[indexPath.row])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
    }
}

//MARK: - WUEventSearchViewControllerDelegate
extension WUEventRecentSearchViewController : WUEventSearchViewControllerDelegate {
    func searchBarDidBeginEditing(eventSearchViewController: WUEventSearchViewController) {
        self.tableViewRecentSearch.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(KEYBOARD_SIZE), right: 0)
    }
    
    func searchBarDidEndEditing(eventSearchViewController: WUEventSearchViewController) {
        self.tableViewRecentSearch.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
