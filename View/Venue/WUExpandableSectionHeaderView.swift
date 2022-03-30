//
//  WUExpandableSectionHeaderView.swift
//  Wussup
//
//  Created by MAC219 on 4/25/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - Delegate
protocol WUExpandableSectionHeaderViewDelegate:class {
    func expandableSectionHeaderView(didSelectExpandableSectionHeaderView headerView : UIView)
    func expandableSectionHeaderView(didSelectViewAll headerView : UIView)
}
extension WUExpandableSectionHeaderViewDelegate{
    func expandableSectionHeaderView(didSelectExpandableSectionHeaderView headerView : UIView){
        
    }
    func expandableSectionHeaderView(didSelectViewAll headerView : UIView){
        
    }
}


class WUExpandableSectionHeaderView: UITableViewHeaderFooterView {
    
    
    //MARK: - IBOutlet
    @IBOutlet  weak var viewExpandableSectionHeader  : UIView!
    @IBOutlet private weak var imageViewCategoryIcon        : UIImageView!
    @IBOutlet private weak var labelCategoryTitle           : UILabel!
    @IBOutlet private weak var labelCountOfCategory         : UILabel!
    @IBOutlet weak var buttonViewAllPhotos                  : UIButton!
    @IBOutlet weak var buttonArrowToExpandCell              : UIButton!
    @IBOutlet weak var viewSeperator: UIView!
    //MARK: - Variable
    weak var delegate   : WUExpandableSectionHeaderViewDelegate?
    var tapGesture      = UITapGestureRecognizer()
    
    var profileCategory : Any! {
        didSet{
            self.setCellDetail()
        }
    }
    
