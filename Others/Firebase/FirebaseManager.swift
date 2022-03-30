//
//  FirebaseAnalytics.swift
//  Crush
//
//  Created by MAC99 on 06/12/17.
//  Copyright © 2017 Vidhi Patel. All rights reserved.
//

import UIKit
import Firebase

class FirebaseManager: NSObject {
    
    static let sharedInstance = FirebaseManager()
    
    //    func AppLaunch(parameter : [String:Any]?)  {
    //        var param = parameter
    //        if (param == nil)
    //        {
    //            param = [:]
    //        }
    //        param?["DeviceType"] =  "iPhone"
    //        Analytics.logEvent("AppLaunch", parameters: param)
    //
    //    }
    
    //MARK: - [join arvzapp] button tap :: signup_email_ios
    func signup_email_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.signup_email_ios, parameters: param)
    }
    
    //MARK: - [connect with facebook] button tap :: signup_fb_ios
    func signup_fb_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.signup_fb_ios, parameters: param)
    }
    
    //MARK: - [login] button tap :: login_ios
    func login_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.login_ios, parameters: param)
    }
    
    //MARK: - [submit] button tap :: forgot_pass_ios
    func forgot_pass_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.forgot_pass_ios, parameters: param)
    }
    
    //MARK: - [submit] button tap :: login_complete_ios
    func login_complete_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.login_complete_ios, parameters: param)
    }
    
    //MARK: -  tap on specific category
    func InterestCategoryTap(category : WUCategory)  {
        var param : [String:Any] = [:]
        param["DeviceType"] =  "iPhone"
        var name : String = ""
        if category.ID == VenueCategoryID.ArtsEntertainment.rawValue //Arts & Entertainment"
        {
            name = "artsnent"
        }
            
        else if category.ID == VenueCategoryID.Music.rawValue //Music
        {
            name = "music"
        }
        else if category.ID == VenueCategoryID.College.rawValue //College
        {
            name = "colleges"
        }
        else if category.ID == VenueCategoryID.Event.rawValue //Event
        {
            name = "events"
        }
        else if category.ID == VenueCategoryID.Food.rawValue //Food
        {
            name = "food"
        }
        else if category.ID == VenueCategoryID.Nightlife.rawValue //Nightlife
        {
            name = "nightlife"
        }
        else if category.ID == VenueCategoryID.Outdoors.rawValue //Outdoors
        {
            name = "outdoors"
        }
        else if category.ID == VenueCategoryID.Other.rawValue //Other
        {
            name = "other"
        }
        else if category.ID == VenueCategoryID.Shop.rawValue //Shop
        {
            name = "shop"
        }
        else if category.ID == VenueCategoryID.Travel.rawValue //Travel
        {
            name = "travel"
        }
        else if category.ID == VenueCategoryID.Cafes.rawValue //Cafes
        {
            name = "cafes"
        }
        else if category.ID == VenueCategoryID.LiveCam.rawValue //LiveCam
        {
            name = "livecams"
        }
        Analytics.logEvent("\(Text.FirebaseEventName.InterestCategoryTap)\(name.lowercased())_ios", parameters: param)
    }
    
    //MARK: -  [done] link tap :: onboard_skip_ios
    func onboard_skip_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.onboard_skip_ios, parameters: param)
    }
    
    //MARK: -  [skip] link tap :: onboard_complete_ios
    func onboard_complete_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.onboard_complete_ios, parameters: param)
    }
    
    
    //MARK: -  [view event] button tap (Hero video) (programmatic) :: ad_herovid_[GUID]_ios
    func ad_herovid_GUID_ios(parameter : [String:Any]? , videoBanner : WUHomeVideoList)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        let guId = videoBanner.GUID.replacingOccurrences(of: " ", with: "_")
        Analytics.logEvent("\(Text.FirebaseEventName.ad_herovid_GUID_ios)\(guId)_ios", parameters: param)
    }
    
    //MARK: -  [ad banner button tap (Hero video) (programmatic) :: ad_herobanner_GUID_ios
    func ad_herobanner_GUID_ios(parameter : [String:Any]? , homeBanner : WUHomeBannerList)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        let guId = homeBanner.GUID.replacingOccurrences(of: " ", with: "_")
        Analytics.logEvent("\(Text.FirebaseEventName.ad_herobanner_GUID_ios)\(guId)_ios", parameters: param)
    }
    
    //MARK: -  [share] tap (arvzapp) :: shareapp_ios
    func shareapp_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.shareapp_ios, parameters: param)
    }
    //MARK: - [claim a business] button tap :: claimbiz_start_ios
    func claimbiz_start_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.claimbiz_start_ios, parameters: param) // TODO
    }
    
    //MARK: - [view all] tap on top spots (sponsored venues) :: viewall_topspots_ios
    func viewall_topspots_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.viewall_topspots_ios, parameters: param)
    }
    
    //MARK: -  viewall_topspots_ios
    func viewall_localpromo_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.viewall_localpromo_ios, parameters: param)
    }
    
    //MARK: - viewall_livecam_ios
    func viewall_livecam_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.viewall_livecam_ios, parameters: param)
    }
    
    //MARK: - viewall_restaurant_ios
    func viewall_restaurant_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.viewall_restaurant_ios, parameters: param)
    }
    
    //MARK: - viewall_barpub_ios
    func viewall_barpub_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.viewall_barpub_ios, parameters: param)
    }
    
    //MARK: - viewall_shop_ios
    func viewall_shop_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.viewall_shop_ios, parameters: param)
    }
    
    //MARK: - viewall_entertain_ios
    func viewall_entertain_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.viewall_entertain_ios, parameters: param)
    }
    
    //MARK: - viewall_arts_ios
    func viewall_arts_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.viewall_arts_ios, parameters: param)
    }
    
    //MARK: - viewall_outdoor_ios
    func viewall_outdoor_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.viewall_outdoor_ios, parameters: param)
    }
    
    //MARK: - viewall_cafes_ios
    func viewall_cafes_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.viewall_cafes_ios, parameters: param)
    }
    
    //MARK: - claimbiz_complete_ios
    func claimbiz_complete_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.claimbiz_complete_ios, parameters: param)
    }
    
    //MARK: - view_venue_[GUID]_ios
    func view_venue_GUID_ios(parameter : [String:Any]? , venueDetailM : WUVenueDetail)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        let guId = venueDetailM.GUID.replacingOccurrences(of: " ", with: "_")
        Analytics.logEvent("\(Text.FirebaseEventName.view_venue_GUID_ios)\(guId)_ios", parameters: param)
    }
    
    //MARK: - play_venue_GUID_livecam_GUID_ios
    func play_venue_GUID_livecam_GUID_ios(parameter : [String:Any]?, playLiveCamVenueM : WUVenueDetail)  {
        var param = parameter
        if (param == nil) {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        if playLiveCamVenueM.LiveCams.LocalLiveCams.count > 0{
            let VenueGUID = playLiveCamVenueM.GUID.replacingOccurrences(of: " ", with: "_")
            let LiveCamGUID = playLiveCamVenueM.LiveCams.LocalLiveCams[0].GUID.replacingOccurrences(of: " ", with: "_")
            Analytics.logEvent("\(Text.FirebaseEventName.play_venue_GUID_livecam_GUID_ios)\(VenueGUID)_livecam_\(LiveCamGUID)_ios", parameters: param)
        }
    }
    
    //MARK: - map_open_ios
    func map_open_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.map_open_ios, parameters: param)
    }
    
    
    //MARK: - play_livecam_GUID_ios
    func play_livecam_GUID_ios(parameter : [String:Any]?, playLiveCamM : WUVenueLiveCams)  {
        var param = parameter
        if (param == nil) {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        let LiveCamGUID = playLiveCamM.GUID.replacingOccurrences(of: " ", with: "_")
        Analytics.logEvent("\(Text.FirebaseEventName.play_livecam_GUID_ios)\(LiveCamGUID)_ios", parameters: param)
    }
    
    //MARK: - view_event_GUID_ios
    func view_event_GUID_ios(parameter : [String:Any]?, EventM : WUEvent)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        let EventGUID = EventM.GUID.replacingOccurrences(of: " ", with: "_")
        Analytics.logEvent("\(Text.FirebaseEventName.view_event_GUID_ios)\(EventGUID)_ios", parameters: param)
    }
    
    //MARK: - view_event_GUID_ios
    func view_event_GUID_livecam_GUID_ios(parameter : [String:Any]?, playLiveCamEventM : WUEventDetail)  {
        var param = parameter
        if (param == nil){
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        if playLiveCamEventM.LiveCamsURL.count > 0{
            let EventGUID = playLiveCamEventM.GUID.replacingOccurrences(of: " ", with: "_")
            let LiveCamGUID = playLiveCamEventM.LiveCamsURL[0].GUID.replacingOccurrences(of: " ", with: "_")
            Analytics.logEvent("\(Text.FirebaseEventName.view_event_GUID_livecam_GUID_ios)\(EventGUID)_livecam_\(LiveCamGUID)_ios", parameters: param)
        }
    }
    
    //MARK: - event_add_calendar_ios
    func event_add_calendar_ios(parameter : [String:Any]?)  {
        var param = parameter
        if (param == nil)
        {
            param = [:]
        }
        param?["DeviceType"] =  "iPhone"
        Analytics.logEvent(Text.FirebaseEventName.event_add_calendar_ios, parameters: param)
    }
}
