//
//  WUCategoryCollectionCell.swift
//  Wussup
//
//  Created by MAC219 on 6/19/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

enum VenueCategoryID : String { 
    case ArtsEntertainment = "1"
    case Music = "2"
    case College = "3"
    case Event = "4"
    case Food = "5"
    case Nightlife = "6"
    case Outdoors = "7"
    case Other = "8"
    case Residence = "9"
    case Shop = "10"
    case Travel = "11"
    case Cafes = "12"
    case LiveCam = "13"
    case LocalPromotions = "14"
}

class WUCategoryCollectionCell: UICollectionViewCell {
   
    @IBOutlet private weak var imageViewCategory: UIImageView!
    @IBOutlet private weak var labelCategory: UILabel!
    
    var setCategory : WUCategory! {
        didSet{
            self.setCellDetail()
        }
    }
    
    var shareOption : WUShareOptions! {
        didSet{
            self.setShareOptionCellDetail()
        }
    }

    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.imageViewCategory.layer.cornerRadius = self.imageViewCategory.frame.size.width.propotional / 2
    }
    
    //MARK: - Initial Interface SetUp
    
    private func setCellDetail() {
        self.imageViewCategory.clipsToBounds = true
        
        self.imageViewCategory.sd_setShowActivityIndicatorView(true)
        self.imageViewCategory.sd_setIndicatorStyle(.white)
        self.imageViewCategory.sd_setImage(with:URL(string:self.setCategory.UnSelectedImageURL), placeholderImage: UIImage(named:"placeholder.png" ))
        
        self.labelCategory.text = self.setCategory.WussupName
        self.labelCategory.textColor =  UIColor.white
        
        if self.setCategory.isSelected == true {
            
            if self.setCategory.ID == VenueCategoryID.ArtsEntertainment.rawValue //Arts & Entertainment"
            {
                self.labelCategory.textColor = .ArtsEntertainmentColor
            }
            else if self.setCategory.ID == VenueCategoryID.Music.rawValue //Music
            {
                self.labelCategory.textColor = .MusicColor
            }
            else if self.setCategory.ID == VenueCategoryID.College.rawValue //College
            {
                self.labelCategory.textColor = .CollegesColor
            }
            else if self.setCategory.ID == VenueCategoryID.Event.rawValue //Event
            {
                self.labelCategory.textColor = .EventColor
            }
            else if self.setCategory.ID == VenueCategoryID.Food.rawValue //Food
            {
                self.labelCategory.textColor = .FoodColor
            }
            else if self.setCategory.ID == VenueCategoryID.Nightlife.rawValue //Nightlife
            {
                self.labelCategory.textColor = .NightLifeColor
            }
            else if self.setCategory.ID == VenueCategoryID.Outdoors.rawValue //Outdoors
            {
                self.labelCategory.textColor = .OutDoorsColor
            }
            else if self.setCategory.ID == VenueCategoryID.Other.rawValue //Other
            {
                self.labelCategory.textColor = .OtherColor
            }
            else if self.setCategory.ID == VenueCategoryID.Residence.rawValue //Residence
            {
                self.labelCategory.textColor = .OtherColor
            }
            else if self.setCategory.ID == VenueCategoryID.Shop.rawValue //Shop
            {
                self.labelCategory.textColor = .ShopColor
            }
            else if self.setCategory.ID == VenueCategoryID.Travel.rawValue //Travel
            {
                self.labelCategory.textColor = .TravelColor
            }
            else if self.setCategory.ID == VenueCategoryID.Cafes.rawValue //Cafes
            {
                self.labelCategory.textColor = .CafesColor
            }
            else if self.setCategory.ID == VenueCategoryID.LiveCam.rawValue //LiveCam
            {
                self.labelCategory.textColor = .LiveCamsColor
            }
            else if self.setCategory.ID == VenueCategoryID.LocalPromotions.rawValue //Local Promotions
            {
                self.labelCategory.textColor = .LoalPromosColor
            }
            
            self.imageViewCategory.sd_setImage(with:URL(string:self.setCategory.SelectedImageURL) , placeholderImage: UIImage(named:"placeholder.png" ))
        }
    }
    
    private func setShareOptionCellDetail() {
        self.imageViewCategory.clipsToBounds = true
        self.imageViewCategory.image = shareOption.normalImage
        self.labelCategory.text = self.shareOption.title
        self.labelCategory.textColor = .LightGrayColor
        if self.shareOption.shareOptionType == .rate || self.shareOption.shareOptionType == .favorite || self.shareOption.shareOptionType == .addToCalendar {
            if self.shareOption.isSelected == true{
                self.imageViewCategory.image = shareOption.selectedImage
            }
        }
    }
    
    func updateCellImage(){
        self.imageViewCategory.image = shareOption.normalImage
        if self.shareOption.isSelected == true{
            self.imageViewCategory.image = shareOption.selectedImage
        }
    }}
