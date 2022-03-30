//
//  WUHomeViewAndCollectionTableCell.swift
//  Wussup
//
//  Created by MAC219 on 4/20/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

class WUHomeViewAndCollectionTableCell: UITableViewCell {
    
    typealias TypePlaceholder = WUPlaceholder.TypePlaceholder

    // MARK: - IBOutlets
    @IBOutlet private weak var viewContainer            : UIView!
    @IBOutlet private weak var imageViewCategoryIcon    : UIImageView!
    @IBOutlet private weak var labelCategoryTitle       : UILabel!
    @IBOutlet private weak var labelCountOfCategory     : UILabel!
    @IBOutlet private weak var buttonViewAllOfCategory  : UIButton!
    @IBOutlet private weak var collectionView           : UICollectionView!
    @IBOutlet private weak var imageViewStatic          : UIImageView!
    @IBOutlet private weak var imageViewOverLayStatic   : UIImageView!
    @IBOutlet private weak var buttonDistance           : UIButton!
    @IBOutlet private weak var labelTitle               : UILabel!
    @IBOutlet private weak var buttonVideo              : UIButton!
    @IBOutlet weak var viewSeparator                    : UIView!
    @IBOutlet private weak var collectionViewHeight     : NSLayoutConstraint!
    @IBOutlet weak var noVenuePlaceholder               : UIImageView!
    @IBOutlet weak var buttonViewAllWidthConst          : NSLayoutConstraint!
    
//    @IBOutlet weak var viewClaimABusinessAlert: UIView!
//    @IBOutlet weak var buttonClaimThisBusiness: UIButton!
    
    // MARK: - Variables
    private var arrCollectionData : [Any]! = []
    private var arrCollectionDataCopy : [Any]! = []
    weak var delegate : WUHomeTableCellDelegate?
    var tapGesture      = UITapGestureRecognizer()
    
    var liveCames : WULiveCams! {
        didSet{
            self.setCellDetail()
        }
    }
    
    var artAndEntmt : WUCategorisedVenues!{
        didSet{
            self.setArtAndEntmtDetail()
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
       
        self.backgroundColor = .mainBackgroundColor
        self.buttonDistance.backgroundColor = .buttonDistanceColor
        self.viewContainer.dropShadow()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.imageViewCategoryIcon.layer.cornerRadius = self.imageViewCategoryIcon.frame.size.width / 2
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(expandSectionHeaderViewAction(_:)))
        self.tapGesture.numberOfTapsRequired = 1
        self.imageViewStatic.isUserInteractionEnabled = true
        self.imageViewStatic.addGestureRecognizer(self.tapGesture)
//        if self.viewClaimABusinessAlert.isHidden == false{
//            self.buttonClaimThisBusiness.tintColor = .LoalPromosColor
//            self.buttonClaimThisBusiness.backgroundColor = .ClaimThisBusinessColor
//            self.buttonClaimThisBusiness.layer.borderColor = UIColor.LoalPromosColor.cgColor
//            self.viewClaimABusinessAlert.layer.borderColor = UIColor.LoalPromosColor.cgColor
//        }
    }
    
    private func setCellDetail() {
        self.loadCollectionCellNib()
        self.buttonViewAllOfCategory.tag = 1000
        self.buttonDistance.isHidden = true
        self.viewContainer.backgroundColor = .LiveCamYellowColor
        self.labelCountOfCategory.text = "(\(self.liveCames.LocalLiveCams.count))"
        self.labelCategoryTitle.text = self.liveCames.CategoryName.uppercased()
        self.imageViewCategoryIcon.sd_imageIndicator = SDWebImageActivityIndicator.white
//        self.imageViewCategoryIcon.sd_setShowActivityIndicatorView(true)
//        self.imageViewCategoryIcon.sd_setIndicatorStyle(.white)
        self.imageViewCategoryIcon.sd_setImage(with: URL(string: liveCames.CategoryImage),
                                               placeholderImage:#imageLiteral(resourceName: "placeholder"),
                                               options: .refreshCached)
        
        self.manageNoVenueFound(isShow: false) // 1 LIVE CAMS
        //manage height of cell based on array count 
        self.arrCollectionDataCopy = liveCames.LocalLiveCams.map { $0 }
        
        if self.arrCollectionDataCopy.count == 0 {
            self.labelCountOfCategory.text = ""
            self.manageNoVenueFound(isShow: true)
        } else if self.arrCollectionDataCopy.count == 1 {
            //self.collectionView.isHidden = true
            self.collectionViewHeight.constant = 0.0
        }else{
            // self.collectionView.isHidden = false
            self.collectionViewHeight.constant = 170.0
        }
        
        if self.arrCollectionDataCopy.count > 0 {
            //set table cell data and manage data to the collection cell
//            self.imageViewStatic.sd_setShowActivityIndicatorView(true)
//            self.imageViewStatic.sd_setIndicatorStyle(.white)
            self.imageViewStatic.sd_imageIndicator = SDWebImageActivityIndicator.white
            if (self.arrCollectionDataCopy[0] as! WUVenueLiveCams).LiveCamURL != "" {
                self.buttonVideo.isHidden = false
            }
            self.labelTitle.text = (self.arrCollectionDataCopy[0] as! WUVenueLiveCams).Name
            self.imageViewStatic.sd_setImage(with: URL(string: (self.arrCollectionDataCopy[0] as! WUVenueLiveCams).ImageURL),
                                             placeholderImage:#imageLiteral(resourceName: "placeholder"),
                                             options: .refreshCached)
            // self.viewClaimABusinessAlert.isHidden = true
            
            self.arrCollectionData = Array(self.arrCollectionDataCopy.dropFirst())
            self.collectionView.reloadData()
        }
    }
    
