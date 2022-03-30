//
//  WUHomeTableCell.swift
//  Wussup
//
//  Created by MAC219 on 4/20/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - Delegate
protocol WUHomeTableCellDelegate : class {
    func homeTableCellViewAllButtonClicked(cell : UITableViewCell, withVenueCategory venueCategory : Any)
    func homeTableCellLiveCamButtonClicked(cell : UITableViewCell, withVenueCategory venueCategory : Any)
    func homeTableCell(homeTableCell : UITableViewCell, didSelectCellForVenue venue : Any  )
    func goToClaimBussinessScreenWithVenue(_ venue : WUVenue)
    func getPlaceholdersByKey(_ key : String) -> WUPlaceholder
}

extension WUHomeTableCellDelegate{
    func homeTableCellViewAllButtonClicked(cell : UITableViewCell, withVenueCategory venueCategory : Any){
        
    }
    func homeTableCellLiveCamButtonClicked(cell : UITableViewCell, withVenueCategory venueCategory : Any){
        
    }
    func homeTableCell(homeTableCell : UITableViewCell, didSelectCellForVenue venue : Any  ){
        
    }
    func goToClaimBussinessScreenWithVenue(_ venue : WUVenue){
    
    }
}

class WUHomeTableCell: UITableViewCell{
    
    typealias TypePlaceholder = WUPlaceholder.TypePlaceholder

    //MARK: - IBOutlets
    @IBOutlet private weak var viewContainer              : UIView!
    @IBOutlet private weak var imageViewCategoryIcon      : UIImageView!
    @IBOutlet private weak var labelCategoryTitle         : UILabel!
    @IBOutlet private weak var labelCountOfCategory       : UILabel!
    @IBOutlet private weak var buttonViewAllOfCategory    : UIButton!
    @IBOutlet weak var collectionView                     : UICollectionView!
    @IBOutlet weak var viewSeparator                      : UIView!
    
    @IBOutlet weak var collectionBottomConst              : NSLayoutConstraint!
    @IBOutlet weak var viewContainerBottomConst           : NSLayoutConstraint!

    @IBOutlet weak var noVenuePlaceholder                 : UIImageView!
    @IBOutlet weak var buttonViewAllWidthConst            : NSLayoutConstraint!
    
    // MARK: - Variables
    weak var delegate                                     : WUHomeTableCellDelegate?
    private var timerAnimation                            : Timer?
    private var arrCollectionData                         : [Any] = []
    private var currentVisibleIndex = 0
    
