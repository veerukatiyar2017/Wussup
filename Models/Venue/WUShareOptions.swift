//
//  WUShareOptions.swift
//  Wussup
//
//  Created by MAC26 on 17/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUShareOptions: NSObject {
    var selectedImage : UIImage!
    var normalImage : UIImage!
    var title : String!
    var shareOptionType : shareOptions = .none
    var isSelected : Bool = false
    
    var shareImage : String!
    var shareTitle : String!
    var arraySharePromotion : [WUVenueLocalPromotions] = []
    
    
    init(title : String, normalImage : UIImage, selectedImage :UIImage,shareOptionType : shareOptions) {
        self.title = title
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        self.shareOptionType = shareOptionType
    }
    
    init(shareImage : String , shareTitle : String , arraySharePromotion : [WUVenueLocalPromotions]){
        self.shareImage = shareImage
        self.shareTitle = shareTitle
        self.arraySharePromotion = arraySharePromotion
    }
    
    init(shareImage : String , shareTitle : String){
        self.shareImage = shareImage
        self.shareTitle = shareTitle
    }
    
    enum shareOptions:Int{
        case none
        case call
        case share
        case favorite
        case liveCam
        case website
        case addToCalendar
        case follow
        case rate
        case facebook
        case twitter
        case instagram
    }
    
    
}