    private func setArtAndEntmtDetail() {
        
        self.loadCollectionCellNib()
        self.buttonViewAllOfCategory.tag = 2000
        self.viewContainer.backgroundColor = .white
        self.buttonVideo.isHidden = true
        self.labelCountOfCategory.text = "(\(self.artAndEntmt.Venues.count))"
        self.labelCategoryTitle.text = self.artAndEntmt.CategoryName.uppercased()
       
//        self.imageViewCategoryIcon.sd_setShowActivityIndicatorView(true)
//        self.imageViewCategoryIcon.sd_setIndicatorStyle(.white)
        self.imageViewCategoryIcon.sd_setImage(with: URL(string: self.artAndEntmt.CategoryImage),
                                               placeholderImage:#imageLiteral(resourceName: "placeholder"),
                                               options: .refreshCached)
        
        self.manageNoVenueFound(isShow: false) //2 LIVE CAMS / ARTS & ENTMT. / OTHER
        self.buttonDistance.isHidden = false
        //manage height of cell based on array count
        self.arrCollectionDataCopy = self.artAndEntmt.Venues.map { $0 }
        
        if self.arrCollectionDataCopy.count == 0 {
            self.labelCountOfCategory.text = ""
            self.buttonDistance.isHidden = true
            self.manageNoVenueFound(isShow: true) // 3 ARTS & ENTMT. / OTHER
        } else if self.arrCollectionDataCopy.count == 1 {
            self.collectionViewHeight.constant = 0.0
        } else {
            self.collectionViewHeight.constant = 170.0
        }
        
        if self.arrCollectionDataCopy.count > 0 {
            //set table cell data and manage data to the collection cell
            self.imageViewStatic.sd_imageIndicator = SDWebImageActivityIndicator.white
//            self.imageViewStatic.sd_setShowActivityIndicatorView(true)
//            self.imageViewStatic.sd_setIndicatorStyle(.white)
            
            self.labelTitle.text = (self.arrCollectionDataCopy[0] as! WUVenue).VenueName
            if (self.arrCollectionDataCopy[0] as! WUVenue).LiveCamsURLs.count > 0 {
                self.buttonVideo.isHidden = false
            }
            self.buttonDistance.setTitle(NSString(format: "%0.2f Mi", Float((self.arrCollectionDataCopy[0] as! WUVenue).VenueDistance) ?? 0) as String, for:.normal)
             self.buttonDistance.backgroundColor = UIColor.buttonDistanceColor
            
            if (self.arrCollectionDataCopy[0] as! WUVenue).VenueImages.count > 0
            {
                let coverImage = (self.arrCollectionDataCopy[0] as! WUVenue).VenueImages.filter({$0.IsConverPhoto.toBool() == true})
                if coverImage.count > 0 {
                    self.imageViewStatic.sd_setImage(with: URL(string: coverImage[0].RactangleImage),
                                                     placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto"),
                                                     options: .refreshCached)
                }else {
                    self.imageViewStatic.image = #imageLiteral(resourceName: "NullState_CoverPhoto")
                }
//                self.imageViewStatic.sd_setImage(with: URL(string: (self.arrCollectionDataCopy[0] as! WUVenue).VenueImages[0].RactangleImage), placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto") , options: [SDWebImageOptions.cacheMemoryOnly])
            }else {
                self.imageViewStatic.image = #imageLiteral(resourceName: "NullState_CoverPhoto")
            }
            
//            self.viewClaimABusinessAlert.isHidden = true
//            if (self.arrCollectionDataCopy[0] as! WUVenue).IsSponseredVenues.toBool() == false && (self.arrCollectionDataCopy[0] as! WUVenue).IsClaimVenue.toBool() == false
//            {
//                self.viewClaimABusinessAlert.isHidden = false
//            }
            
            self.arrCollectionData = Array(self.arrCollectionDataCopy.dropFirst())
            self.collectionView.reloadData()
        }
    }
    
