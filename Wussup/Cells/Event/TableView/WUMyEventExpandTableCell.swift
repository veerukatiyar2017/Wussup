//
//  WUMyEventExpandTableCell.swift
//  Wussup
//
//  Created by MAC219 on 9/6/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUMyEventExpandTableCell: UITableViewCell {

    @IBOutlet private  weak var buttonClose         : UIButton!
    @IBOutlet private weak var tableViewMyEventList : UITableView!
    @IBOutlet private weak var viewButtonHeightCnst : NSLayoutConstraint!

    weak var delegate : WUVenueProfileTableCellDelegate?
    private var arrCollectionData : [WUMyEventList] = []
    var venueProfileList : WUMyEventListDetail! {
        didSet{
            self.setCellDetail()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInterfaceSetUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Initial Interface SetUp
    
    private func initialInterfaceSetUp() {
        
//        self.viewContainer.dropShadow()
        self.tableViewMyEventList.delegate = self
        self.tableViewMyEventList.dataSource = self
        self.buttonClose.semanticContentAttribute = .forceRightToLeft
        self.loadCollectionCellNib()

    }
    
    
    private func setCellDetail() {
//        self.loadCollectionCellNib()
//        self.arrCollectionData.removeAll()
        
        self.mangeConstraints(isExpanded: false)
        if self.venueProfileList.isExpanded == true{
            self.mangeConstraints(isExpanded: true)
        }
        self.arrCollectionData = self.venueProfileList.eventList
        UIView.performWithoutAnimation  {
            self.tableViewMyEventList.reloadData();
        }
    }
    
    private func mangeConstraints(isExpanded : Bool){
        if isExpanded == true{
            self.viewButtonHeightCnst.constant   = 50.0
        }else{
            self.viewButtonHeightCnst.constant   = 0.0
        }
    }
    
    private func loadCollectionCellNib(){
            self.tableViewMyEventList.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUMyEventListTableCell()), bundle: nil), forCellReuseIdentifier:  Utill.getClassNameFor(classType: WUMyEventListTableCell()))
    }
    
    @IBAction func buttonCloseAction(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.venueCloseButton(cell: self, didSelectCloseButton: sender)
        }
    }
}
extension WUMyEventExpandTableCell : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 40.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCollectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUMyEventListTableCell()), for: indexPath)as! WUMyEventListTableCell
//            cell.isExpanded = (self.venueProfileList as! WUMyEventListDetail).isExpanded
            cell.myEventList = self.arrCollectionData[indexPath.row]
        cell.delegate = self
            return cell
    }
//
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.tableViewMyEventList.frame = CGRect.init(x: 0, y: 0, width: targetSize.width, height: CGFloat(MAXFLOAT))
        self.tableViewMyEventList.layoutSubviews()
        self.tableViewMyEventList.reloadData()
        Utill.printInTOConsole(printData:"contentSize : \(self.tableViewMyEventList.contentSize)")
        return CGSize(width: self.tableViewMyEventList.contentSize.width, height: self.tableViewMyEventList.contentSize.height)
    }
}

extension WUMyEventExpandTableCell : WUMyEventListTableCellDelegate {

    func eventCrossDelete(cell : WUMyEventListTableCell , withCalenderEvent  calenderEventM: WUMyEventList) {
        if let delegate = self.delegate {
            delegate.eventCrossDelete(cell: cell, withCalenderEvent: calenderEventM)
        }
    }
}

