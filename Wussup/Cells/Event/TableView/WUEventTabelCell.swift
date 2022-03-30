//
//  WUEventTabelCell.swift
//  Wussup
//
//  Created by MAC219 on 5/23/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WUEventTabelCellDelegate : class{
    func didSelectListTableCell(cell : WUEventTabelCell , eventSelectedCategoryId : String)
    func eventTableCellLiveCamButtonClicked(cell : WUEventTabelCell, withEvent event : WUEvent)
}
extension WUEventTabelCellDelegate {
    func didSelectListTableCell(cell : WUEventTabelCell , eventSelectedCategoryId : String){
        
    }
    func eventTableCellLiveCamButtonClicked(cell : WUEventTabelCell, withEvent event : WUEvent){
        
    }
}

class WUEventTabelCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var collectionViewEvent: UICollectionView!
   
    //MARK: - Variables
    weak var delegate : WUEventTabelCellDelegate?
    private var currentVisibleIndex = 0
    private var timerAnimation :Timer?
    var     dateWiseEvents : WUDateWiseEvents!{
        didSet{
            self.setCellDetail()
        }
    }
    
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInterfaceSetUp()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Initial Interface SetUp
    private func initialInterfaceSetUp() {
        self.collectionViewEvent.delegate = self
        self.collectionViewEvent.dataSource = self
    }
    
    private func setCellDetail(){
        let sectionObj = Date.dateObject(dateStr: self.dateWiseEvents.EventDate)
        if (sectionObj?.isToday())! || (sectionObj?.isTommorow())!{
            if self.dateWiseEvents.Events.count > 1{
                self.startTimerForchangeLocalPromotionImageAnimation()
            }
        }
        self.collectionViewEvent.reloadData()
    }
    
    // MARK: - Today Tommorow Animation methods
    //To change images contiouesly in header slider
    func startTimerForchangeLocalPromotionImageAnimation(){
        if self.timerAnimation == nil  {
            self.timerAnimation = Timer.scheduledTimer(timeInterval: 03.0,target: self, selector: #selector(self.updateImage), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimerForLocalPromotion() {
        if self.timerAnimation != nil {
            self.timerAnimation?.invalidate()
            self.timerAnimation = nil
        }
    }
    
    @objc func updateImage() {
    let sectionObj = Date.dateObject(dateStr: self.dateWiseEvents.EventDate)
        if (sectionObj?.isToday())! || (sectionObj?.isTommorow())!{
            if self.dateWiseEvents.Events.count > 0{
                self.currentVisibleIndex = self.currentVisibleIndex + 1
                if self.currentVisibleIndex >= self.dateWiseEvents.Events.count {
                    self.currentVisibleIndex = 0
                }
                if self.currentVisibleIndex < self.dateWiseEvents.Events.count{
                    DispatchQueue.main.async {
                        if self.currentVisibleIndex == 0 {
                            self.collectionViewEvent.scrollToItem(at:IndexPath(row: self.currentVisibleIndex, section: 0), at: UICollectionViewScrollPosition.right, animated: false)
                        }
                        else{
                            self.collectionViewEvent.scrollToItem(at:IndexPath(row: self.currentVisibleIndex, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
                        }
                    }
                }
            }
//            else{
//                self.stopTimerForLocalPromotion()
//            }
        }
    }
}

//MARK: - Collection View
extension WUEventTabelCell : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dateWiseEvents.Events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUEventCollectionCell()), for: indexPath)as! WUEventCollectionCell
        cell.delegate = self
        
        if let eventDate = Date.dateObject(dateStr: self.dateWiseEvents.EventDate) ,eventDate.isToday() {
            cell.viewDescriptionContainer.backgroundColor = UIColor.LiveCamYellowColor
        }else{
             cell.viewDescriptionContainer.backgroundColor = UIColor.white
        }
      
        cell.labelDate.text =   Date.dateObject(dateStr: self.dateWiseEvents.EventDate)?.dayAsString()
        cell.labelMonth.text = Date.dateObject(dateStr: self.dateWiseEvents.EventDate)?.monthAsString().uppercased()
        cell.event = self.dateWiseEvents.Events[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 275.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = self.collectionViewEvent.cellForItem(at: indexPath) as! WUEventCollectionCell
        if let delegate = self.delegate {
            FirebaseManager.sharedInstance.view_event_GUID_ios(parameter: nil, EventM: self.dateWiseEvents.Events[indexPath.row])
            delegate.didSelectListTableCell(cell: self, eventSelectedCategoryId: self.dateWiseEvents.Events[indexPath.row].ID)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if cell is WUEventCollectionCell{
//            if indexPath.row > 0 {
//                self.stopTimerForLocalPromotion()
//            }
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell is WUEventCollectionCell {
            
            let sectionObj = Date.dateObject(dateStr: self.dateWiseEvents.EventDate)
            if (sectionObj?.isToday())! || (sectionObj?.isTommorow())!{
                if self.dateWiseEvents.Events.count > 1{
                    self.stopTimerForLocalPromotion()
                    let currentPage = self.collectionViewEvent.contentOffset.x / self.collectionViewEvent.frame.size.width
                    self.currentVisibleIndex = Int(currentPage)
                    Utill.printInTOConsole(printData:"Local Promotion current Event index :::: \(currentPage)")
                    self.startTimerForchangeLocalPromotionImageAnimation()
                }
            }
        }
    }
}
extension WUEventTabelCell : WUEventCollectionCellDelegate {
    func eventCollectionLiveCamButtonClicked(cell: WUEventCollectionCell, withEvent event: WUEvent) {
        if let delegate = self.delegate {
            delegate.eventTableCellLiveCamButtonClicked(cell: self, withEvent: event)
        }
    }
}