    func manageNoVenueFound(isShow : Bool ) {
        
        if isShow == true {
            self.collectionViewHeight.constant = 0.0
            self.imageViewStatic.isHidden = true
            self.imageViewOverLayStatic.isHidden = true
//            self.viewClaimABusinessAlert.isHidden = true
            self.labelTitle.isHidden = true
            
            self.buttonViewAllWidthConst.constant = 0.0
            self.collectionView.isHidden = true
            self.noVenuePlaceholder.isHidden = false
            
            // LiveCams noVenuePlaceholder ???
            if self.artAndEntmt.CategoryID == VenueCategoryID.LiveCam.rawValue {
                if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.LiveCams.stringValue).Url {
                    noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
                } else {
                    //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                }
            }
            
            // ArtsEntertainment noVenuePlaceholder
            if self.artAndEntmt.CategoryID == VenueCategoryID.ArtsEntertainment.rawValue {
                if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.ArtsandEntertainment.stringValue).Url {
                    noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
                } else {
                    //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                }
            }
            
            // Other noVenuePlaceholder
            if self.artAndEntmt.CategoryID == VenueCategoryID.Other.rawValue {
                if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.Other.stringValue).Url {
                    noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
                } else {
                    //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                }
            }
            
        } else {
            self.buttonViewAllWidthConst.constant = 49.0.propotional
            self.collectionView.isHidden = false
            self.buttonVideo.isHidden = true
            self.imageViewStatic.isHidden = false
            self.imageViewOverLayStatic.isHidden = false
//            self.viewClaimABusinessAlert.isHidden = false
            self.labelTitle.isHidden = false
            self.noVenuePlaceholder.isHidden = true
        }
    }
    
    //MARK: -  Load Cells
    private func loadCollectionCellNib(){
        self.collectionView.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeTitleCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeTitleCollectionCell()))
    }
    
    
    //MARK: - Action Methods
    @IBAction func buttonViewAllAction(_ sender: UIButton) {
        if let delegate = self.delegate{
            if sender.tag == 1000 {
                delegate.homeTableCellViewAllButtonClicked(cell:self, withVenueCategory: self.liveCames)
            }else {
                delegate.homeTableCellViewAllButtonClicked(cell:self, withVenueCategory: self.artAndEntmt)
            }
        }
    }
    
    @objc func expandSectionHeaderViewAction(_ sender : UITapGestureRecognizer) {
        if let delegate = self.delegate{
            delegate.homeTableCell(homeTableCell: self, didSelectCellForVenue: self.arrCollectionDataCopy[0])
        }
    }
    
    @IBAction func buttonVideoAction(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.homeTableCellLiveCamButtonClicked(cell: self, withVenueCategory: self.arrCollectionDataCopy[0])
        }
    }
    
    @IBAction func buttonClaimThisBusinessAction(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.goToClaimBussinessScreenWithVenue(self.arrCollectionDataCopy[0] as! WUVenue)
        }
    }
}
//MARK: - Collection View
extension WUHomeViewAndCollectionTableCell : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCollectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeTitleCollectionCell()), for: indexPath)as! WUHomeTitleCollectionCell
        cell.venueLiveCamsOrArtEntmt = arrCollectionData[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240.0, height: 170.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.arrCollectionData[indexPath.row] is WUVenue
        {
            if let delegate = self.delegate
            {
                delegate.homeTableCell(homeTableCell: self, didSelectCellForVenue: self.arrCollectionData[indexPath.row])
            }
        }
        else {
            if let delegate = self.delegate{
                delegate.homeTableCell(homeTableCell: self, didSelectCellForVenue: self.arrCollectionData[indexPath.row])
            }

        }
    }
}

extension WUHomeViewAndCollectionTableCell : WUHomeTitleCollectionCellDelegate{
    func homeTilteCollectionCellLiveCamButtonClicked(cell: WUHomeTitleCollectionCell, withVenueCategory venueCategory: Any) {
        if let delegate = self.delegate{
            delegate.homeTableCellLiveCamButtonClicked(cell: self, withVenueCategory: venueCategory)
        }
    }
    
    func goToClaimBussinessScreenWithArtEntVenue(_ venue : WUVenue)
    {
        if let delegate = self.delegate {
            delegate.goToClaimBussinessScreenWithVenue(venue)
        }
    }
    
}
