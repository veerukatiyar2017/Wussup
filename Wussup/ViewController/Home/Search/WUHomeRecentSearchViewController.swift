//
//  WUHomeRecentSearchViewController.swift
//  Wussup
//
//  Created by MAC219 on 5/3/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WUHomeRecentSearchViewControllerDelegate : class {
    func didSelectRecentSearch(selectedData : String)
}

extension WUHomeRecentSearchViewControllerDelegate{
    func didSelectRecentSearch(selectedData : String){
        
    }
}

class WUHomeRecentSearchViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var buttonGoToTop: UIButton!
    @IBOutlet private weak var labelNoResults           : UILabel!
    @IBOutlet private weak var tableViewRecentSearch    : UITableView!
    @IBOutlet private weak var buttonClear              : UIButton!
    
    // MARK: - Variables
    private var arrayRecentSearchList : [String]! = []
    var homeSearchVC : WUHomeSearchViewController!
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
        self.callWS_getRecentSearchList()
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
        homeSearchVC.delegate = self
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
    func callWS_getRecentSearchList(){
        WEB_API.call_api_GetRecentSearchList(user: GlobalShared.user) { (response, success, message) in
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
            }else{
                self.showNoResult(show: true)
            }
        }
    }
    
    private func clearRecentSearchList(){
        WEB_API.call_api_ClearRecentSearchList(user: GlobalShared.user) { (response, success, message) in
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
extension WUHomeRecentSearchViewController : UITableViewDelegate , UITableViewDataSource {
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
//MARK: - WUHomeSearchViewControllerDelegate
extension WUHomeRecentSearchViewController : WUHomeSearchViewControllerDelegate {
    func searchBarDidBeginEditing(homeSearchViewController: WUHomeSearchViewController) {
        self.tableViewRecentSearch.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(KEYBOARD_SIZE), right: 0)
    }
    
    func searchBarDidEndEditing(homeSearchViewController: WUHomeSearchViewController) {
        self.tableViewRecentSearch.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
   
}
