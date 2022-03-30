//
//  WUVenueProfileTableCell.swift
//  Wussup
//
//  Created by MAC219 on 4/25/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUVenueProfileTableCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var viewContainer        : UIView!
    @IBOutlet private weak var buttonClose          : UIButton!
    @IBOutlet private weak var buttonShare          : UIButton!
    @IBOutlet private weak var collectionView       : UICollectionView!
    @IBOutlet weak var viewSeparator                : UIView!
    @IBOutlet private weak var viewContainerBottom  : NSLayoutConstraint!
    @IBOutlet private weak var viewButtonHeight     : NSLayoutConstraint!
    @IBOutlet private weak var viewSeparatorHeight  : NSLayoutConstraint!
    
    private var arrCollectionData : [Any] = []
    weak var delegate : WUVenueProfileTableCellDelegate?
    var venueProfileList : Any! {
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
        self.viewContainer.dropShadow()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.buttonClose.semanticContentAttribute = .forceRightToLeft
    }
    
    private func setCellDetail() {
        self.loadCollectionCellNib()
        if self.venueProfileList is WUVenueProfilePhotos {
            self.mangeConstraints(isExpanded: false)
            if (self.venueProfileList as! WUVenueProfilePhotos).isExpanded == true{
                self.mangeConstraints(isExpanded: true)
            }
            self.arrCollectionData = (self.venueProfileList as! WUVenueProfilePhotos).VenueImages
        }else if self.venueProfileList is WULocalPromotions {
            self.mangeConstraints(isExpanded: false)
            if (self.venueProfileList as! WULocalPromotions).isExpanded == true{
                self.mangeConstraints(isExpanded: true)
            }
            self.arrCollectionData = (self.venueProfileList as! WULocalPromotions).VenuePromotions
        }else{ //( if self.venueProfileList is WUSpecials)
            self.mangeConstraints(isExpanded: false)
            if (self.venueProfileList as! WUSpecials).isExpanded == true{
                self.mangeConstraints(isExpanded: true)
            }
            self.arrCollectionData = (self.venueProfileList as! WUSpecials).VenueSpecials
        }
        self.collectionView.reloadData()
    }
    
    func mangeConstraints(isExpanded : Bool){
        if isExpanded == true{
            self.viewContainerBottom.constant   = 30.0
            self.viewButtonHeight.constant      = 50.0
            self.viewSeparatorHeight.constant   = 1.0
        }else{
            self.viewContainerBottom.constant   = 0.0
            self.viewButtonHeight.constant      = 0.0
            self.viewSeparatorHeight.constant   = 0.0
        }
    }
    
    private func loadCollectionCellNib(){
        if self.venueProfileList is WUVenueProfilePhotos {
            self.collectionView.register(UINib(nibName: Utill.getClassNameFor(classType: WUVenuePhotoCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType: WUVenuePhotoCollectionCell()))
        }else{ //Promotion & Specials
            self.collectionView.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()))
        }
    }
    
    func setCellForCollapsed(isCollapsed : Bool) {
        if isCollapsed == true {
            self.buttonClose.isHidden = false
        }else{
            self.buttonClose.isHidden = true
        }
    }
    
    //MARK: - Button Actions
    
    @IBAction func buttonShareAction(_ sender: UIButton) {
         Utill.printInTOConsole(printData:"buttonShareAction")
        if let delegate = self.delegate {
            delegate.venueShareButton(cell: self, didSelectShareButton: sender)
        }
    }
    @IBAction func buttonCloseAction(_ sender: UIButton) {
         Utill.printInTOConsole(printData:"buttonCloseAction")
        if let delegate = self.delegate {
            delegate.venueCloseButton(cell: self, didSelectCloseButton: sender)
        }
    }
}

//MARK: - Collection View
extension WUVenueProfileTableCell : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCollectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.venueProfileList is WUVenueProfilePhotos {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType: WUVenuePhotoCollectionCell()), for: indexPath)as! WUVenuePhotoCollectionCell
            collectionView.isPagingEnabled = false
            cell.venueImage = self.arrCollectionData[indexPath.row] as! WUVenueImages
            return cell
        }else{ //Promotion & Specials
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), for: indexPath)as! WUHomeSliderCollectionCell
            collectionView.isPagingEnabled = true
            if self.venueProfileList is WULocalPromotions {
                cell.venueLocalPromotion = self.arrCollectionData[indexPath.row] as! WUVenueLocalPromotions
            }else{
                cell.venueLocalPromotion = self.arrCollectionData[indexPath.row] as! WUVenueSpecials
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.venueProfileList is  WULocalPromotions  ||  self.venueProfileList is  WUSpecials{ //Promotion & Specials
            return CGSize(width: self.collectionView.frame.size.width, height: 100.0)
        }else{
            return CGSize(width: 240.0, height: 170.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if self.venueProfileList is  WULocalPromotions  ||  self.venueProfileList is  WUSpecials{ //Promotion & Specials
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if self.venueProfileList is  WULocalPromotions  ||  self.venueProfileList is  WUSpecials{ //Promotion & Specials
            return 0.0
        }else{
            return 10.0
        }

    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.venueProfileList is WUVenueProfilePhotos {
            if let delegate = self.delegate {
                delegate.didSelectPhoto(cell: self, currentVisibleIndex: indexPath)
            }
        }
    }
}



