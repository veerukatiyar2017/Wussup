//
//  WUFavoriteDateRangeTableCell.swift
//  Wussup
//
//  Created by MAC219 on 6/25/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - Delegate
protocol WUFavoriteDateRangeTableCellDelegate : class {
    func buttonTimeSheetClicked(cell : UITableViewCell)
    func favoriteDateRangeTableCellLiveCamButtonClicked(cell : WUFavoriteDateRangeTableCell, withFavorite obj : Any)
}

extension WUFavoriteDateRangeTableCellDelegate {
    func buttonTimeSheetClicked(cell : UITableViewCell){
        
    }
    func favoriteDateRangeTableCellLiveCamButtonClicked(cell : WUFavoriteDateRangeTableCell, withFavorite obj : Any){
        
    }
}

class WUFavoriteDateRangeTableCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var viewContainer                    : UIView!
    @IBOutlet private weak var imageViewIcon                    : UIImageView!
    @IBOutlet private weak var buttonDistance                   : UIButton!
    @IBOutlet private weak var buttonVideo                      : UIButton!
    @IBOutlet private weak var labelTitle                       : UILabel!
    @IBOutlet private weak var labelSubTitleAddress             : UILabel!
    @IBOutlet weak var collectionViewSilder                     : UICollectionView!
    @IBOutlet private weak var labelTime                        : UILabel!
    @IBOutlet private weak var labelOpenNowStatus               : UILabel!
    @IBOutlet private weak var buttonOpenTimeSheet              : UIButton!
    @IBOutlet  weak var pageControl                             : UIPageControl!
    @IBOutlet  weak var collectionViewSilderHeightCont          : NSLayoutConstraint!
    @IBOutlet private weak var buttonTimeSheetWithStatus        : UIButton!
    @IBOutlet  weak var viewOpenTimeHeightConst                 : NSLayoutConstraint!
   
    // MARK: - Variables
    weak var delegate : WUFavoriteDateRangeTableCellDelegate?
    var arrCollectionData : [Any] = []
    
    var  favoriteVenue: WUVenueDetail!{
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
        self.loadCollectionCellNib()
        self.buttonDistance.backgroundColor = .buttonDistanceColor
        self.viewContainer.dropShadow(color: .lightGray, opacity: 1.0, offSet: CGSize(width: 0.0, height: 2.0), radius: 1.0, scale: true)
        self.collectionViewSilder.dataSource = self
        self.collectionViewSilder.delegate = self
    }
    
    private func setCellDetail(){
        self.buttonVideo.isHidden = true
        if self.favoriteVenue.LiveCams.LocalLiveCams.count > 0 {
            self.buttonVideo.isHidden = false
        }
         self.buttonDistance.backgroundColor = UIColor.buttonDistanceColor
        self.buttonDistance.setTitle(NSString(format: "%0.2f Mi", Float(self.favoriteVenue.VenueDistance) ?? 0) as String, for:.normal)
        self.imageViewIcon.sd_setShowActivityIndicatorView(true)
        self.imageViewIcon.sd_setIndicatorStyle(.white)
        self.imageViewIcon.sd_setImage(with:URL(string:self.favoriteVenue.VenueCoverPhoto.RactangleImage.count > 0 ? self.favoriteVenue.VenueCoverPhoto.RactangleImage : self.favoriteVenue.VenueCoverPhoto.SquareImage ) , placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto"), options: [SDWebImageOptions.cacheMemoryOnly])
        self.labelTitle.text = self.favoriteVenue.VenueName.uppercased()
        
        if self.favoriteVenue.VenueOpenHours.count == 0 {
            self.buttonOpenTimeSheet.isHidden = true
        }else{
            self.buttonOpenTimeSheet.isHidden = false
        }
        
        self.labelOpenNowStatus.isHidden = false
        self.labelTime.text = ""
        self.labelOpenNowStatus.text = ""
        
        self.buttonTimeSheetWithStatus.isUserInteractionEnabled = false
     
            if (self.favoriteVenue.VenueAtOpen == "" || self.favoriteVenue.VenueAtClose == "") &&  self.favoriteVenue.VenueOpenHours.count > 0{
                self.labelOpenNowStatus.textColor = .RedColor
                self.labelOpenNowStatus.text = Text.Label.text_Closed
                self.buttonTimeSheetWithStatus.isUserInteractionEnabled = true
            }else if (self.favoriteVenue.VenueAtOpen != "" && self.favoriteVenue.VenueAtClose != "") {
                self.labelOpenNowStatus.textColor = .OpenNowGreenColor
                self.labelOpenNowStatus.text = Text.Label.text_Open
                self.labelTime.text = "\(self.favoriteVenue.VenueAtOpen) - \(self.favoriteVenue.VenueAtClose)"
                self.buttonTimeSheetWithStatus.isUserInteractionEnabled = true
            }
        
        
        if self.favoriteVenue.Promotions.VenuePromotions.count > 0 && self.favoriteVenue.VenueOpenHours.count > 0{
            self.collectionViewSilderHeightCont.constant =  102.0
            self.pageControl.isHidden = false
            if self.favoriteVenue.Promotions.VenuePromotions.count == 1 {
                self.pageControl.isHidden = true
            }
            self.arrCollectionData = self.favoriteVenue.Promotions.VenuePromotions
            self.pageControl.numberOfPages = self.favoriteVenue.Promotions.VenuePromotions.count
            
        }else if self.favoriteVenue.Promotions.VenuePromotions.count == 0 && self.favoriteVenue.VenueOpenHours.count > 0{
            
            self.collectionViewSilderHeightCont.constant = 0.0
            self.pageControl.isHidden = true
            
        }else if self.favoriteVenue.Promotions.VenuePromotions.count > 0 && self.favoriteVenue.VenueOpenHours.count == 0{
            
            self.collectionViewSilderHeightCont.constant =  102.0
            self.pageControl.isHidden = false
            if self.favoriteVenue.Promotions.VenuePromotions.count == 1 {
                self.pageControl.isHidden = true
            }
            self.arrCollectionData = self.favoriteVenue.Promotions.VenuePromotions
            self.pageControl.numberOfPages = self.favoriteVenue.Promotions.VenuePromotions.count
            
        }else if self.favoriteVenue.Promotions.VenuePromotions.count == 0 && self.favoriteVenue.VenueOpenHours.count == 0{
            self.collectionViewSilderHeightCont.constant = 0.0
            self.pageControl.isHidden = true
        }
        
        self.collectionViewSilder.reloadData()
        let newPromosIndex = self.arrCollectionData.index(where: {($0 as? WUVenueLocalPromotions)?.HasRead.toBool() == false})
        if newPromosIndex != nil {
            self.collectionViewSilder.scrollToItem(at: IndexPath(row: newPromosIndex!, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
        }
    }
    
    //MARK: -  Load Cells
    private func loadCollectionCellNib(){
        self.collectionViewSilder.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()))
    }
    
    // MARK: - Action Methods
    @IBAction func buttonDistance(_ sender: Any) {
        
    }
    
    @IBAction func buttonVideoAction(_ sender: Any) {
        if let delegate = self.delegate{
            delegate.favoriteDateRangeTableCellLiveCamButtonClicked(cell: self, withFavorite: self.favoriteVenue.LiveCams.LocalLiveCams)
        }
    }
    
    @IBAction func buttonOpenTimeSheetAction(_ sender: Any) {
        //        if let delegate = self.delegate{
        //            delegate.buttonTimeSheetClicked!(cell: self)
        //        }
    }
    
    @IBAction func buttonTimeSheetWithStatus(_ sender: Any) {
        if let delegate = self.delegate{
            delegate.buttonTimeSheetClicked(cell: self)
        }
    }
}

//MARK: - Collection View
extension WUFavoriteDateRangeTableCell : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCollectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), for: indexPath) as! WUHomeSliderCollectionCell
        
        cell.isNewPromos = true
        cell.venueLocalPromotion = self.arrCollectionData[indexPath.row] as! WUVenueLocalPromotions

        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewSilder.frame.size.width - 2 , height: 99.0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = self.collectionViewSilder.frame.size.width - 2
        self.pageControl.currentPage = Int(((self.collectionViewSilder.contentOffset.x + pageWidth) / pageWidth) - 1)

    }

 
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if let iPath = collectionViewSilder?.indexPathsForVisibleItems.first {
            print("DidEndDecelerating - visible cell is: ", iPath)
          //  (collectionViewSilder.visibleCells.first as! WUHomeSliderCollectionCell).markPromoAsRead()
           // (self.arrCollectionData[iPath.row] as! WUVenueLocalPromotions).HasRead = "True"
        }
    }
    


}

