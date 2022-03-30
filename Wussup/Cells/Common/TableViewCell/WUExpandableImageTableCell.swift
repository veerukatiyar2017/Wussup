//
//  WUExpandableImageTableCell.swift
//  Wussup
//
//  Created by MAC219 on 5/31/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - Delegate
protocol WUExpandableImageTableCellDelegate: class {
    func innerShareButton(cell : UITableViewCell , didSelectShareButton button : UIButton , tabel : UITableView )
    func innerCalendarButton(cell : UITableViewCell ,expandableImagetableCell : WUExpandableImageTableCell, didSelectCalendarButton button : UIButton, tabel : UITableView)
    func innerCloseButton(cell :UITableViewCell ,expandableImagetableCell : WUExpandableImageTableCell, didSelectCloseButton button : UIButton, tabel : UITableView)
    func expandableImageTableCell(innerCell : UITableViewCell, didLoadImage image: UIImage)
    func goToTopButtonClicked()
}

extension WUExpandableImageTableCellDelegate{
    func innerShareButton(cell : UITableViewCell , didSelectShareButton button : UIButton , tabel : UITableView ){
        
    }
    func innerCalendarButton(cell : UITableViewCell ,expandableImagetableCell : WUExpandableImageTableCell, didSelectCalendarButton button : UIButton, tabel : UITableView){
        
    }
    func innerCloseButton(cell :UITableViewCell ,expandableImagetableCell : WUExpandableImageTableCell, didSelectCloseButton button : UIButton, tabel : UITableView){
        
    }
    func expandableImageTableCell(innerCell : UITableViewCell, didLoadImage image: UIImage){
        
    }
    func goToTopButtonClicked(){
        
    }
}

class WUExpandableImageTableCell: UITableViewCell {
    
    @IBOutlet weak var tableViewOfImages            : UITableView!
    @IBOutlet private weak var viewContainer        : UIView!
    @IBOutlet weak var viewSeparator                : UIView!
    @IBOutlet private weak var viewContainerBottom  : NSLayoutConstraint!
    @IBOutlet private weak var viewSeparatorHeight  : NSLayoutConstraint!
    
    weak var delegate : WUExpandableImageTableCellDelegate?
    private var arrCollectionData : [Any] = []
    var viewButtonSize : CGFloat = 50.0
    var venueProfileList : Any! {
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
    }
    
    
    //MARK: - Initial Interface SetUp
    
    private func initialInterfaceSetUp() {
        self.viewContainer.dropShadow()
        self.tableViewOfImages.delegate = self
        self.tableViewOfImages.dataSource = self
        self.tableViewOfImages.isScrollEnabled = false
        //        self.tableViewOfImages.estimatedRowHeight = 300.0
        //        self.tableViewOfImages.rowHeight = UITableViewAutomaticDimension
    }
    
    
    private func setCellDetail() {
        self.loadCollectionCellNib()
        self.arrCollectionData.removeAll()
        
        if self.venueProfileList is WUVenueHappyHours {
            self.mangeConstraints(isExpanded: false)
            if (self.venueProfileList as! WUVenueHappyHours).isExpanded == true{
                self.mangeConstraints(isExpanded: true)
            }
            self.arrCollectionData = (self.venueProfileList as! WUVenueHappyHours).HappyHours
        }else if self.venueProfileList is WUMenus {
            self.mangeConstraints(isExpanded: false)
            if (self.venueProfileList as! WUMenus).isExpanded == true{
                self.mangeConstraints(isExpanded: true)
            }
            self.arrCollectionData = (self.venueProfileList as! WUMenus).VenueMenus
        }else if self.venueProfileList is WULiveMusic {
            self.mangeConstraints(isExpanded: false)
            if (self.venueProfileList as! WULiveMusic).isExpanded == true{
                self.mangeConstraints(isExpanded: true)
            }
            self.arrCollectionData = (self.venueProfileList as! WULiveMusic).VenueLiveMusics
        }else if self.venueProfileList is WUSpecialEvents{
            self.mangeConstraints(isExpanded: false)
            if (self.venueProfileList as! WUSpecialEvents).isExpanded == true{
                self.mangeConstraints(isExpanded: true)
            }
            self.arrCollectionData = (self.venueProfileList as! WUSpecialEvents).VenueSpecialEvents
        }else if  self.venueProfileList is WUEventPromoterDetail {
            self.mangeConstraints(isExpanded: false)
            if (self.venueProfileList as! WUEventPromoterDetail).isExpanded == true{
                self.mangeConstraints(isExpanded: true)
            }
            self.arrCollectionData = (self.venueProfileList as! WUEventPromoterDetail).eventPromoter
        }else if  self.venueProfileList is WUMoreEventDetail{
            self.mangeConstraints(isExpanded: false)
            if (self.venueProfileList as! WUMoreEventDetail).isExpanded == true{
                self.mangeConstraints(isExpanded: true)
            }
            self.arrCollectionData = (self.venueProfileList as! WUMoreEventDetail).MoreEvents
        }else  if  self.venueProfileList is WUEventAdmissionDetail{
            self.mangeConstraints(isExpanded: false)
            if (self.venueProfileList as! WUEventAdmissionDetail).isExpanded == true{
                self.mangeConstraints(isExpanded: true)
            }
            self.arrCollectionData = (self.venueProfileList as! WUEventAdmissionDetail).EventAdmission
        }else {
            
        }
        UIView.performWithoutAnimation  {
            self.tableViewOfImages.reloadData();
        }
        //        self.tableViewOfImages.layoutIfNeeded()
    }
    
