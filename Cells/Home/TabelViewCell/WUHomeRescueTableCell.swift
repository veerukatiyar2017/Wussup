//
//  WUHomeRescueTableCell.swift
//  Wussup
//
//  Created by MAC219 on 4/23/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUHomeRescueTableCell: UITableViewCell {
    
    @IBOutlet private weak var viewContainer            : UIView!
    @IBOutlet private weak var imageViewCategoryIcon    : UIImageView!
    @IBOutlet private weak var labelCategoryTitle       : UILabel!
    @IBOutlet private weak var labelCountOfCategory     : UILabel!
    @IBOutlet private weak var buttonViewAllOfCategory  : UIButton!
    @IBOutlet private weak var collectionView           : UICollectionView!
    
    @IBOutlet private weak var imageViewOfRescue        : UIImageView!
    @IBOutlet private weak var labelStatus              : UILabel!
    @IBOutlet private weak var labelDiscription         : UILabel!
    @IBOutlet private weak var buttonVideo              : UIButton!
    @IBOutlet private weak var labelSpeciality          : UILabel!
    
    @IBOutlet weak var buttonGoToTop: UIButton!
   private var arrCollectionData : [WUVenue] = []
    
    var categorizedVenue : WUCategorizedVenues! {
        didSet{
            self.setCellDetail(categorisedVenue: self.categorizedVenue)
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
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
   private func setCellDetail(categorisedVenue :WUCategorizedVenues) {
        self.loadCollectionCellNib()
        self.labelCategoryTitle.text = categorisedVenue.title
        self.imageViewCategoryIcon.image = UIImage(named: categorisedVenue.imgIcon)
        self.arrCollectionData = categorisedVenue.venues
        self.collectionView.reloadData()
    }
    
   private func loadCollectionCellNib(){
        switch categorizedVenue.categoryValue {
        case .animalRescue :
            self.collectionView.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeRescueCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeRescueCollectionCell()))
        default :
            break
        }
    }
}

//MARK: - Collection View
extension WUHomeRescueTableCell : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCollectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch categorizedVenue.categoryValue {
        case .animalRescue  :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeRescueCollectionCell()), for: indexPath)as! WUHomeRescueCollectionCell
            cell.collectionVenue = arrCollectionData[indexPath.row]
            return cell
            
        default :
            return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240.0.propotional, height: 170.0.propotionalHeight)
    }
}
