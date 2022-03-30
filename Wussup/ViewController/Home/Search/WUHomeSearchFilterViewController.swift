//
//  WUHomeSearchFilterViewController.swift
//  Wussup
//
//  Created by MAC219 on 5/3/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WUHomeSearchFilterViewControllerDelegate : class {
    func filterDoneButtonSelected(arraySelectedFilter : [WUSearchFilters])
}
extension WUHomeSearchFilterViewControllerDelegate{
    func filterDoneButtonSelected(arraySelectedFilter : [WUSearchFilters]){
        
    }
}

class WUHomeSearchFilterViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet private var tableViewFilterCategory    : UITableView!
    @IBOutlet  weak var buttonDone            : UIButton!

   
    // MARK: - Variables
    weak var delegate : WUHomeSearchFilterViewControllerDelegate?
    var arrayAllFilterCategory : [WUSearchFilters] = []{
        didSet{
            self.tableViewFilterCategory.reloadData()
        }
    }
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.buttonDone.isSelected = false
//        self.buttonDone.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Done, color: .btnLightGrayColor ), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetup() {
        self.tableViewFilterCategory.backgroundColor = UIColor.DarkGrayColor
        
        self.tableViewFilterCategory.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.tableViewFilterCategory.frame.width, height: 72.0.propotionalHeight)
        self.tableViewFilterCategory.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.tableViewFilterCategory.frame.width, height: 85.0.propotionalHeight)
    }
    
    // MARK: - Action Methods
    @IBAction func buttonDoneAction(_ sender: UIButton) {
//        self.buttonDone.isSelected = true
//        self.buttonDone.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Done, color: .SearchBarYellowColor ), for: .normal)
        if let delegate = self.delegate{
            let arraySelectedFilter  = self.arrayAllFilterCategory.filter { $0.isSelected == true}
            delegate.filterDoneButtonSelected(arraySelectedFilter: arraySelectedFilter)
        }
    }
}

//MARK: - TableView
extension WUHomeSearchFilterViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayAllFilterCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUHomeSearchFilterCell()), for: indexPath) as! WUHomeSearchFilterCell
        cell.labelTitle.font = UIFont.ProximaNovaRegular(20)
        cell.labelTitle.textColor = UIColor.FilterCategoryColor
        cell.labelSeparator.isHidden = false
        if self.arrayAllFilterCategory[indexPath.row].filterId == WUSearchFilterID.FoodCategory.rawValue
        {
            cell.labelTitle.textColor = UIColor.white
            cell.labelTitle.font = UIFont.ProximaNovaBold(20)
            cell.labelSeparator.isHidden = true
        }
        cell.setFilterData = self.arrayAllFilterCategory[indexPath.row]
        
        cell.buttonFilterCheck.isSelected = self.arrayAllFilterCategory[indexPath.row].isSelected
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0.propotionalHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filterObject  = self.arrayAllFilterCategory[indexPath.row]
        filterObject.isSelected = !filterObject.isSelected
        if (filterObject.filterId == WUSearchFilterID.LiveMusic.rawValue ||  filterObject.filterId == WUSearchFilterID.nearby.rawValue || filterObject.filterId == WUSearchFilterID.openNow.rawValue) && filterObject.isSelected == true 
        {
            let arrSelectedFilter  = self.arrayAllFilterCategory.filter{$0.filterId == WUSearchFilterID.FoodCategory.rawValue && $0.isSelected == true}
            for filter in arrSelectedFilter
            {
                filter.isSelected = false
            }
        }
        else if filterObject.filterId == WUSearchFilterID.FoodCategory.rawValue && filterObject.isSelected == true
        {
            let arrSelectedFilter  = self.arrayAllFilterCategory.filter{$0.filterId != WUSearchFilterID.FoodCategory.rawValue && $0.isSelected == true}
            for filter in arrSelectedFilter
            {
                filter.isSelected = false
            }
        }
//        let cell = tableView.cellForRow(at: indexPath) as! WUHomeSearchFilterCell
//        cell.buttonFilterCheck.isSelected = filterObject.isSelected
        self.tableViewFilterCategory.reloadData()
    }
}
