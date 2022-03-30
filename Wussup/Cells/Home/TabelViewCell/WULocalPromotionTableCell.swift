//
//  WULocalPromotionTableCell.swift
//  Wussup
//
//  Created by MAC105 on 10/09/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class WULocalPromotionTableCell: UITableViewCell {
    
    typealias TypePlaceholder = WUPlaceholder.TypePlaceholder

    //MARK: - IBOutlets
    @IBOutlet private weak var viewContainer              : UIView!
    @IBOutlet private weak var imageViewCategoryIcon      : UIImageView!
    @IBOutlet private weak var labelCategoryTitle         : UILabel!
    @IBOutlet private weak var labelCountOfCategory       : UILabel!
    @IBOutlet private weak var buttonViewAllOfCategory    : UIButton!
    @IBOutlet weak var collectionView                     : UICollectionView!
    @IBOutlet weak var viewSeparator: UIView!
    
    @IBOutlet weak var collectionBottomConst: NSLayoutConstraint!
    @IBOutlet weak var viewContainerBottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var noVenuePlaceholder: UIImageView!
    @IBOutlet weak var buttonViewAllWidthConst: NSLayoutConstraint!
    
    // MARK: - Variables
    weak var delegate : WUHomeTableCellDelegate?
    private var timerAnimation :Timer?
    var arrCollectionData : [Any] = []
    private var currentVisibleIndex = 0
    
    var categorizedVenue : Any!{
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
        if self.categorizedVenue is WULocalPromotions {
            self.labelCategoryTitle.text = (self.categorizedVenue as! WULocalPromotions).CategoryName.uppercased()
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: (self.categorizedVenue as! WULocalPromotions).CategoryImage), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: .lowPriority, completed : nil)
            
            if (self.categorizedVenue as! WULocalPromotions).VenuePromotions.count > 1 {
                self.arrCollectionData = (self.categorizedVenue as! WULocalPromotions).VenuePromotions.repeated(count: sliderRepeatCount)
                self.startTimerForchangeLocalPromotionImageAnimation()
            }else {
                self.arrCollectionData = (self.categorizedVenue as! WULocalPromotions).VenuePromotions
            }
            
            self.labelCountOfCategory.text = "(\((self.categorizedVenue as! WULocalPromotions).VenuePromotions.count))"
            if self.arrCollectionData.count == 0 {
                self.buttonViewAllWidthConst.constant = 0.0
                self.collectionView.isHidden = true
                self.noVenuePlaceholder.isHidden = false
                
                //  LocalPromotion noVenuePlaceholder
                if let url = delegate?.getPlaceholdersByKey(TypePlaceholder.LocalPromotion.stringValue).Url {
                    noVenuePlaceholder.sd_setImage(with: URL(string: url), completed: nil)
                } else {
                    //noVenuePlaceholder.image = UIImage.init(named: "UniversalPlaceholder")
                }
                
                self.labelCountOfCategory.text = ""
            }
            self.collectionBottomConst.constant = 22.0
            self.viewContainerBottomConst.constant = 35.0
            self.collectionView.isPagingEnabled = true
        }
        self.collectionView.reloadData()
    }
    
    //MARK: -  Load Cells
    private func loadCollectionCellNib(){
        self.collectionView.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()))
    }
    //MARK: - Action Methods
    @IBAction func buttonViewAllAction(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.homeTableCellViewAllButtonClicked(cell: self, withVenueCategory: self.categorizedVenue)
        }
    }
    
    // MARK: - Local promotion Animation methods
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
        if self.categorizedVenue is WULocalPromotions {
            if self.arrCollectionData.count > 0{
                self.currentVisibleIndex = self.currentVisibleIndex + 1
                if self.currentVisibleIndex >= self.arrCollectionData.count {
                    self.currentVisibleIndex = 0
                }
                if self.currentVisibleIndex < self.arrCollectionData.count{
                    DispatchQueue.main.async {
                        if self.currentVisibleIndex == 0 {
                            self.collectionView.scrollToItem(at:IndexPath(row: self.currentVisibleIndex, section: 0), at: UICollectionViewScrollPosition.right, animated: false)
                        }
                        else{
                            self.collectionView.scrollToItem(at:IndexPath(row: self.currentVisibleIndex, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
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
extension WULocalPromotionTableCell : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCollectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), for: indexPath)as! WUHomeSliderCollectionCell
        cell.venueLocalPromotion = self.arrCollectionData[indexPath.row] as! WUVenueLocalPromotions
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 100.0)//CGSize(width: 300.0, height: 100.0)
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
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if cell is WUHomeSliderCollectionCell{
//            Utill.printInTOConsole(printData:"Local Promotion collectionView willDisplay")
//            if indexPath.row > 0 {
//                self.stopTimerForLocalPromotion()
//            }
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        Utill.printInTOConsole(printData:"Local Promotion collectionView didEndDisplaying")
        if cell is WUHomeSliderCollectionCell {
            if self.arrCollectionData.count > 1{
                self.stopTimerForLocalPromotion()
                let currentPage = self.collectionView.contentOffset.x / self.collectionView.frame.size.width
                self.currentVisibleIndex = Int(currentPage)
                Utill.printInTOConsole(printData:"Local Promotion current index : \(currentPage)")
                self.startTimerForchangeLocalPromotionImageAnimation()
            }
        }
    }
}
extension WULocalPromotionTableCell : WURatingCollectionCellDelegate {
    
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