    var categorizedVenue : Any! {
        didSet {
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
        
        self.backgroundColor = .mainBackgroundColor
        self.viewContainer.dropShadow()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.imageViewCategoryIcon.layer.cornerRadius = self.imageViewCategoryIcon.frame.size.width.propotional / 2
    }
    
    private func setCellDetail() {
        self.loadCollectionCellNib()
        self.imageViewCategoryIcon.sd_imageIndicator = SDWebImageActivityIndicator.white
//        self.imageViewCategoryIcon.sd_setShowActivityIndicatorView(true)
//        self.imageViewCategoryIcon.sd_setIndicatorStyle(.white)
        self.collectionBottomConst.constant = 23.0
        self.viewContainerBottomConst.constant = 30.0
        
        self.buttonViewAllWidthConst.constant = 49.0.propotional
        self.collectionView.isHidden = false
        self.noVenuePlaceholder.isHidden = true
        
        self.collectionView.isPagingEnabled = false
        
        // WUTopSpots
        if self.categorizedVenue is WUTopSpots {
            self.labelCategoryTitle.text = (self.categorizedVenue as! WUTopSpots).CategoryName.uppercased()
            
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: (self.categorizedVenue as! WUTopSpots).CategoryImage),
                                                   placeholderImage:#imageLiteral(resourceName: "placeholder"),
                                                   options: .lowPriority,
                                                   completed: nil)
            
            self.arrCollectionData = (self.categorizedVenue as! WUTopSpots).Venues
            self.labelCountOfCategory.text = "(\((self.categorizedVenue as! WUTopSpots).Venues.count))"
            
            if self.arrCollectionData.count == 0 {
                self.buttonViewAllWidthConst.constant = 0.0
                self.collectionView.isHidden = true
                self.noVenuePlaceholder.isHidden = false
                
                // WUTopSpots noVenuePlaceholder
                if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.TopSpotAds.stringValue).Url {
                    noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
                } else {
                    //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                }
                self.labelCountOfCategory.text = ""
            }
            
            // !ArtsEntertainment !Other
        } else {
            if (self.categorizedVenue as! WUCategorisedVenues).CategoryID != VenueCategoryID.ArtsEntertainment.rawValue && (self.categorizedVenue as! WUCategorisedVenues).CategoryID != VenueCategoryID.Other.rawValue {
                
                self.labelCategoryTitle.text = (self.categorizedVenue as! WUCategorisedVenues).CategoryName.uppercased()
                self.imageViewCategoryIcon.sd_setImage(with: URL(string: (self.categorizedVenue as! WUCategorisedVenues).CategoryImage),
                                                       placeholderImage:#imageLiteral(resourceName: "placeholder"),
                                                       options: .lowPriority,
                                                       completed: nil)
                // Event
                if (self.categorizedVenue as! WUCategorisedVenues).CategoryID == VenueCategoryID.Event.rawValue {
                   self.arrCollectionData = (self.categorizedVenue as! WUCategorisedVenues).Events
                     self.labelCountOfCategory.text = "(\((self.categorizedVenue as! WUCategorisedVenues).Events.count))"
                    
                    if self.arrCollectionData.count == 0 {
                        self.buttonViewAllWidthConst.constant = 0.0
                        self.collectionView.isHidden = true
                        self.noVenuePlaceholder.isHidden = false
                        
                        // Event noVenuePlaceholder
                        if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.Event.stringValue).Url {
                            noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
                        } else {
                            //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                        }
                        self.labelCountOfCategory.text = ""
                    }
                    
                } else {
                    self.arrCollectionData = (self.categorizedVenue as! WUCategorisedVenues).Venues
                    self.labelCountOfCategory.text = "(\((self.categorizedVenue as! WUCategorisedVenues).Venues.count))"
                    
                    if self.arrCollectionData.count == 0 {
                        self.buttonViewAllWidthConst.constant = 0.0
                        self.collectionView.isHidden = true
                        self.noVenuePlaceholder.isHidden = false
                        
                        // Outdoors noVenuePlaceholder
                        if (self.categorizedVenue as! WUCategorisedVenues).CategoryID == VenueCategoryID.Food.rawValue {
                            if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.Food.stringValue).Url {
                                noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
                            } else {
                                //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                            }
                        }
                        
                        // Outdoors noVenuePlaceholder
                        if (self.categorizedVenue as! WUCategorisedVenues).CategoryID == VenueCategoryID.Outdoors.rawValue {
                            if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.Outdoors.stringValue).Url {
                                noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
                            } else {
                                //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                            }
                        }
                        
                        // Cafes noVenuePlaceholder
                        if (self.categorizedVenue as! WUCategorisedVenues).CategoryID == VenueCategoryID.Cafes.rawValue {
                            if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.Cafes.stringValue).Url {
                                noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
                            } else {
                                //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                            }
                        }
                        
                        // CardGraphic noVenuePlaceholder
//                        if (self.categorizedVenue as! WUCategorisedVenues).CategoryID == VenueCategoryID.CardGraphic.rawValue {
//                            if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.CardGraphic.stringValue).Url {
//                                noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
//                            } else {
//                                //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
//                            }
//                        }
                        
                        // Colleges noVenuePlaceholder
                        if (self.categorizedVenue as! WUCategorisedVenues).CategoryID == VenueCategoryID.College.rawValue {
                            if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.Colleges.stringValue).Url {
                                noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
                            } else {
                                //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                            }
                        }
                        
                        // Music noVenuePlaceholder
                        if (self.categorizedVenue as! WUCategorisedVenues).CategoryID == VenueCategoryID.Music.rawValue {
                            if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.Music.stringValue).Url {
                                noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
                            } else {
                                //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                            }
                        }
                        
                        // Shop noVenuePlaceholder
                        if (self.categorizedVenue as! WUCategorisedVenues).CategoryID == VenueCategoryID.Shop.rawValue {
                            if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.Shop.stringValue).Url {
                                noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
                            } else {
                                //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                            }
                        }
                        
                        // Travel noVenuePlaceholder
                        if (self.categorizedVenue as! WUCategorisedVenues).CategoryID == VenueCategoryID.Travel.rawValue {
                            if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.Travel.stringValue).Url {
                                noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
                            } else {
                                //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                            }
                        }
                        
                        // Nightlife noVenuePlaceholder
                        if (self.categorizedVenue as! WUCategorisedVenues).CategoryID == VenueCategoryID.Nightlife.rawValue {
                            if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.Nightlife.stringValue).Url {
                                noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
                            } else {
                                //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                            }
                        }
 
                        self.labelCountOfCategory.text = ""
                    }
                }
            }
        }
        
