//
//  WUExpandableViewAndCollectionTableCell.swift
//  Wussup
//
//  Created by MAC219 on 4/27/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - Delegate
 protocol WUVenueProfileTableCellDelegate: class {
     func venueShareButton(cell : UITableViewCell , didSelectShareButton button : UIButton)
     func venueCalendarButton(cell : UITableViewCell , didSelectCalendarButton button : UIButton)
     func venueCloseButton(cell : UITableViewCell, didSelectCloseButton button : UIButton)
     func expandableImageTableCell(innerCell : UITableViewCell, didLoadImage image: UIImage)
     func didSelectPhoto(cell : UITableViewCell, currentVisibleIndex : IndexPath)
     func venueGoToTopButtonClicked()
     func venueProfileTableCellLiveCamButtonClicked(cell : UITableViewCell, withVenueCategory venueCategory : Any)
    func  eventCrossDelete(cell : WUMyEventListTableCell , withCalenderEvent  calenderEventM: WUMyEventList)
}

extension WUVenueProfileTableCellDelegate{
    func venueShareButton(cell : UITableViewCell , didSelectShareButton button : UIButton){
        
    }
    func venueCalendarButton(cell : UITableViewCell , didSelectCalendarButton button : UIButton){
        
    }
    func venueCloseButton(cell : UITableViewCell, didSelectCloseButton button : UIButton){
        
    }
    func expandableImageTableCell(innerCell : UITableViewCell, didLoadImage image: UIImage){
        
    }
    func didSelectPhoto(cell : UITableViewCell, currentVisibleIndex : IndexPath){
        
    }
    func venueGoToTopButtonClicked(){
        
    }
    func venueProfileTableCellLiveCamButtonClicked(cell : UITableViewCell, withVenueCategory venueCategory : Any){
        
    }
    func  eventCrossDelete(cell : WUMyEventListTableCell , withCalenderEvent  calenderEventM: WUMyEventList){
        
    }
}

class WUExpandableViewAndCollectionTableCell: UITableViewCell {
    
    @IBOutlet private weak var viewContainer            : UIView!
    @IBOutlet private weak var imageViewStatic          : UIImageView!
    @IBOutlet private weak var buttonVideo              : UIButton!
    @IBOutlet private weak var labelTitle               : UILabel!
    @IBOutlet private weak var collectionView           : UICollectionView!
    @IBOutlet private weak var buttonClose              : UIButton!
    @IBOutlet private weak var buttonAddToCalendar      : UIButton!
    @IBOutlet private weak var buttonShare              : UIButton!
    @IBOutlet weak var viewSeparator: UIView!
    
    @IBOutlet private weak var viewContainerBottom  : NSLayoutConstraint!
    @IBOutlet private weak var collectionViewHeight : NSLayoutConstraint!
    @IBOutlet private weak var viewButtonHeight     : NSLayoutConstraint!
    @IBOutlet private weak var viewSeparatorHeight  : NSLayoutConstraint!
    @IBOutlet private weak var viewStaticImageBottom: NSLayoutConstraint!
//    @IBOutlet private weak var viewStaticImageHeight: NSLayoutConstraint!
    weak var delegate : WUVenueProfileTableCellDelegate?
    
    // MARK: - Variables
    private var arrCollectionData : [WUVenueLiveCams] = []
     private var arrCollectionDataCopy : [WUVenueLiveCams] = []
    
    var venueProfileLiveCam : WULiveCams! {
        didSet{
            self.setCellDetail()
        }
    }
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        initialInterfaceSetUp()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Initial Interface SetUp
    
    private func initialInterfaceSetUp() {
        self.viewContainer.dropShadow()
        self.buttonVideo.isHidden = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.viewContainer.backgroundColor = .LiveCamYellowColor
        self.buttonClose.semanticContentAttribute = .forceRightToLeft
    }
    
