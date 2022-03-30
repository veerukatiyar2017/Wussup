//
//  WUEventSectionHeaderView
//  Wussup
//
//  Created by MAC26 on 24/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUEventSectionHeaderView: UITableViewHeaderFooterView {
    //MARK: - IBOutlet
    @IBOutlet private weak var viewMonthAndDate         : UIView!
    @IBOutlet private weak var viewABC                  : UIView!
    @IBOutlet weak var labelTitle                       : UILabel!
    @IBOutlet private weak var labelABC                 : UILabel!
    @IBOutlet private weak var labelDate                : UILabel!
    @IBOutlet private weak var labelMonth               : UILabel!
    @IBOutlet private weak var viewSeperatorTrailing    : NSLayoutConstraint!
    
    //MARK: - Variable
    var dateWiseEvent : WUDateWiseEvents!{
        didSet{
            self.setEventDetail()
        }
    }
    
    var eventCategoryFirstLetter : String!{
        didSet{
            self.setEventCategoryFirstLetterDetail()
        }
    }
    
    var isLoadForABC : Bool = false{
        didSet{
            if isLoadForABC == true {
                self.setUpForABCView()
            }else{
                self.setUpForMonthDateView()
            }
        }
    }
    
    //MARK: - Load Methods
    override func awakeFromNib() {
        self.setUpForMonthDateView()
    }
    
    class func instanceFromNib() -> WUEventSectionHeaderView {
        return UINib(nibName: Utill.getClassNameFor(classType: WUEventSectionHeaderView()), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WUEventSectionHeaderView
    }
    
    // MARK :- Setup methods
    private func setUpForABCView(){
        self.viewMonthAndDate.isHidden = true
        self.viewABC.isHidden = false
        self.labelTitle.isHidden = true
        self.viewSeperatorTrailing.constant = 35.0
    }
    
    private func setUpForMonthDateView(){
        self.viewMonthAndDate.isHidden = false
        self.viewABC.isHidden = true
        self.labelTitle.isHidden = false
        self.viewSeperatorTrailing.constant = 0.0
    }
    
    private func setEventDetail(){
        self.labelMonth.text = Date.dateObject(dateStr: self.dateWiseEvent.EventDate)?.monthAsString().uppercased()
        self.labelDate.text = Date.dateObject(dateStr: self.dateWiseEvent.EventDate)?.dayAsString()
    }
    
    private func setEventCategoryFirstLetterDetail(){
        self.labelABC.text = self.eventCategoryFirstLetter
    }
}