        self.collectionView.reloadData()
    }
    
    //MARK: -  Load Cells
    private func loadCollectionCellNib() {
        
        if self.categorizedVenue is WUCategorisedVenues, (self.categorizedVenue as! WUCategorisedVenues).CategoryID == VenueCategoryID.Event.rawValue {
            self.collectionView.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeTitleCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeTitleCollectionCell()))
        } else {
          self.collectionView.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeRatingCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeRatingCollectionCell()))
        }
     }
   
    //MARK: - Action Methods
    @IBAction func buttonViewAllAction(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.homeTableCellViewAllButtonClicked(cell: self, withVenueCategory: self.categorizedVenue)
        }
    } 
}
//MARK: - Collection View 
extension WUHomeTableCell : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCollectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       if self.categorizedVenue is WUCategorisedVenues , (self.categorizedVenue as! WUCategorisedVenues).CategoryID == VenueCategoryID.Event.rawValue{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeTitleCollectionCell()), for: indexPath)as! WUHomeTitleCollectionCell
            cell.delegate = self
            cell.venueLiveCamsOrArtEntmt = arrCollectionData[indexPath.row] as! WUEventDetail
            return cell
            
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeRatingCollectionCell()), for: indexPath)as! WUHomeRatingCollectionCell
            cell.delegate = self
            cell.venue = arrCollectionData[indexPath.row] as! WUVenue
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240.0, height: 170.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.arrCollectionData[indexPath.row] is WUVenue {
            let venueObject = self.arrCollectionData[indexPath.row] as! WUVenue
            if let delegate = self.delegate {
                delegate.homeTableCell(homeTableCell: self, didSelectCellForVenue: venueObject)
            }
        }else {
            if let delegate = self.delegate {
                delegate.homeTableCell(homeTableCell: self, didSelectCellForVenue: self.arrCollectionData[indexPath.row])
            }
        }
    }
}
extension WUHomeTableCell : WURatingCollectionCellDelegate {
    
    func ratingCollectionCellLiveCamButtonClicked(cell: WUHomeRatingCollectionCell, withVenueCategory venueCategory: Any) {
        if let delegate = self.delegate{
            delegate.homeTableCellLiveCamButtonClicked(cell: self, withVenueCategory: venueCategory)
        }
    }
    
    func goToClaimBussinessScreenWithVenue(_ venue : WUVenue) {
         if let delegate = self.delegate{
            delegate.goToClaimBussinessScreenWithVenue(venue)
        }
    }
}
extension WUHomeTableCell : WUHomeTitleCollectionCellDelegate {
    func homeTilteCollectionCellLiveCamButtonClicked(cell: WUHomeTitleCollectionCell, withVenueCategory venueCategory: Any) {
        if let delegate = self.delegate{
            delegate.homeTableCellLiveCamButtonClicked(cell: self, withVenueCategory: venueCategory)
        }
    }
}
