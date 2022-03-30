//
//  WUHomeSearchFoodCategoryViewController.swift
//  Wussup
//
//  Created by MAC219 on 7/19/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WUHomeSearchFoodCategoryViewControllerDelegate : class {
    func didSelectFoodCategorySearch(selectedCategoryData : WUCategory)
}
extension WUHomeSearchFoodCategoryViewControllerDelegate {
    func didSelectFoodCategorySearch(selectedCategoryData : WUCategory){
        
    }
}
class WUHomeSearchFoodCategoryViewController: UIViewController {
    
    @IBOutlet private weak var labelNoResults           : UILabel!
    @IBOutlet private weak var buttonGoToTop            : UIButton!
    @IBOutlet  weak var tableViewFoodCategory   : UITableView!
    @IBOutlet private weak var viewHeader               : UIView!
    var categoryDictionary      = [String   : [WUCategory]]()
    var categorySectionTitles   = [String]()
    var categoryNames           = [String]()
    weak var delegate : WUHomeSearchFoodCategoryViewControllerDelegate?
    
    var arrayFilterFoodCategories : [WUCategory] = []
    
    var arrayFoodCategories : [WUCategory] = [] {
        didSet{
            self.prepareFilterArrayFoodCategoryList(searchText: "")
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
        self.tableViewFoodCategory.isHidden = true
        self.labelNoResults.text = Text.Message.noResultsFound
        self.tableViewFoodCategory.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUSearchFoodTableCell()), bundle: nil), forCellReuseIdentifier: Utill.getClassNameFor(classType: WUSearchFoodTableCell()))
        self.tableViewFoodCategory.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableViewFoodCategory.tableHeaderView = viewHeader
        let headerNib = UINib.init(nibName: Utill.getClassNameFor(classType: WUEventSectionHeaderView()), bundle: Bundle.main)
        self.tableViewFoodCategory.register(headerNib, forHeaderFooterViewReuseIdentifier: Utill.getClassNameFor(classType: WUEventSectionHeaderView()))
    }

    private func manageNoResultLabel(){
        if self.arrayFilterFoodCategories.count > 0 {
            self.tableViewFoodCategory.isHidden = false
            self.labelNoResults.isHidden = true
            self.buttonGoToTop.isHidden = false
        }else{
            self.labelNoResults.isHidden = false
            self.tableViewFoodCategory.isHidden = true
            self.buttonGoToTop.isHidden = true
        }
        self.tableViewFoodCategory.reloadData()
    }
    
    func prepareFilterArrayFoodCategoryList(searchText : String){
        
        if self.arrayFoodCategories.count > 0 {
            self.categorySectionTitles.removeAll()
            self.categoryDictionary.removeAll()
            
            self.arrayFilterFoodCategories = self.arrayFoodCategories.clone()
            if searchText != ""{
                let filteredEvents  = self.arrayFoodCategories.filter { $0.Name.containsIgnoringCase(find: searchText)}
                self.arrayFilterFoodCategories = filteredEvents
            }
            for category in self.arrayFilterFoodCategories {
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
            self.manageNoResultLabel()
        }
    }
    
    // MARK: - Webservice calls
    func callWS_getFoodCategory() {
        self.arrayFoodCategories.removeAll()
        self.arrayFilterFoodCategories.removeAll()
        self.categoryNames.removeAll()
        self.categorySectionTitles.removeAll()
        self.categoryDictionary.removeAll()
        self.tableViewFoodCategory.reloadData()
        
        WEB_API.call_api_GetFoodCategoryList { (response,status,message) in
            if status == true{
                let data = try! JSONSerialization.data(withJSONObject: (response!["Categories"]).arrayObject ?? [], options: [])
                let arrCategoris = try! JSONDecoder().decode([WUCategory].self, from: data)
                self.arrayFoodCategories = arrCategoris
                Utill.printInTOConsole(printData:"\(arrCategoris)")
            }else {
                Utill.showAlertView(viewController: self, message: message)
            }
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.tableViewFoodCategory.setContentOffset(CGPoint.zero, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}
//MARK: - UITableView
extension WUHomeSearchFoodCategoryViewController : UITableViewDelegate, UITableViewDataSource{
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
        return 44.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUSearchFoodTableCell()), for: indexPath)as! WUSearchFoodTableCell
        let categoryKey = self.categorySectionTitles[indexPath.section]
        if let categoryValues = self.categoryDictionary[categoryKey] {
            cell.foodCategory = categoryValues[indexPath.row]
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryKey = self.categorySectionTitles[indexPath.section]
        let categoryValues = self.categoryDictionary[categoryKey]
        
        if let delegate = self.delegate {
            delegate.didSelectFoodCategorySearch(selectedCategoryData: categoryValues![indexPath.row])
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.categorySectionTitles
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
    }
}