    //MARK: - Load Methods
    override func awakeFromNib() {
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(expandSectionHeaderViewAction(_:)))
        self.tapGesture.numberOfTapsRequired = 1
        self.viewExpandableSectionHeader.addGestureRecognizer(self.tapGesture)
        self.imageViewCategoryIcon.layer.cornerRadius = self.imageViewCategoryIcon.frame.size.width / 2
    }
    
    class func instanceFromNib() -> WUExpandableSectionHeaderView {
        return UINib(nibName: Utill.getClassNameFor(classType: WUExpandableSectionHeaderView()), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WUExpandableSectionHeaderView
    }
    
    // MARK: - Initial Setup
    func setCellDetail() {
        self.buttonViewAllPhotos.isHidden = true
        self.viewSeperator.isHidden = false
        self.imageViewCategoryIcon.sd_setShowActivityIndicatorView(true)
        self.imageViewCategoryIcon.sd_setIndicatorStyle(.white)
        //        if self.buttonArrowToExpandCell.isHidden == true {
        if profileCategory is WUVenueProfilePhotos {
            self.buttonViewAllPhotos.isHidden = false
            let photos = (profileCategory as! WUVenueProfilePhotos)
            self.labelCategoryTitle.text = photos.CategoryName.uppercased()
            self.labelCountOfCategory.text = "(\(photos.VenueImages.count))"
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: photos.CategoryImage), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
            
        }else  if profileCategory is WULocalPromotions {
            let promotion = (profileCategory as! WULocalPromotions)
            self.labelCategoryTitle.text = promotion.CategoryName.uppercased()
            self.labelCountOfCategory.text = "(\(promotion.VenuePromotions.count))"
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: promotion.CategoryImage), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
            
        }else  if profileCategory is WUSpecials {
            let specials = (profileCategory as! WUSpecials)
            self.labelCategoryTitle.text = specials.CategoryName.uppercased()
            self.labelCountOfCategory.text = "(\(specials.VenueSpecials.count))"
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: specials.CategoryImage), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
            
        }else  if profileCategory is WULiveCams {
            let liveCams = (profileCategory as! WULiveCams)
            self.labelCategoryTitle.text = liveCams.CategoryName.uppercased()
            self.labelCountOfCategory.text = "(\(liveCams.LocalLiveCams.count))"
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: liveCams.CategoryImage), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
            
        }else  if profileCategory is WUVenueHappyHours {
            let happyHours = (profileCategory as! WUVenueHappyHours)
            self.labelCategoryTitle.text = happyHours.CategoryName.uppercased()
            self.labelCountOfCategory.text = "(\(happyHours.HappyHours.count))"
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: happyHours.CategoryImage), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
            
        }else  if profileCategory is WUMenus {
            let menus = (profileCategory as! WUMenus)
            self.labelCategoryTitle.text = menus.CategoryName.uppercased()
            self.labelCountOfCategory.text = "(\(menus.VenueMenus.count))"
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: menus.CategoryImage), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
            
        }else  if profileCategory is WULiveMusic {
            let liveMusic = (profileCategory as! WULiveMusic)
            self.labelCategoryTitle.text = liveMusic.CategoryName.uppercased()
            self.labelCountOfCategory.text = "(\(liveMusic.VenueLiveMusics.count))"
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: liveMusic.CategoryImage), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
            
        }else  if profileCategory is WUSpecialEvents {
            let specialEvents = (profileCategory as! WUSpecialEvents)
            self.labelCategoryTitle.text = specialEvents.CategoryName.uppercased()
            self.labelCountOfCategory.text = "(\(specialEvents.VenueSpecialEvents.count))"
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: specialEvents.CategoryImage), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
        }else  if profileCategory is WUEventPhotoDetail {
            self.buttonViewAllPhotos.isHidden = false
            let eventPhoto = (profileCategory as! WUEventPhotoDetail)
            self.labelCategoryTitle.text = eventPhoto.Name.uppercased()
            self.labelCountOfCategory.text = "(\(eventPhoto.eventPhotos.count))"
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: eventPhoto.ImageURL), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
        }else  if profileCategory is WUEventPromoterDetail {
            let eventPromoter = (profileCategory as! WUEventPromoterDetail)
            self.labelCategoryTitle.text = eventPromoter.Name.uppercased()
            self.labelCountOfCategory.text = "(\(eventPromoter.eventPromoter.count))"
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: eventPromoter.ImageURL), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
        }else  if profileCategory is WUMoreEventDetail {
            let moreEvent = (profileCategory as! WUMoreEventDetail)
            self.labelCategoryTitle.text = moreEvent.Name.uppercased()
            self.labelCountOfCategory.text = "(\(moreEvent.MoreEvents.count))"
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: moreEvent.ImageURL), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
        }else  if profileCategory is WUEventDirectionDetail {
            let eventDirection = (profileCategory as! WUEventDirectionDetail)
            self.labelCategoryTitle.text = eventDirection.Name.uppercased()
            self.labelCountOfCategory.text = ""
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: eventDirection.ImageURL), placeholderImage:#imageLiteral(resourceName: "DirectionIcon") , options: [SDWebImageOptions.cacheMemoryOnly])
        }else  if profileCategory is WUMyEventListDetail {
            let eventList = (profileCategory as! WUMyEventListDetail)
            self.labelCategoryTitle.text = eventList.Name
            self.labelCountOfCategory.text = "(\(eventList.eventList.count))"
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: ""), placeholderImage:#imageLiteral(resourceName: "MyEventListIcon") , options: [SDWebImageOptions.cacheMemoryOnly])
        }
        else  if profileCategory is WUEventAdmissionDetail {
            let admissionDetail = (profileCategory as! WUEventAdmissionDetail)
            self.labelCategoryTitle.text = admissionDetail.Name
            self.labelCountOfCategory.text = "(\(admissionDetail.EventAdmission.count))"
            self.imageViewCategoryIcon.sd_setImage(with: URL(string: admissionDetail.ImageURL), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
        }
    }
    
    //MARK: - Action Methods
    
    @objc func expandSectionHeaderViewAction(_ sender : UITapGestureRecognizer) {
        if let delegate = self.delegate{
            delegate.expandableSectionHeaderView(didSelectExpandableSectionHeaderView: self)
        }
    }
    
    @IBAction func buttonViewAllPhotosActions(_ sender: Any) {
        Utill.printInTOConsole(printData:"buttonViewAllPhotosActions")
        if let delegate = self.delegate{
            delegate.expandableSectionHeaderView(didSelectViewAll: self)
        }
    }
    
    @IBAction func buttonArrowToExpandCellAction(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.expandableSectionHeaderView(didSelectExpandableSectionHeaderView: self)
        }
    }
}
