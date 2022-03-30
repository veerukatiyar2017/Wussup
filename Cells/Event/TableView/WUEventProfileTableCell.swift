//
//  WUEventProfileTableCell.swift
//  Wussup
//
//  Created by MAC219 on 5/28/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUEventProfileTableCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var viewContainer        : UIView!
    @IBOutlet private weak var collectionView       : UICollectionView!
    @IBOutlet private weak var labelTitle           : UILabel!
    @IBOutlet private weak var labelSubTitle        : UILabel!
    @IBOutlet private weak var buttonClose          : UIButton!
    @IBOutlet private weak var viewContainerBottom  : NSLayoutConstraint!
    @IBOutlet private weak var viewButtonHeight     : NSLayoutConstraint!
    @IBOutlet private weak var viewSeparatorHeight  : NSLayoutConstraint!
    
    //MARK: - Variables
    weak var delegate : WUVenueProfileTableCellDelegate?
     private var arrCollectionData : [Any] = []
    
    var eventPhotoDetail : WUEventPhotoDetail!{
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
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.buttonClose.semanticContentAttribute = .forceRightToLeft
    }
    
    private func setCellDetail() {
        self.loadCollectionCellNib()
        
        self.mangeConstraints(isExpanded: false)
        if self.eventPhotoDetail.isExpanded == true{
            self.mangeConstraints(isExpanded: true)
        }
        self.arrCollectionData = self.eventPhotoDetail.eventPhotos
        self.collectionView.reloadData()
    }
    
    func mangeConstraints(isExpanded : Bool){
        if isExpanded == true{
            self.viewContainerBottom.constant   = 29.0
            self.viewButtonHeight.constant      = 50.0
            self.viewSeparatorHeight.constant   = 1.0
        }else{
            self.viewContainerBottom.constant   = 0.0
            self.viewButtonHeight.constant      = 0.0
            self.viewSeparatorHeight.constant   = 0.0
        }
    }
    
    private func loadCollectionCellNib(){
        self.collectionView.register(UINib(nibName: Utill.getClassNameFor(classType:WUVenuePhotoCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUVenuePhotoCollectionCell()))
    }
    
    func setCellForCollapsed(isCollapsed : Bool) {
        if isCollapsed == true {
            self.buttonClose.isHidden = false
        }else{
            self.buttonClose.isHidden = true
        }
    }
    
    // MARK: - Action Methods
    @IBAction func buttonCloseAction(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.venueCloseButton(cell: self, didSelectCloseButton: sender)
        }
    }
}

//MARK: - Collection View
extension WUEventProfileTableCell : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCollectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType: WUVenuePhotoCollectionCell()), for: indexPath)as! WUVenuePhotoCollectionCell
        cell.eventPhotos = self.arrCollectionData[indexPath.row] as! WUEventPhotos
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let delegate = self.delegate {
                delegate.didSelectPhoto(cell: self, currentVisibleIndex: indexPath)
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240.0, height: 170.0)
    }
}

