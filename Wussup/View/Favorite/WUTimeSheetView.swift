//
//  WUTimeSheetView.swift
//  Wussup
//
//  Created by MAC219 on 6/28/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUTimeSheetView: UIView {
    //MARK: - IBOutlet
    @IBOutlet weak var tableViewTimeSheet       : UITableView!
    //    @IBOutlet weak var viewTimeSheetHeight      : NSLayoutConstraint!
    
    private var arrTimeSheetData : [Any] = []
    var isLastRow : Bool = false
    var  favoriteVenueTimeSheet: WUVenueDetail!{
        didSet{
            self.setDetail()
        }
    }
    //MARK: - Load Methods
    override func awakeFromNib() {
    }
    
    class func instanceFromNib() -> WUTimeSheetView {
        return UINib(nibName: Utill.getClassNameFor(classType: WUTimeSheetView()), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WUTimeSheetView
    }
    
    private func setDetail(){
        self.tableViewTimeSheet.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUTimeSheetTableCell()), bundle: nil), forCellReuseIdentifier:  Utill.getClassNameFor(classType: WUTimeSheetTableCell()))
        self.tableViewTimeSheet.dataSource = self
        self.tableViewTimeSheet.delegate = self
        self.tableViewTimeSheet.contentInset = UIEdgeInsets(top: 5.0, left: 0, bottom: 10.0, right: 0)
        self.arrTimeSheetData = self.favoriteVenueTimeSheet.VenueOpenHours
        self.tableViewTimeSheet.reloadData()
    }
    
    func showInView(superView : UIView , atPointY : CGFloat) {
        self.removeFromView(superView: superView)
        self.tag = timeSheetViewTag
        self.frame = CGRect(x: 0.0, y: atPointY, width: 275, height: 50)
        if self.favoriteVenueTimeSheet.VenueOpenHours.count > 0 {
            let heightTemp = Double(self.arrTimeSheetData.count * 20)
           if self.isLastRow == false{
            self.frame = CGRect(x: 1.0, y: Double(atPointY), width: Double(275.0.propotional), height: heightTemp + 20.0)
           }else{
            self.frame = CGRect(x: 1.0, y: Double(atPointY), width: Double(275.0.propotional), height: -(heightTemp + 20.0))
            }
            superView.addSubview(self)

//            self.tableViewTimeSheet.layoutIfNeeded()
//            self.layoutIfNeeded()
        }
    }
    
    func removeFromView(superView : UIView)  {
        if let view = superView.viewWithTag(timeSheetViewTag){
            view.removeFromSuperview()
        }
    }
}
extension WUTimeSheetView : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTimeSheetData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUTimeSheetTableCell()), for: indexPath)as! WUTimeSheetTableCell
        cell.buttonCloseTimeSheet.isHidden = true
        if indexPath.row == self.favoriteVenueTimeSheet.VenueOpenHours.count - 1{
            cell.buttonCloseTimeSheet.isHidden = false
        }
        cell.delegate = self
        cell.labelWeekDayName.font = UIFont.ProximaNovaMedium(15.0)
        cell.labelWeekDayName.text = "\(self.favoriteVenueTimeSheet.VenueOpenHours[indexPath.row].Days)"
        cell.labelTime.text = "\(self.favoriteVenueTimeSheet.VenueOpenHours[indexPath.row].Time[0])"
        
        if self.favoriteVenueTimeSheet.VenueOpenHours[indexPath.row].includeToday.toBool() == true{
            cell.labelWeekDayName.font = UIFont.ProximaNovaBold(15.0)
            cell.labelWeekDayName.text = (self.favoriteVenueTimeSheet.VenueOpenHours[indexPath.row].Days).uppercased()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 22.0
    }
}

//MARK: - WUTimeSheetTableCellDelegate to close TimeSheet
extension WUTimeSheetView : WUTimeSheetTableCellDelegate{
    func timeSheetTableCell(cell: WUTimeSheetTableCell, buttonCloseTimeSheet button: UIButton) {
        self.removeFromSuperview()
    }
}
