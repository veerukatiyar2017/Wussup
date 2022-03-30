//
//  WUEventCategoriesViewController.swift
//  Wussup
//
//  Created by MAC26 on 24/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WUEventCategoriesViewControllerDelegate : class{
    func didSelectCategoryTableCell(cell : WUTitleTableCell , eventObj : WUEventCategories)
    func animateHeaderView(scrollview: CGFloat)
    func didSelectButtonNoResultAction()
}

extension WUEventCategoriesViewControllerDelegate {
    func didSelectCategoryTableCell(cell : WUTitleTableCell , eventObj : WUEventCategories){
        
    }
    func animateHeaderView(scrollview: CGFloat){
        
    }
    func didSelectButtonNoResultAction(){
        
    }
}

class WUEventCategoriesViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var buttonGoToTop            : UIButton!
    @IBOutlet weak var tableViewEventCategory           : UITableView!
    @IBOutlet private weak var buttonNoResults          : UIButton!

    
    //MARK: - Variables
    var categoryDictionary      = [String   : [WUEventCategories]]()
    var categorySectionTitles   = [String]()
    var categoryNames           = [String]()
    weak var delegate           : WUEventCategoriesViewControllerDelegate?
    var arrEventCategoryList    : [WUEventCategories] = [] {
        didSet{
            self.manageNoResultLabel()
        }
    }
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialInterfaceSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        self.buttonGoToTop.isHidden = true
        self.buttonGoToTop.isSelected = false
        self.tableViewEventCategory.isHidden = true
        self.buttonNoResults.setTitle(Text.Message.noDataFound, for: .normal)
        self.tableViewEventCategory.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUTitleTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUTitleTableCell()))
        self.tableViewEventCategory.contentInset = UIEdgeInsetsMake(00, 0, -20, 0)
        let headerNib = UINib.init(nibName: Utill.getClassNameFor(classType: WUEventSectionHeaderView()), bundle: Bundle.main)
        self.tableViewEventCategory.register(headerNib, forHeaderFooterViewReuseIdentifier: Utill.getClassNameFor(classType: WUEventSectionHeaderView()))
    }
    
    private func initialDataSetup(){
        self.categorySectionTitles.removeAll()
        self.categoryDictionary.removeAll()
        for category in self.arrEventCategoryList {
            let categoryKey = String(category.Name.prefix(1)).uppercased()
            if var categoryValues = self.categoryDictionary[categoryKey] {
                categoryValues.append(category)
                self.categoryDictionary[categoryKey] = categoryValues
            } else {
                self.categoryDictionary[categoryKey] = [category]
            }
        }
        self.categorySectionTitles = [String](self.categoryDictionary.keys)
        self.categorySectionTitles = self.categorySectionTitles.sorted(by: { $0 < $1 })
        self.tableViewEventCategory.reloadData()
    }
    
    private func manageNoResultLabel(){
        if self.arrEventCategoryList.count > 0 {
            self.initialDataSetup()
            self.tableViewEventCategory.isHidden = false
            self.buttonNoResults.isHidden = true
            if self.tableViewEventCategory.contentSize.height  > (UIScreen.main.bounds.height - 77){
                self.buttonGoToTop.isHidden = false
            }else{
                self.buttonGoToTop.isHidden = true
                self.buttonGoToTop.isSelected = false
            }
        }else{
            self.buttonNoResults.isHidden = false
            self.tableViewEventCategory.isHidden = true
            self.buttonGoToTop.isHidden = true
        }
        self.tableViewEventCategory.reloadData()
    }
    
    // MARK: - Action Methods
    @IBAction func buttonNoResultsAction(_ sender: Any) {
        if let delegate = self.delegate{
            delegate.didSelectButtonNoResultAction()
        }
    }
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.buttonGoToTop.isSelected = true
        self.tableViewEventCategory.setContentOffset(CGPoint.zero, animated: true)
        
        if let delegate = self.delegate {
            delegate.animateHeaderView(scrollview: -5.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.buttonGoToTop.isSelected = false
            })
        }
    }
}

// MARK: - UITableView
extension WUEventCategoriesViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categorySectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 57.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        let headerView = WUEventSectionHeaderView.instanceFromNib()
        //        headerView.frame = CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 100.0))
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Utill.getClassNameFor(classType: WUEventSectionHeaderView())) as! WUEventSectionHeaderView
        headerView.isLoadForABC = true
        headerView.eventCategoryFirstLetter = self.categorySectionTitles[section]
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoryKey = self.categorySectionTitles[section]
        if let categoryValues = self.categoryDictionary[categoryKey] {
            return categoryValues.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUTitleTableCell()), for: indexPath)as! WUTitleTableCell
        let categoryKey = self.categorySectionTitles[indexPath.section]
        if let categoryValues = self.categoryDictionary[categoryKey] {
            cell.labelTitle.text = categoryValues[indexPath.row].Name
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableViewEventCategory.cellForRow(at: indexPath) as! WUTitleTableCell
        let categoryKey = self.categorySectionTitles[indexPath.section]
        let categoryValues = self.categoryDictionary[categoryKey]
        
        if let delegate = self.delegate {
            delegate.didSelectCategoryTableCell(cell: cell, eventObj: categoryValues![indexPath.row])
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.categorySectionTitles
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)  {
        if self.buttonGoToTop.isSelected == false{
            if self.tableViewEventCategory.contentSize.height  > (UIScreen.main.bounds.height - 77){
                Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
                if let delegate = self.delegate {
                    delegate.animateHeaderView(scrollview: scrollView.contentOffset.y)
                }
            }
        }else {
            if let superView = self.parent as? WUEventHomeViewController {
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
