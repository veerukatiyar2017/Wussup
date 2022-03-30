//
//  WUEventSearchFilterViewController.swift
//  Wussup
//
//  Created by MAC219 on 6/13/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit


class WUEventSearchFilterViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet private var tableViewFilterCategory    : UITableView!
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetup() {
        self.tableViewFilterCategory.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.tableViewFilterCategory.frame.width, height: 72.0.propotionalHeight)
        self.tableViewFilterCategory.tableFooterView = UIView()
    }
    
    // MARK: - Action Methods
    @IBAction func buttonDoneAction(_ sender: UIButton) {
        if let delegate = self.delegate{
            let arraySelectedFilter  = self.arrayAllFilterCategory.filter { $0.isSelected == true}
            delegate.filterDoneButtonSelected(arraySelectedFilter: arraySelectedFilter)
        }
    }
}

//MARK: - TableView
extension WUEventSearchFilterViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayAllFilterCategory.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUHomeSearchFilterCell()), for: indexPath) as! WUHomeSearchFilterCell
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
        let cell = tableView.cellForRow(at: indexPath) as! WUHomeSearchFilterCell
        cell.buttonFilterCheck.isSelected = filterObject.isSelected
        
    }
}