    private func setCellDetail() {
        self.loadCollectionCellNib()
        self.mangeConstraints(isExpanded: false)
        if self.venueProfileLiveCam.isExpanded == true{
            self.mangeConstraints(isExpanded: true)
            //manage height of cell based on array count
            self.arrCollectionDataCopy = self.venueProfileLiveCam.LocalLiveCams.map { $0 }
            if self.arrCollectionDataCopy.count == 1 {
                self.collectionViewHeight.constant = 0.0
                //            self.collectionView.isHidden = true
            }else{
                self.collectionViewHeight.constant = 170.0
                //            self.collectionView.isHidden = false
            }
            //set table cell data and manage data to the collection cell
            self.labelTitle.text = self.arrCollectionDataCopy[0].Name
            self.imageViewStatic.sd_imageIndicator = SDWebImageActivityIndicator.white
//            self.imageViewStatic.sd_setShowActivityIndicatorView(true)
//            self.imageViewStatic.sd_setIndicatorStyle(.white)
            self.imageViewStatic.sd_setImage(with:URL(string:self.arrCollectionDataCopy[0].ImageURL) , placeholderImage: #imageLiteral(resourceName: "placeholder"))
            
//            Utill.getThumbnailFrom(path: URL(string: self.arrCollectionDataCopy[0].LiveCamURL)) { (image) in
//                DispatchQueue.main.async {
//                    self.imageViewStatic.image = image
//                }
//            }
            
            self.arrCollectionData = Array(self.arrCollectionDataCopy.dropFirst())
            self.collectionView.reloadData()
        }
    }
    
    
    func mangeConstraints(isExpanded : Bool){
        if isExpanded == true{
            self.viewContainerBottom.constant   = 30.0
            self.viewButtonHeight.constant      = 50.0
            self.viewSeparatorHeight.constant   = 1.0
            self.viewStaticImageBottom.constant = 10.0
//            self.viewStaticImageHeight.constant = 170.0
            
        }else{
            self.viewContainerBottom.constant   = 0.0
            self.viewButtonHeight.constant      = 0.0
            self.viewSeparatorHeight.constant   = 0.0
            self.viewStaticImageBottom.constant = 0.0
//            self.viewStaticImageHeight.constant = 0.0
            self.collectionViewHeight.constant = 0.0
        }
    }
    private func loadCollectionCellNib(){
        self.collectionView.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeTitleCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeTitleCollectionCell()))
    }
    
    func setCellForCollapsed(isCollapsed : Bool) {
        if isCollapsed == true {
            self.buttonClose.isHidden = false
        }else{
            self.buttonClose.isHidden = true
        }
    }
    
    //MARK: - Button Actions
    
    @IBAction func buttonVideoAction(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.venueProfileTableCellLiveCamButtonClicked(cell: self, withVenueCategory: self.arrCollectionDataCopy[0])
        }
    }
    
    @IBAction func buttonShareAction(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.venueShareButton(cell: self, didSelectShareButton: sender)
        }
    }
    
    @IBAction func buttonAddToCalendarAction(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.venueCalendarButton(cell: self, didSelectCalendarButton: sender)
        }
    }
    
    @IBAction func buttonCloseAction(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.venueCloseButton(cell: self, didSelectCloseButton: sender)
        }
    }
}
//MARK: - Collection View
extension WUExpandableViewAndCollectionTableCell : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCollectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeTitleCollectionCell()), for: indexPath)as! WUHomeTitleCollectionCell
        cell.delegate = self
        cell.venueLiveCamsOrArtEntmt = arrCollectionData[indexPath.row] 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240.0, height: 170.0)
    }
}

extension WUExpandableViewAndCollectionTableCell : WUHomeTitleCollectionCellDelegate {
    func homeTilteCollectionCellLiveCamButtonClicked(cell: WUHomeTitleCollectionCell, withVenueCategory venueCategory: Any) {
        if let delegate = self.delegate {
            delegate.venueProfileTableCellLiveCamButtonClicked(cell:self , withVenueCategory: venueCategory)
        }
    }
}

