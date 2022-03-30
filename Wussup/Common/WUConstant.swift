//
//  WUConstant.swift
//  Wussup
//
//  Created by MAC26 on 16/04/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import Alamofire

var AppName: String {return Bundle.main.infoDictionary!["CFBundleName"] as! String}
let AppDel                              = (UIApplication.shared.delegate as! AppDelegate)
let UserDefault                         = UserDefaults.standard

//MARK:- Webservice Api

//#if SANDBOX
//let API_URL                 = "http://35.172.39.47/Wussup_WebAPI_Sandbox/api/Wussup/"
//let APPSTORE_URL            = "https://itunes.apple.com/us/app/wussup-sandbox/id1382551189?ls=1&mt=8"
//let Bee_URL                 = "http://35.172.39.47/Wussup_WebAPI_Sandbox/bee/bee/Wussup%20Revolution.html" // Bee Animation
//
//let ACCUWEATHER_API_URL     = "http://apidev.accuweather.com/"
////let WEATHER_API_KEY       = "25xUNtGBW83A1SG0zweYBG0mGivjLD9o" // Test Account
//let WEATHER_API_KEY         = "hoArfRosT1215" // Test Account
//let AMAZON_S3_BUCKET_NAME   = "wussup-sandbox/App_Images"

//let API_URL               = "http://web1.anasource.com/Wussup_UAT/api/Wussup/"
//let APPSTORE_URL          = "https://itunes.apple.com/us/app/wussup-sandbox/id1382551189?ls=1&mt=8"
//let Bee_URL               = "http://new.anasource.com/team7/Mobile/Wussup/bee/Wussup%20Revolution.html" // Bee Animationo

//#else
//let API_URL_Wussup          = "http://125.63.74.98:59281/api/Wussup/" // test
//let API_URL_Location        = "http://125.63.74.98:59281/api/Location/" // test

//let API_URL_Wussup          = "http://35.172.39.47:59282/api/Wussup/" // Old
//let API_URL_Location        = "http://35.172.39.47:59282/api/Location/" // Old

let API_URL_Wussup          = "https://apps.arvzapp.com/api/Wussup/"
let API_URL_Location        = "https://apps.arvzapp.com/api/Location/"

//let API_URL                = "http://service.arvzapp.com/Wussup_WebAPI_Production/api/Wussup/"
let APPSTORE_URL            = "https://itunes.apple.com/us/app/arvzapp/id1436475855?ls=1&mt=8"
let Bee_URL                 = "http://service.arvzapp.com/Wussup_WebAPI_Production/bee/bee/Wussup%20Revolution.html" // Bee Animation
let ACCUWEATHER_API_URL     = "http://dataservice.accuweather.com/"
let WEATHER_API_KEY         = "7OHjkTWm64ovw8VTW6IAzPWvMYzRtYsY" // jeff account
let AMAZON_S3_BUCKET_NAME   = "wussup-production/App_Images"
//#endif

/*
 etle second http://dataservice.accuweather.com/currentconditions/v1/188165.json?language=en&apikey=25xUNtGBW83A1SG0zweYBG0mGivjLD9o
 
 ==================
 
 https://developer.accuweather.com/accuweather-current-conditions-api/apis/get/currentconditions/v1/%7BlocationKey%7D
 */
//let ACCUWEATHER_API_URL  = "http://apidev.accuweather.com/locations/v1/search?q="
//let TEST_WEATHER_API_KEY = "hoArfRosT1215" // Test Account
//let WEATHER_API_KEY = "25xUNtGBW83A1SG0zweYBG0mGivjLD9o" // Test Account
//let WEATHER_API_KEY = "7OHjkTWm64ovw8VTW6IAzPWvMYzRtYsY" // jeff account

let WEB_API : WUWebService   = WUWebService.API

// TwitterKit Key Test Account(test2252/tatva123)
let TwitterConsumerKey = "a7NVKVbeqyY0kX6ocrNQorhj1"
let TwitterConsumerSecret = "y7xNtf8HwzlPgd13NJVDyBXzLou2ubAAMRMeSOgVM1Xyfqkk9R"


// Amazon Key  Account
let AMAZON_S3_ACCESSKEY = "AKIAI6A7DDGTMU5HNWYA"
let AMAZON_S3_ACCESS_SECRETKEY = "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"
let AMAZON_URL = "https://s3.amazonaws.com/\(AMAZON_S3_BUCKET_NAME)/"

let GOOGLE_MAP_API_KEY = "AIzaSyBde6JzHzo8G-Au1AqXR_q4D0_2EmdgBHI" //"AIzaSyD2Oo0vASDUDpDs8UsJli8HQn8Ha_Uqgx8"//

//MARK:- Network
var isNetworkConnected = (NetworkReachabilityManager()?.isReachable)!


let GlobalShared             : WUGlobal       = WUGlobal.global

//MARK:- Alias for class name
typealias Utill             = WUUtill
typealias Text              = WUText
typealias Fonts             = WUFonts
typealias Global            = WUGlobal
typealias User              = WUUser
typealias HomeBanner        = [WUHomeBannerList]
typealias Json              = [String : Any]

//MARK:- Static Constants
let IPHONE6_WIDTH          = 375.0
let IPHONE6_HEIGHT         = 667.0 
let IPHONE6_PLUS_WIDTH     = 414.0
let IPHONE6_PLUS_HEIGHT    = 736.0
let IPHONEX_HEIGHT         = 812.0
let KEYBOARD_SIZE          = 216.0

let GoToTopConstant = CGFloat(200.0)
let beeAnimationWebViewTag = 5001
let timeSheetViewTag = 5002
let sliderRepeatCount = 100


struct Device {
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT       = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH   = max(SCREEN_WIDTH, SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH   = min(SCREEN_WIDTH, SCREEN_HEIGHT)
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
}

enum WUFonts: String {
    
    case NunitoSans_Black       = "NunitoSans-Black"
    
    func of(size: CGFloat) -> UIFont? {
        return UIFont(name: self.rawValue, size: size)
    }
}