    private func mangeConstraints(isExpanded : Bool){
        if isExpanded == true{
            self.viewContainerBottom.constant   = 29.0
            self.viewSeparatorHeight.constant   = 1.0
        }else{
            self.viewContainerBottom.constant   = 0.0
            self.viewSeparatorHeight.constant   = 0.0
        }
    }
    
    private func loadCollectionCellNib(){
        if  self.venueProfileList is WUEventPromoterDetail{
            self.tableViewOfImages.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUEventPromoterTableCell()), bundle: nil), forCellReuseIdentifier:  Utill.getClassNameFor(classType: WUEventPromoterTableCell()))
        }else {
            self.tableViewOfImages.register(UINib.init(nibName: Utill.getClassNameFor(classType: WUInnerImageTableCell()), bundle: nil), forCellReuseIdentifier:  Utill.getClassNameFor(classType: WUInnerImageTableCell()))
        }
    }
}

extension WUExpandableImageTableCell : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let sectionObject = self.arrCollectionData[indexPath.row]
        if self.isSectionExpanded(forSectionObj: self.venueProfileList) == true {
            if sectionObject is  WUEventPromotor{
                Utill.printInTOConsole(printData:"WUEventPromotor height : \((sectionObject as! WUEventPromotor).HeightFloat)")
                
                
                let labelNamePromoterheight = Utill.findHeightForText(text: (sectionObject as! WUEventPromotor).Name, havingWidth:UIScreen.main.bounds.size.width - 24.0 , andFont: UIFont.ProximaNovaMedium(24)!)
                
                let labelDescriptionPromotorHeight = Utill.findHeightForText(text: (sectionObject as! WUEventPromotor).Description, havingWidth:UIScreen.main.bounds.size.width - 24.0 , andFont: UIFont.ProximaNovaRegular(17)!)
                
                
                if ((sectionObject as! WUEventPromotor).WidthFloat > 0){
                    if (sectionObject as! WUEventPromotor).HeightFloat  == 0 {
                        return UITableViewAutomaticDimension
                    }else {
                        return ((sectionObject as! WUEventPromotor).HeightFloat * (UIScreen.main.bounds.size.width)/(sectionObject as! WUEventPromotor).WidthFloat) + self.viewButtonSize + labelNamePromoterheight + labelDescriptionPromotorHeight
                    }
                }
                return (sectionObject as! WUEventPromotor).HeightFloat  == 0 ? UITableViewAutomaticDimension : (sectionObject as! WUEventPromotor).HeightFloat + self.viewButtonSize
//                return UITableViewAutomaticDimension
            }else if sectionObject is  WUVenueHours{
                Utill.printInTOConsole(printData:"WUVenueHours height : \((sectionObject as! WUVenueHours).HeightFloat)")
                if ((sectionObject as! WUVenueHours).WidthFloat > 0){
                    if (sectionObject as! WUVenueHours).HeightFloat  == 0 {
                        return UITableViewAutomaticDimension
                    }else {
                        return ((sectionObject as! WUVenueHours).HeightFloat * (UIScreen.main.bounds.size.width)/(sectionObject as! WUVenueHours).WidthFloat) + self.viewButtonSize
                    }
                }
                return (sectionObject as! WUVenueHours).HeightFloat  == 0 ? UITableViewAutomaticDimension : (sectionObject as! WUVenueHours).HeightFloat + self.viewButtonSize
            }else if sectionObject is  WUVenueLocalPromotions{
                Utill.printInTOConsole(printData:"WUVenueLocalPromotions height : \((sectionObject as! WUVenueLocalPromotions).HeightFloat)")
                if ((sectionObject as! WUVenueLocalPromotions).WidthFloat > 0){
                    if (sectionObject as! WUVenueLocalPromotions).HeightFloat  == 0{
                        return UITableViewAutomaticDimension
                    }else {
                        return ((sectionObject as! WUVenueLocalPromotions).HeightFloat * (UIScreen.main.bounds.size.width)/(sectionObject as! WUVenueLocalPromotions).WidthFloat) + self.viewButtonSize
                    }
                }
                return (sectionObject as! WUVenueLocalPromotions).HeightFloat  == 0 ? UITableViewAutomaticDimension : (sectionObject as! WUVenueLocalPromotions).HeightFloat + self.viewButtonSize
            }else if sectionObject is  WUVenueSpecials{
                Utill.printInTOConsole(printData:"WUVenueSpecials height : \((sectionObject as! WUVenueSpecials).HeightFloat)")
                if ((sectionObject as! WUVenueSpecials).WidthFloat > 0){
                    if (sectionObject as! WUVenueSpecials).HeightFloat  == 0{
                        return UITableViewAutomaticDimension
                    }else {
                        return ((sectionObject as! WUVenueSpecials).HeightFloat * (UIScreen.main.bounds.size.width)/(sectionObject as! WUVenueSpecials).WidthFloat) + self.viewButtonSize
                    }
                }
                return (sectionObject as! WUVenueSpecials).HeightFloat  == 0 ? UITableViewAutomaticDimension : (sectionObject as! WUVenueSpecials).HeightFloat + self.viewButtonSize
            }else if sectionObject is  WUVenueLiveCams{
                Utill.printInTOConsole(printData:"WUVenueLiveCams height : \((sectionObject as! WUVenueLiveCams).HeightFloat)")
                if ((sectionObject as! WUVenueLiveCams).WidthFloat > 0){
                    if (sectionObject as! WUVenueLiveCams).HeightFloat  == 0{
                        return UITableViewAutomaticDimension
                    }else {
                        return ((sectionObject as! WUVenueLiveCams).HeightFloat * (UIScreen.main.bounds.size.width)/(sectionObject as! WUVenueLiveCams).WidthFloat) + self.viewButtonSize
                    }
                }
                return (sectionObject as! WUVenueLiveCams).HeightFloat  == 0 ? UITableViewAutomaticDimension : (sectionObject as! WUVenueLiveCams).HeightFloat + self.viewButtonSize
            }else if sectionObject is  WUVenueMenus{
                Utill.printInTOConsole(printData:"WUVenueMenus height : \((sectionObject as! WUVenueMenus).HeightFloat)")
                if ((sectionObject as! WUVenueMenus).WidthFloat > 0){
                    if (sectionObject as! WUVenueMenus).HeightFloat  == 0{
                        return UITableViewAutomaticDimension
                    }else {
                        return ((sectionObject as! WUVenueMenus).HeightFloat * (UIScreen.main.bounds.size.width)/(sectionObject as! WUVenueMenus).WidthFloat) + self.viewButtonSize
                    }
                }
                return (sectionObject as! WUVenueMenus).HeightFloat  == 0 ? UITableViewAutomaticDimension : (sectionObject as! WUVenueMenus).HeightFloat + self.viewButtonSize
            }else if sectionObject is  WUVenueLiveMusic{
                Utill.printInTOConsole(printData:"WUVenueLiveMusic height : \((sectionObject as! WUVenueLiveMusic).HeightFloat)")
                if ((sectionObject as! WUVenueLiveMusic).WidthFloat > 0){
                    if (sectionObject as! WUVenueLiveMusic).HeightFloat  == 0 {
                        return UITableViewAutomaticDimension
                    }else {
                        return ((sectionObject as! WUVenueLiveMusic).HeightFloat * (UIScreen.main.bounds.size.width)/(sectionObject as! WUVenueLiveMusic).WidthFloat) + self.viewButtonSize
                    }
                }
                return (sectionObject as! WUVenueLiveMusic).HeightFloat  == 0 ? UITableViewAutomaticDimension : (sectionObject as! WUVenueLiveMusic).HeightFloat + self.viewButtonSize
            }else if sectionObject is WUEvent{
                Utill.printInTOConsole(printData:"WUEvent height : \((sectionObject as! WUEvent).HeightFloat)")
                if ((sectionObject as! WUEvent).WidthFloat > 0) {
                    if (sectionObject as! WUEvent).HeightFloat  == 0 {
                        return UITableViewAutomaticDimension
                    }else {
                        return ((sectionObject as! WUEvent).HeightFloat * (UIScreen.main.bounds.size.width)/(sectionObject as! WUEvent).WidthFloat) + self.viewButtonSize
                    }
                }
                return (sectionObject as! WUEvent).HeightFloat  == 0 ? UITableViewAutomaticDimension : (sectionObject as! WUEvent).HeightFloat + self.viewButtonSize
            }else if sectionObject is  WUMoreEvent {
                //                if sectionObject is  WUMoreEvent
                Utill.printInTOConsole(printData:"WUMoREEvent height : \((sectionObject as! WUMoreEvent).HeightFloat)")
                if ((sectionObject as! WUMoreEvent).WidthFloat > 0) {
                    if (sectionObject as! WUMoreEvent).HeightFloat  == 0 {
                        return UITableViewAutomaticDimension
                    }else {
                        return ((sectionObject as! WUMoreEvent).HeightFloat * (UIScreen.main.bounds.size.width)/(sectionObject as! WUMoreEvent).WidthFloat) + self.viewButtonSize
                    }
                }
                return (sectionObject as! WUMoreEvent).HeightFloat  == 0 ? UITableViewAutomaticDimension : (sectionObject as! WUMoreEvent).HeightFloat + self.viewButtonSize
            }else if sectionObject is  WUEventAdmissionDetail {
                //                if sectionObject is  WUMoreEvent
                Utill.printInTOConsole(printData:"WUEventAdmissionDetail height : \((sectionObject as! WUEventAdmissionDetail).HeightFloat)")
                if ((sectionObject as! WUEventAdmissionDetail).WidthFloat > 0){
                    if (sectionObject as! WUEventAdmissionDetail).HeightFloat  == 0 {
                        return UITableViewAutomaticDimension
                    }else {
                        return ((sectionObject as! WUEventAdmissionDetail).HeightFloat * (UIScreen.main.bounds.size.width)/(sectionObject as! WUEventAdmissionDetail).WidthFloat) + self.viewButtonSize
                    }
                }
                return (sectionObject as! WUEventAdmissionDetail).HeightFloat  == 0 ? UITableViewAutomaticDimension : (sectionObject as! WUEventAdmissionDetail).HeightFloat + self.viewButtonSize
            }
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCollectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.venueProfileList is WUEventPromoterDetail{
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUEventPromoterTableCell()), for: indexPath)as! WUEventPromoterTableCell
            cell.delegate = self
            cell.isExpanded = (self.venueProfileList as! WUEventPromoterDetail).isExpanded
            cell.eventPromotor = self.arrCollectionData[indexPath.row] as! WUEventPromotor
            cell.buttonClose.isHidden = true
            if indexPath.row == arrCollectionData.count - 1 {
                cell.buttonClose.isHidden = false
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUInnerImageTableCell()), for: indexPath)as! WUInnerImageTableCell
            cell.isFromAdmission = false
            if self.venueProfileList is WUVenueHappyHours {
                cell.isExpanded = (self.venueProfileList as! WUVenueHappyHours).isExpanded
                cell.venueProfileListInnerImage = self.arrCollectionData[indexPath.row] as! WUVenueHours
            }else if self.venueProfileList is WUMenus{
                cell.isExpanded = (self.venueProfileList as! WUMenus).isExpanded
                cell.venueProfileListInnerImage = self.arrCollectionData[indexPath.row] as! WUVenueMenus
            }else if self.venueProfileList is WULiveMusic{
                cell.isExpanded = (self.venueProfileList as! WULiveMusic).isExpanded
                cell.venueProfileListInnerImage = self.arrCollectionData[indexPath.row] as! WUVenueLiveMusic
            }else if self.venueProfileList is WUEventAdmissionDetail{
                cell.isExpanded = (self.venueProfileList as! WUEventAdmissionDetail).isExpanded
                cell.isFromAdmission = true
                cell.venueProfileListInnerImage = self.arrCollectionData[indexPath.row] as! WUMoreEvent
            }
            else{
                if self.venueProfileList is WUMoreEventDetail{
                    cell.isExpanded = (self.venueProfileList as! WUMoreEventDetail).isExpanded
                    cell.venueProfileListInnerImage = self.arrCollectionData[indexPath.row] as! WUMoreEvent
                }else{
                    cell.isExpanded = (self.venueProfileList as! WUSpecialEvents).isExpanded
                    cell.venueProfileListInnerImage = self.arrCollectionData[indexPath.row] as! WUEvent
                }
            }
            
            cell.buttonClose.isHidden = true
            if indexPath.row == arrCollectionData.count - 1 {
                cell.buttonClose.isHidden = false
            }
            cell.delegate = self
            
            return cell
        }
    }
    
    
    private func isSectionExpanded(forSectionObj sectionObject : Any) -> Bool{
        if sectionObject is WUEventPromoterDetail{
            return (sectionObject as! WUEventPromoterDetail).isExpanded
        }else if sectionObject is WULocalPromotions  {
            return (sectionObject as! WULocalPromotions).isExpanded
        }else  if sectionObject is WUSpecials {
            return (sectionObject as! WUSpecials).isExpanded
        }else  if sectionObject is WULiveCams {
            return (sectionObject as! WULiveCams).isExpanded
        }else  if sectionObject is WUVenueHappyHours {
            return (sectionObject as! WUVenueHappyHours).isExpanded
        }else  if sectionObject is WUMenus {
            return (sectionObject as! WUMenus).isExpanded
        }else  if sectionObject is WULiveMusic {
            return (sectionObject as! WULiveMusic).isExpanded
        }else  if sectionObject is WUSpecialEvents {
            return (sectionObject as! WUSpecialEvents).isExpanded
        }else if sectionObject is WUMoreEventDetail{
            return (sectionObject as! WUMoreEventDetail).isExpanded
        }else if sectionObject is WUEventAdmissionDetail{
            return (sectionObject as! WUEventAdmissionDetail).isExpanded
        }
        return false
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.tableViewOfImages.frame = CGRect.init(x: 0, y: 0, width: targetSize.width, height: CGFloat(MAXFLOAT))
        self.tableViewOfImages.layoutSubviews()
        Utill.printInTOConsole(printData:"contentSize : \(self.tableViewOfImages.contentSize)")
        return CGSize(width: self.tableViewOfImages.contentSize.width, height: self.tableViewOfImages.contentSize.height+30)
    }
}


extension WUExpandableImageTableCell : WUVenueProfileTableCellDelegate {
    func venueCloseButton(cell: UITableViewCell, didSelectCloseButton button: UIButton) {
        
        if let delegate = self.delegate{
            delegate.innerCloseButton(cell: cell,expandableImagetableCell: self, didSelectCloseButton: button, tabel: self.tableViewOfImages)
        }
    }
    
    func expandableImageTableCell(innerCell: UITableViewCell, didLoadImage image: UIImage) {
        if let indexPath = self.tableViewOfImages.indexPath(for: innerCell){
            //            if #available(iOS 11.0, *) {
            //                UIView.setAnimationsEnabled(false)
            //                self.tableViewOfImages.beginUpdates()
            //                self.tableViewOfImages.reloadRows(at: [indexPath], with: .none)
            //                self.tableViewOfImages.endUpdates()
            //                UIView.setAnimationsEnabled(true)
            //            }
            //            else {
            //
            //            }
            UIView.performWithoutAnimation  {
                self.tableViewOfImages.reloadData();
                self.tableViewOfImages.layoutIfNeeded();
            }
            if let aDelegate = self.delegate {
                aDelegate.expandableImageTableCell(innerCell: self , didLoadImage: image)
            }
        }
    }
    
    func venueShareButton(cell: UITableViewCell, didSelectShareButton button: UIButton) {
        if let aDelegate = self.delegate {
            aDelegate.innerShareButton(cell: cell , didSelectShareButton: button, tabel: self.tableViewOfImages)
        }
    }
    
    func venueCalendarButton(cell: UITableViewCell, didSelectCalendarButton button: UIButton) {
        if let aDelegate = self.delegate{
            aDelegate.innerCalendarButton(cell: cell ,expandableImagetableCell : self, didSelectCalendarButton: button, tabel: self.tableViewOfImages)
        }
    }
}

