//
//  LPText.swift
//
//

import Foundation
import UIKit

struct Key {
    static let deviceToken                      = "DeviceToken"
    static let pngKey       = "jpg"
}

struct WUText {
    static var Label                : WULabel                = WULabel()
    static var Message              : WUMessage              = WUMessage()
    static var TextField            : WUTextField            = WUTextField()
    static var Segue                : WUSegue                = WUSegue()
    static var UDKeys               : WUUserDefaultKey       = WUUserDefaultKey()
    static var SearchFilterNames    : WUSearchFilterNames    = WUSearchFilterNames()
    static var DictKeys             : WUDictKey              = WUDictKey()
    static var FirebaseEventName    : WUFirebaseEventName    = WUFirebaseEventName()
    static var TextView             : WUTextView             = WUTextView()

    
    static func reset() {
        Label                = WULabel()
        Message              = WUMessage()
        TextField            = WUTextField()
        Segue                = WUSegue()
        Label                = WULabel()
        UDKeys               = WUUserDefaultKey()
        DictKeys             = WUDictKey()
        FirebaseEventName    = WUFirebaseEventName()
        TextView             = WUTextView()
    }
    
    struct Notification {
        static let addToCartNotification    = "addToCartNotification"
    }
    
    //Localize all these texts of Label for support multilanguage
    struct WULabel {
        let text_MoreButton = "More"
        let text_ShareData  = "SHARE"
        let text_Close = "Close"
        let text_AddToCalendar = "ADD TO CALENDAR"
        
        let text_Try_Again       = "Try Again"
        let text_Ok              = "OK"
        let text_Cancel          = "Cancel"
        let text_Yes             = "Yes"
        let text_Login           = "Sign In"
        let text_No              = "No"
        let text_GoToSetting     = "Settings"
        let text_BlankSpace      = ""
        let text_UpdateLater     = "Remind Me Later"
        let text_UpdateNow       = "Update Now"
       
//        let text_Closed = "CLOSED "
//        let text_OpenNow = "OPEN NOW: "
//        let text_Open = "OPEN: "
        let text_NoInformationFound = "No Information For Open Time"
//        let text_Closes = "CLOSES "
//        let text_Opens = "OPENS "
        
        let text_Closed = "CLOSED "
        let text_OpenNow = "OPEN "
        let text_Open = "OPEN "
        let text_Closes = "CLOSED "
        let text_Opens = "OPEN "
        
        //Home :: :: HomeViewController
        let text_TopSpots          =  "TOP SPOTS"
        let text_LocalPromotions   =  "LOCAL PROMOTIONS"
        let text_LiveCams          =  "LIVE CAMS"
        let text_Restaurants       =  "RESTAURANTS"
        let text_BarsAndPubs       =  "BARS AND PUBS"
        let text_Shopping          =  "SHOPPING"
        let text_Entertainment     =  "ENTERTAINMENT"
        let text_ArtsAndTheatre    =  "ARTS AND THEATER"
        let text_Outdoor           =  "OUTDOOR"
        let text_Destinations      =  "DESTINATIONS"
        let text_Casinos           =  "CASINOS"
        let text_AnimalRescue      =  "ANIMAL RESCUE"
        
        
        
        //Venue Profile Properties :: VenueProfileViewController
        
        let text_Photos             =  "PHOTOS"
        let text_Promotions         =  "PROMOTIONS"
        let text_Specials           =  "SPECIALS"
        //let text_LiveCams         =  "LIVE CAMS"
        let text_HappyHour          =  "HAPPY HOUR"
        let text_Menus              =  "MENUS"
        let text_LiveMusic          =  "LIVE MUSIC"
        let text_SpecialEvents      =  "SPECIAL EVENTS"
        
        let text_Call                   = "CALL"
        let text_Share                  = "SHARE"
        let text_Favorite               = "FAVORITE"
        let text_LiveCam                = "LIVE CAM"
        let text_Website                = "WEBSITE"
        let text_AddToCalender          = "CALENDAR"
        let text_Follow                 = "FOLLOW"
        let text_Rate                   = "RATE"
        let text_Facebook               = "FACEBOOK"
        let text_Twitter                = "TWITTER"
        let text_Insta                  = "INSTAGRAM"
        
        let text_ShareApp               = "Share the ARVZAPP"
        let text_SharePromotion         = "Share Our Promotions"
        
        let text_TwitterAccount                = "You are not logged in to your Twitter account."
        let text_FacebookAccount               = "You are not logged in to your Facebook account."
        let text_AllowAccessToLocation         = "Please allow us to use your location to get venues nearby you."
        let text_AllowAccessToCalender         = "Please allow us to use your Calender to add events."
        
        let text_EventList                = "EVENT LIST"
        let text_EventCategoties          = "EVENT CATEGORIES"
        let text_CalenderSucess           = "Event Successfully Added To Calendar"
        
        let text_Today                    = "TODAY"
        let text_Tomorrow                 = "TOMORROW"
        let text_ThisWeekend              = "THIS WEEKEND"
        let text_NextWeekend              = "NEXT WEEKEND"
        let text_Weekend                  = "WEEKEND"

        let text_ComingUp                 = "COMING UP"
        let text_More                     = "MORE"
        let text_ComingSoon               = "COMING SOON"
        
        
        let text_TotalLetter_Prefix = "8 - 20 "
        let text_TotalLetter_Suffix = "Characters"
        
        let text_CapitalLetter_Prefix = "Min "
        let text_CapitalLetter_Suffix = "One Capital Letter"
        
        let text_NumberLetter_Prefix = "Min "
        let text_NumberLetter_Suffix = "One Number"
        
        let text_FavoriteList           = "FAVORITES LIST"
        let text_FavoriteOptIn          = "FAVORITES OPT IN"
        
        let text_ProfileInfo          = "PROFILE INFORMATION"
        let text_ProfileUserName      = "User Name:"
        let text_ProfileCity          = "City:"
        let text_ProfileEmail         = "Email:"
        let text_ProfileMobile        = "Mobile:"
        let text_ProfileBirthday      = "Birthday:"
        let text_ProfileInterest      = "Interests:"
        let text_ProfileFavorites     = "Favorites:"
        let text_ProfileSelect        = "Select"
        let text_ProfileNotification  = "Notifications"//"Manage Notifications"
        let text_ProfileLogout        = "Log Out"
        
        let text_PerDay             = "  Per Day"
        let text_PerWeek            = "  Per Week"
        let text_PerMonth           = "  Per Month"
        let text_WeekendsNotification           = "Weekends"
        let text_SpecialEventNotification   = "Special Events"
        let text_X                  = "X"
         let text_PromotionNotification                  = "PROMOTIONAL NOTIFICATIONS"
         let text_OptIn                  = "Opt In"
         let text_NotificationFrequency                  = "NOTIFICATION FREQUENCY"
         let text_ReceiveAll                  = "Receive All"
        
        let text_GetReadyStr1 = "WussUp is the FREE,\n"
        let text_GetReadyStr2 = """
go-to, custom business
and consumer mobile app
that enables you to
enhance and plan your
social experience on the
go and in real time...
"""
        
        let text_Back = "  Back"
        let text_Done = "Done"
        let text_Continue = "CONTINUE"
        
        let text_LiveCamGrid            = "LIVE CAM GALLERY"
        let text_LiveCamList            = "LIVE CAMS LIST"
        let text_LiveCamProfile         = "LIVE CAM"
        
        let text_ProfileViewDetail_ThankYouVC = """
You have successfully
created your personal profile
"""
        let text_CABViewDetail_ThankYouVC = """
You have successfully
claimed your business!
"""
        let text_ProfileUpdated = """
You have successfully
updated your personal profile
"""
        let text_legal_official = "legal official "
        let text_byChecking = "By checking this box I affirm I am the legal official to claim"
        let text_allFieldRequired       = "All Fields Required"
        let text_venueEmailPhone        = "Please enter a valid venue, phone number, email"
        let text_validVenuePhoneNumber  =  "Please enter a valid venue, phone number"
        let text_validVenueEmail        = "Please enter a valid venue, email"
        let text_validPhoneNumberEmail  = "Please enter a valid phone number, email"
        let text_validVenue             = "Please enter a valid venue"
        let text_validPhoneNumber       = "Please enter a valid phone number"
        let text_validEmail             = "Please enter a valid email"
        let text_validZipCode           = "Please enter a valid Zip Code"
        let text_validPhoneNumberDigit  = "Please enter a valid phone number"
        let text_UserNameEmail          = "User Name and Email should not be same"
        
        let text_Event_Title        = "Success"
        
        let text_LoggedWithFacebook = "Logged in with Facebook"
    }
    
    struct WUTextField {
        
        let text_EmailError          = "EMAIL ERROR"
        let text_PasswordError       = "PASSWORD ERROR"
        let text_MobileError         = "MOBILE ERROR"
        let text_EmailOrMobileError  = "EMAIL or MOBILE ERROR"

        let text_EmailOrMobile       = "EMAIL or MOBILE"
        let text_Email               = "EMAIL"
        let text_MobileNumber         = "MOBILE NUMBER"
        let text_Password            = "PASSWORD"
        let text_ConfirmPassword     = "CONFIRM PASSWORD"
        let text_CreatePassword      = "CREATE PASSWORD"
        
        let text_CAB_EmailAddress    = "EMAIL ADDRESS"
        let text_CAB_MobileNumber    = "MOBILE NUMBER"
        let text_CAB_Search         = "FIND YOUR BUSINESS"
        
        //Calim A Business  :: ::
        let text_CAB_OwnerName      = "Business Owner Name"
        let text_CAB_BusinessType   = "Business Type"
        let text_CAB_BusinessName   = "Business Name"
        let text_CAB_AddressLine1   = "Business Address Line 1"
        let text_CAB_AddressLine2   = "Business Adresss Line 2"
        let text_CAB_City           = "City"
        let text_CAB_State          = "State"
        let text_CAB_ZipCode        = "Zip Code"
        let text_CAB_PhoneNumber    = "Phone Number"
        let text_CAB_Email          = "Business email Address"
        let text_CAB_Website        = "Business Website"
        
    }
    
    struct WUSegue {
        
        let welcomeToLogin                      = "welcomeToLoginSegue"
        let welComeToSignUp                     = "welComeToSignUpSegue"
        let welcomeToHome                       = "welcomeToHomeSegue"
        let loginToHome                         = "loginToHomeSegue"
        let loginToForgotPasssword              = "loginToForgotPasswordSegue"
        let forgotPasswordToSent                = "forgotPasswordToSentSegue"
        let signUpToHome                        = "signUpToHomeSegue"
        let signUpToSignUpConfirm               = "signUpToSignUpConfirmSegue"
        let signUpConfirmToInterest             = "signUpConfirmToInterestSegue"
        let interestToComplete                  = "interestToCompleteSegue"
        let interestVCToHomeVC                  = "interestVCToHomeVCSegue"
        let confirmVCToHomeVC                   = "confirmVCToHomeVCSegue"
        
        
        let homeSearchToRecentSearch            = "homeSearchToRecentSearchSegue"
        let homeSearchToSearchResult            = "homeSearchToSearchResultSegue"
        let homeSearchToFilterSearch            = "homeSearchToFilterSearchSegue"
        let homeSearchToFoodCategory            = "homeSearchToFoodCategorySegue"
        let homeViewAll                         = "homeViewAllSegue"
        let homeViewControllerToSearchResult    = "homeViewControllerToSearchResultSegue"
        let homeToVenueDetail                   = "homeToVenueDetailSegue"
        let homeVCToClaimBusiness               = "homeVCToClaimBusinessSegue"
        let homeSearchToClaimBusiness           = "homeSearchToClaimBusinessSegue"

        let ClaimBusinessVCToAcceptVC           = "ClaimBusinessVCToAcceptVCSegue"
        
        let venueProfileListToVenueShare        = "venueProfileListToVenueShareSegue"
        let venueProfileListToVenueMap          = "venueProfileListToVenueMapSegue"
        let venueProfileListToVenuePhotos       = "venueProfileListToVenuePhotosSegue"
        let venuePhotosToVenueIndividualPhoto   = "venuePhotosToVenueIndividualPhotoSegue"
        
        let evenExpandVC                        = "eventExpandVCSegue"
        let eventListVC                         = "eventListVCSegue"
        let eventCategoryVC                     = "eventCategoryVCSegue"
        let eventHomeToSelectedCategory         = "eventHomeToSelectedCategorySegue"
        let eventHomeToEventDetail              = "eventHomeToEventDetailSegue"
        
        let eventToEventSearchVC                 = "eventToEventSearchVCSegue"
        let eventSearchToRecentSearch            = "eventSearchToRecentSearchSegue"
        let eventSearchToSearchResult            = "eventSearchToSearchResultSegue"
        let eventSearchToFilterSearch            = "eventSearchToFilterSearchSegue"
        let eventSearchResultToEventDetail       = "eventSearchResultToEventDetailSegue"
        
        
        let eventProfileVCToEventSearchVC       = "eventProfileVCToEventSearchVCSegue"
        let eventSerachVCToEventSerachResultVC  = "eventSerachVCToEventSerachResultVCSegue"
        let eventSearchVCToEventSearchFilterVC  = "eventSearchVCToEventSearchFilterVCSegue"
        let eventSearchVCToDetailVC             = "eventSearchVCToDetailVCSegue"
        let homeToplayLivecamVC                 = "homeToplayLivecamVCSegue"
        let searchResultVCToPlayLivecamVC       = "searchResultVCToPlayLivecamVCSegue"
        
        let favoriteDateRangeVC                 = "favoriteDateRangeVCSegue"
        let favoriteOptInVC                     = "favoriteOptInVCSegue"
        let favoriteListVC                      = "favoriteListVCSegue"
        let favoriteHomeVCToEditNotificationVC  = "favoriteHomeVCToEditNotificationVCSegue"
        
        let continueToProfileVC                 = "continueToProfileVCSegue"
        let profileToThankyouVC                 = "profileToThankyouSegue"

        let LiveCamExpandVC                     = "liveCamExpandVCSegue"
        let LiveCamGridVC                       = "liveCamGridVCSegue"
        let LiveCamListVC                       = "liveCamListVCSegue"
        let LiveCamHomeToLiveCamProfileVC       = "liveCamHomeToLiveCamProfileVCegue"
        let LiveCamHomeToLiveCamSearchVC        = "liveCamHomeToLiveCamSearchVCegue"
        let LiveCamSearchToRecentSearch         = "liveCamSearchToRecentSearchSegue"
        let LiveCamSearchToSearchResult         = "liveCamSearchToSearchResultSegue"
        let LiveCamSearchToFilterSearch         = "liveCamSearchToFilterSearchSegue"
        let LiveCamProfileVCToLiveCamSearchVC   = "LiveCamProfileVCToLiveCamSearchVCSegue"
        
    }
    
    struct WUUserDefaultKey {
        let User                                = "user"
        let isLaunchedOnce                      = "isLaunchedOnce"
        let isCreateProfileViewed               = "isCreateProfileViewed"
        let isThankyouProfileViewed             = "isThankyouProfileViewed"
        let isProfileViewedFirst                = "isProfileViewedFirst"
        let isFromSignUp                        =  "isFromSignUp"
        let saveCurrentDate                     = "saveCurrentDate"
        let HomeBanner                          = "HomeBanner"
        let VenueLocalPromotions                = "VenueLocalPromotions"
        let LocalPromotions                = "LocalPromotions"
    }
    
    struct WUSearchFilterNames {
        let nearby            = "Nearby"
        let openNow           = "Open Now"
        let LiveMusic         = "Live Music"
        let FoodCategory      = "Food Category"
        let radiusValueOptions = ["1" , "2", "3", "4", "6", "8", "12", "16", "18", "20", "25", "30", "40", "50", "60", "70", "80", "+90"]

    }
    
    //Localize all these texts of Message for support multilanguage
    struct WUMessage {
        let noInternetConnection                 = "We are not receiving you! Check your connection and try again." //"Internet connection is not available."
        let someError                   = "Something went wrong! We are having difficultes please try again soon."
        let noInternet                  = "Sorry!  We weren't able to complete your request.  Please try again shortly."//"Internet connection is not available."
        let noDataFound                 = "No Result Found."
        let noResultsFound              = "Use the search and filter tools above to find just what you are looking for"
        let applicationShareMsg         = "Success! Thanks for sharing Arvzapp"//"Application has been shared sucessfully."
        let venueShareMsg               = "Thanks for sharing"//"Venue has been shared sucessfully."
        let eventShareMsg               = "Event has been shared sucessfully."
        let venueLocationNotFound       = "We do not have information about Venue Location."
        let eventLocationNotFound       = "We do not have information about Event Location."
        let logOut                      = "Are you sure you want to logout?"
        let logOutWithProfileEdit       = "Before you logout, Do you want to save your profile changes?"
        let SelectAtleastOneCategory    = "Please select atleast one Interest."
        let allowLocation               = "allow location"
        let pleaseEnterEmail            = "Please provide Email."
        let pleaseEnterEmailORMobile    = "Please provide Email Or Mobile Number."
        let pleaseEnterValidEmail       = "Please enter a valid email address."
        let profileUpdatedSuccessfully  = "Profile updated successfully."
        let deleteRowMsg                = "Are you sure you wish to delete?"
        let imageUploadError            = "Failed to update profile."
        let claimBussiness              = "Coming Soon."
        let photoPermissionMsg          = "Your photo library permisssion disabled.please allow us to use your photos"
        let cameraPermissionMsg          = "Your camera permisssion disabled.please allow us to use your camera"
        let notficationUpdatedSuccessfully  = "Notification Preferences updated"//Notification Presence updated"//"Notification updated successfully."
        
        let passwordNotMatchErrorMessage  = "The passwords you entered didn't match. Please check your entry and try again!"
        let incorrectEmailFormatErrorMessage  = "The email you entered is an incorrect email format. Please check your entry and try again!"
        let incorrectPhoneNumberFormatErrorMessage  = "The phone number you entered is an incorrect format. Please check your entry and try again!"

        //Calim A Business  :: ::
        let msg_CAB_OwnerName      = "Business Owner Name"
        let msg_CAB_BusinessType   = "Business Type"
        let msg_CAB_BusinessName   = "Business Name"
        let msg_CAB_AddressLine1   = "Please include a valid address"
        let msg_CAB_City           = "Please include a valid city"
        let msg_CAB_StateZip          = "Please include a valid state and zip"
        let msg_CAB_PhoneNumber    = "Please include a valid phone number"
        let msg_CAB_Email          = "Please include a valid email"
        
        let msg_ForVersionUpdate = "New version available"
        let msg_CAB_SucessFully  = "You have successfully claimed your business!"
        
        let msg_Call_NotFound = "Sorry! This venue hasn't added a phone number."
        let msg_Call = "Device does not support phone calls."
        let msg_Calender_Event_Delete = "Event deleted successfully"
        let msg_Calender_Event_Saved = "Event saved successfully"
        
        let msg_User_Unauthorized = "Unauthorized"
        let msg_Deeplinking_Share = "Check out what I just found in ArvzApp!"
        let msg_Deeplinking_Share_App = "\nCheck out this awesome app called ArvzApp."
        let msg_CAB_TitleLine =  "This is not a Sponsored Venue!"
        let msg_CAb_BodyLine = "Sponsored Venues, as indicated by the yellow background, have full profiles."
    }
    
    struct WUDictKey {
        let email                         = "email"
        let mobile                        = "mobile"
        let password                      = "password"
        let confirmpassword               = "confirmpassword"
        
        let profileUsername               = "profileUsername"
        let profileUserImageUrl           = "profileUserImageUrl"
        let profileEmail                  = "profileEmail"
        let profileMobile                 = "profileMobile"
        let profileBirthday               = "profileBirthday"
        let profileCity                   = "profileCity"
        let profileCategory               = "profileCategory"
        let profileFavNotification        = "profileFavNotification"
        
        
        //Calim A Business  :: ::
        let ownerName      = "ownerName"
        let businessType   = "businessType"
        let businessName   = "businessName"
        let addressLine1   = "addressLine1"
        let addressLine2   = "addressLine2"
        let city           = "city"
        let state          = "state"
        let zipCode        = "zipCode"
        let phoneNumber    = "phoneNumber"
        let businessEmail  = "businessEmail"
        let website        = "website"
        
        let mobileNumber        = "mobileNumber"
        let emailAddress        = "emailAddress"
        let venueName           = "venueName"
        let venueFourSquareID   = "venueFourSquareID"
        let calenderEvent       = "CalenderEvent"
        
    }
    
    struct WUFirebaseEventName {
        
        let signup_email_ios                    = "signup_email_ios"
        let signup_fb_ios                       = "signup_fb_ios"
        let login_ios                           = "login_ios"
        let forgot_pass_ios                     = "forgot_pass_ios"
        let login_complete_ios                  = "login_complete_ios"
        
        let InterestCategoryTap                 = "onboard_"
        let onboard_skip_ios                    = "onboard_skip_ios"
        let onboard_complete_ios                = "onboard_complete_ios"
        
        let ad_herovid_GUID_ios                 = "ad_herovid_"
        let ad_herobanner_GUID_ios              = "ad_herobanner_"
        let claimbiz_start_ios                  = "claimbiz_start_ios"
        let shareapp_ios                        = "shareapp_ios"
        
        let viewall_topspots_ios                = "viewall_topspots_ios"
        let viewall_localpromo_ios              = "viewall_localpromo_ios"
        let viewall_livecam_ios                 = "viewall_livecam_ios"
        let viewall_restaurant_ios              = "viewall_restaurant_ios"
        let viewall_barpub_ios                  = "viewall_barpub_ios"
        let viewall_shop_ios                    = "viewall_shop_ios"
        let viewall_entertain_ios               = "viewall_entertain_ios"
        let viewall_arts_ios                    = "viewall_arts_ios"
        let viewall_outdoor_ios                 = "viewall_outdoor_ios"
        let viewall_cafes_ios                   = "viewall_cafes_ios"
        let claimbiz_complete_ios               = "claimbiz_complete_ios"
        let map_open_ios                        = "map_open_ios"

        let view_venue_GUID_ios                 = "view_venue_"
        let play_venue_GUID_livecam_GUID_ios    = "play_venue_"
        let play_livecam_GUID_ios               = "play_livecam_"
        let view_event_GUID_ios                 = "view_event_"
        let view_event_GUID_livecam_GUID_ios    = "view_event_"
        let event_add_calendar_ios              = "event_add_calendar_ios"
    }
    
    struct WUTextView {
        let text_termsOfUse = "ARVZAPP MOBILE APP TERMS OF USE\nLast Updated: July 1, 2019\nWelcome to ArvzApp (the “App”). The App is operated by WussUp, LLC (“WussUp” or “we” or “us”). These Terms of Use (“Terms” or “Agreement”) are an agreement between you and WussUp.\nBy using the App or using any services provided by WussUp through the App (the “Services”), you agree to read, comply with, and be legally bound by: (a) these Terms; (b) WussUp’s Privacy Policy (available at https://arvzapp.com/Document/ArvzAppPrivacyPolicy.pdf); and (c) any additional rules and regulations for using the App or any Services (the “Rules”) made available or published by WussUp from time-to-time. If you do not read and agree to the Terms and Rules, you may not use the App or any Services.\nTHESE TERMS REQUIRE THE USE OF ARBITRATION ON AN INDIVIDUAL BASIS TO RESOLVE DISPUTES, RATHER THAN COURT OR JURY TRIALS OR CLASS ACTIONS, AND ALSO LIMIT THE REMEDIES AVAILABLE TO YOU IN THE EVENT OF A DISPUTE. CAREFULLY REVIEW SECTION XIV BEFORE YOU AGREE TO THESE TERMS.\nTHE APP IS ONLY INTENDED FOR USE WHILE YOU ARE STATIONARY AND IN A SAFE POSITION TO USE YOUR DEVICE.\nACCEPTANCE OF TERMS\nWussUp is pleased to provide you the information and features of the App and Services upon your acceptance, without modification by you, of the terms, conditions and notices comprising these Terms. These Terms may be updated and modified by us from time-to-time, without notice to you, by making revised Terms available through the App or on our website (https://arvzapp.com/). You can review the most current version of these Terms at any time by clicking on the “Terms and Conditions” link in the App or on our website. We hope that you will find the information and features provided in the App and the Services informative and useful. Please feel free to email us at info@arvzapp.com with your thoughts about the Apps or Services, or to request more information about WussUp, our App or the Services.\nACCEPTABLE USE\nIn addition to the other requirements stated in these Terms and the Rules, your use of the App and Services is conditioned upon your compliance with the following rules (“Acceptable Use Restrictions”):\nYou shall not upload to, transmit through, or display via the App or Services any content that:\nis unlawful, fraudulent, threatening, abusive, libelous, defamatory, obscene or otherwise objectionable, or infringes our or any third party’s intellectual property or other rights;\ncontains confidential, proprietary or trade secret information of any third party;\nviolates the rights of others, including, but not limited to, any privacy rights or rights of publicity;\nimpersonates any person or entity, falsely states or otherwise misrepresents your affiliation with any person or entity or uses any fraudulent, misleading or inaccurate email address or other contact information;\nviolates any applicable laws or regulations;\nmakes any statement, express or implied, that you are endorsed by WussUp;\nharms minors in any way, including, but not limited to, by depicting content that violates child pornography laws, child sexual exploitation laws and laws prohibiting the depiction of minors engaged in sexual conduct;\ncontains any unsolicited promotions, political campaigning, advertising or solicitations;\nin our sole judgment is inappropriate or objectionable or which restricts or inhibits any other person from using or enjoying the App or Services or which may expose WussUp, any of its officers, directors or employees or other users to any harm or liability of any type;\ndepicts pornography or sexual acts;\npromotes or depicts violence or graphic imagery; or \n encourages, promotes or depicts self-harm or suicide.\nYou shall not use the App or any Services to engage in any of the following activities:\naccessing, using or uploading content to, or attempting to access, use or upload content to another user’s account without permission;\ntransmitting, uploading or downloading any software or other materials that contain any viruses, worms, trojan horses, defects, date bombs, time bombs or other items of a destructive nature;\ninciting or engaging in harassment of others;\nthreatening or encouraging any form of physical violence;\ndisclosing anyone’s private information without their consent;\nspamming anyone, including, but not limited to, other App users; or\ncircumventing any restrictions or controls we have put in place, including attempting to circumvent suspension of your account or access to the App or Services.\nAdditionally, you shall not:\ntry to obtain unauthorized access to any account associated with the App or Services;\ntry to open an account if you are under the age of 21;\nprovide false or misleading information at any time when opening or using an account;\ntry to use the App or Services in a commercial manner, rather than for personal and non-commercial recreation;\nuse the App or any Service in a manner inconsistent with these Terms, the Rules or applicable law;\nmodify or interfere with the App, any Service or other software or WussUp Content – including location, access and other security features – for any reason, or permit or help anyone else to do so; or\ninterfere with or alter the App, any Service or other software or WussUp Content.\nOWNERSHIP OF THE APP AND CONTENT\nAll right, title and interest in and to the App and Services including, but not limited to, all of the software and code that comprise and operate the App and Services, and all of the text, photographs, illustrations, images, graphics, audio, video, URLs, advertising copy and other materials provided through the App and Services (collectively, “Content”) are owned by us or by third parties who have licensed their Content to us. The App and Services are protected under trademark, service mark, trade dress, copyright, patent, trade secret and other intellectual property laws. In addition, the entire Content of the App and Services is a collective work under U.S. and international copyright laws and treaties, and we own the copyright in the selection, coordination, arrangement and enhancement of the Content of the App and Services.\nYour license to use the App or Services does not include the right to use any data mining, robots or other automatic or manual device, software, program, code, algorithm or methodology to access, copy or monitor any portion of the App, Services or any Content, or in any way reproduce or circumvent the navigational structure or presentation of the App, any Service or Content, or obtain, or attempt to obtain, any materials or information through any means not purposely made available by us through the App and Services. We reserve the right to take measures to prevent any such activity. You may not, nor may you permit others to, copy, distribute, perform or display publicly, prepare derivative works based on, broadcast, exploit or use any part of the Content on the App and Services except as expressly provided in these Terms. Nothing in these Terms shall be construed as transferring any right, title or interest in the App or Services, or their Content, to you or anyone else, except the limited license to use the App and Services, and their Content, on the terms expressly set forth herein.\nNotwithstanding the foregoing, and specifically with regard to trademarks, the WussUp names and logos (including, but not limited to, those of its affiliates), all product and service names, all graphics, all button icons, and all trademarks, service marks and logos appearing within the App and Services, unless otherwise noted, are trademarks (whether registered or not), service marks and/or trade dress of WussUp and/or its affiliates (the “WussUp Marks”). All other trademarks, product names, company names, logos, service marks and/or trade dress mentioned, displayed, cited or otherwise indicated within the App or Services are the property of their respective owners. You are not authorized to display or use the WussUp Marks in any manner without our prior written permission. You are not authorized to display or use trademarks, product names, company logos, service marks and/or trade dress of other owners featured within the App and Services without the prior written permission of such owners. The use or misuse of the WussUp marks or other trademarks, product names, company names, logos, service marks and/or trade dress or any other materials contained herein, except as permitted herein, is expressly prohibited.\nUSER CONTENT\nThe App may provide you with the ability to add, create, upload, submit, distribute, post or share content on or through the App, including, but not limited to, website links, opinions, photos, profiles, videos and audio clips (collectively, “User Content”). For example, WussUp may allow user photos to be uploaded to our social media feed by associating certain tags to their social media posts.\nBy posting or streaming any User Content on the App, you expressly grant, and represent and warrant that you have the right to grant, to WussUp a non-exclusive, irrevocable, worldwide, transferable, royalty-free, perpetual license to publicly display, publicly perform, reproduce, distribute, create derivative works of, and sublicense your User Content in any manner or through any media now known or later developed without any payment or obligation to you.\nWussUp has the right, but not the duty, to pre-screen, edit, refuse, move or remove any User Content posted to the App.\nACCOUNTS\nYou may be required to open an account or register with WussUp in order to access or use some of the features on the App and certain Services. By registering with us or opening any account associated with the App or Services, you are certifying to us that: (a) you are at least 21 years of age; (b) you are legally able to enter into contracts; and (c) you are not a person barred from receiving or using the App or any Services under federal, state, local or other laws.\nIf you become a registered user or open any account associated with the App or Services, you must provide true, accurate, current and complete information about you as may be prompted by any registration form. If any information you previously provided WussUp changes, you must promptly update the relevant information.\nYou acknowledge and agree that WussUp has the right, but not the duty, to close, suspend, investigate, monitor or limit your access to your account or any other account associated with the App or Services, or otherwise deny you access to the App and Services, in our sole discretion, without prior notice to you and without liability to you\nPASSWORD PROTECTED AREAS OF OUR APP\nFor your protection, certain areas of the App and access to certain Services may be password protected. You are responsible for maintaining the confidentiality of your passwords. We have the right to assume that anyone accessing the App or Services using a valid password associated with your account has the right to do so. You will be solely responsible for the activities of any accessing the App or Services using a valid password associated with your account, even if the individual is not, in fact, authorized by you. If you have reason to believe that your password has been compromised or used without authorization, you must promptly change it using the functionality provided on the App or Services.\nADDITIONAL INFORMATION SHARING\nWussUp may provide you with the option to share your experiences with others through your account and the App. If you open an account, you understand that WussUp will collect and maintain information related to your use of the App and Services. WussUp captures, though may not always display, that information to your account in order to provide the Services to you through the App. To the extent we allow user generated content to be published or streamed through the App, we also collect and publish the User Content, such as your personal photographs, videos and audio recordings, that you submit in connection with your account.\nTHIRD PARTY WEBSITES AND ADVERTISING\nThe App and Services may contain links to third party sites that are not owned or controlled by WussUp. WussUp has no control over, and assumes no responsibility for, the content, privacy policies or practices of any third party websites and you expressly agree that WussUp does not need to give you notice that you are leaving the App or Services. In addition, WussUp will not, and cannot, censor or edit the content of any third party website. By using the App or Services you expressly relieve WussUp from any and all liability arising from your use of any third party website. We encourage you to be aware when you leave the App or Services and to read the terms and conditions of each other website you visit.\nThe App allows you, or could in the future allow you, to share content through various platforms, website and mobile applications, including, but not limited to, Facebook, Instagram and Twitter. You understand that WussUp does not control what information gets published to those sites or who has access to that information. Those sites are managed by third parties and governed by the terms of use and privacy policies published on those sites.\nAdvertising may be presented to you when you use the App or any Services. You consent to receiving such advertisements. You also acknowledge and agree that WussUp is not responsible for any products or services provided by advertisers outside of WussUp, its subsidiaries or its affiliated companies.\nAGREEMENT TO FOLLOW APPLICABLE LAWS\nYou certify that you will comply with all applicable laws (e.g., local, state, federal and other laws) when using the App or any Services or any WussUp Content as permitted by, and in accordance with, these Terms. You will be responsible for any cost, expense, fee or liability of any kind (including, but not limited to, attorney’s fees) that WussUp incurs if you break the law, violate the Rules, breach these terms or misuse the App, Services or information WussUp provides. And, if you break the law, violate the Rules, breach these terms or misuse the App, Services or information WussUp provides, you acknowledge and agree that you will reimburse, indemnify and hold harmless WussUp, its subsidiaries and its affiliated companies and the employees, directors, officers and agents of all aforementioned companies from any money damages, costs, expenses, liabilities and attorney’s fees resulting from any claim, threat, demand, suit or investigation brought by another person, entity or government. Without waiving any of these rights, WussUp may, but has not obligation to, at its sole discretion, defend itself against any such claim, threat, demand, suit or investigation without your consent, provided that the foregoing will not relieve you of your indemnification obligations under these Terms. All of your obligations in this paragraph survive and continue after any termination of these Terms.\nADDITIONAL PRIVACY TERMS\nWussUp may collect, use, and disclose your location, personal, and non-personal information. Please visit https://arvzapp.com/Document/ArvzAppPrivacyPolicy.pdf to see WussUp’s complete Privacy Policy. That Privacy Policy may be updated from time to time, so please review it regularly. By opening and maintaining an account associated with the App or Services, you are consenting to the collection, use, disclosure, transfer, and sharing of your location, nonpublic personal, and non-personal information by WussUp, its subsidiaries and its affiliated companies, including, but not limited to, sharing such information with companies other than WussUp, its subsidiaries, and its affiliated companies. If you do not accept the terms of WussUp’s Privacy Policy, or the specific Privacy Policy associated with a Service, please close your account and discontinue all use of the App and Services.\nData and other information about your location, wireless device, computer system, and application software is gathered periodically to provide software updates, product support, and other services to you related to the App and Services. You agree that WussUp, its subsidiaries, and its affiliated companies may collect, use and disclose this data and other information about you to improve the App, the Services and other products and/or to provide Services or technologies to you. Although WussUp takes reasonable steps to safeguard your information, you have no expectation of privacy once you have logged into your account.\nYou authorize WussUp, its subsidiaries, its affiliated companies, third party vendors (such as wireless carriers, technology developers, service providers, advertisers, and merchant banks for credit card and debit card transactions) to collect, use and disclose location information, non-personal information and nonpublic personal information (including, for example, your name, postal and email addresses, telephone number, account number, device number and, for processing payment-card transactions, your payment-card number and related information).\nWussUp collects and stores location-identification information. By entering into these Terms, you acknowledge and agree that the location of your wireless device is information made available to and used by WussUp and its vendors, and that you have no expectation of privacy concerning your location when using the App or the Services. Your location is verified when you log into your account using the App or any Services and when you use the App or Services.\nAGE RESTRICTION\nAll people under 21 years of age are prohibited from using the App and any Services. We do not market or advertise to persons under the age of 21 If you are younger than 21 years of age, you are prohibited from access or using the App and any Services, opening any account, and/or submitting information to the App or us.\nWussUp does not purposely store personal information for persons under 13 years of age. If WussUp learns that the App or any Services have collected such information, WussUp will take appropriate steps to delete it. If you are a parent or legal guardian of any person under the age of 13 and discover that your child has submitted information to the App or us, or obtained an account, you may contact us at info@arvzapp.com, and ask us to close the account and remove any personal information about your child from our systems.\nUSER COMMENTS AND FEEDBACK\nWussUp will terminate your access to the App and Services if, under appropriate circumstances, you are determined to be a repeat infringer. WussUp has the right, but not the duty, in its sole and exclusive discretion, to decide whether a comment or any other submission is inappropriate or otherwise violates these Terms, other than copyright infringement, such as, but not limited to, obscene, defamatory or just plain obnoxious material. WussUp has the right, but not the duty, to remove such comments or submissions, terminate your access to the App or Services, or terminate your ability to upload any User Content at any time, without prior notice and at its sole discretion.\nDIGITAL MILLENNIUM COPYRIGHT ACT\nIf you are a copyright owner or an agent thereof and believe that any user submission or other content on the App or Services infringes upon your copyrights, you may submit a notification pursuant to the Digital Millennium Copyright Act (“DMCA”) by providing WussUp with the following information in writing (see 17 U.S.C 512(c)(3) for further detail):\nA physical or electronic signature of a person authorized to act on behalf of the owner of an exclusive right that is allegedly infringed;\nIdentification of the copyrighted work claimed to have been infringed, or, if multiple copyrighted works at a single online site are covered by a single notification, a representative list of such works at that site;\nIdentification of the material that is claimed to be infringing or to be the subject of infringing activity and that is to be removed or access to which is to be disabled and information reasonably sufficient to permit WussUp to locate the material;\nInformation reasonably sufficient to permit WussUp to contact you, such as an address, telephone number, and, if available, an electronic mail address;\nA statement that you have a good faith belief that use of the material in the manner complained of is not authorized by the copyright owner, its agent, or the law; and\nA statement that the information in the notification is accurate, and under penalty of perjury, that you are authorized to act on behalf of the owner of an exclusive right that is allegedly infringed.\nDMCA claims may be sent to the following address:\nWussUp, LLC\n620 Kresge Lane\nSparks, NV 89431\nOr, please email us at info@arvzapp.com.\nNote: You acknowledge that if you fail to comply with all of the requirements of this Section XIII your DMCA notice may not be valid.\nDISPUTE RESOLUTION\nPLEASE READ THIS CAREFULLY. IT AFFECTS YOUR RIGHTS.\nYOU AGREE THAT BY USING THE APP OR SERVICES YOU ARE WAIVING THE RIGHT TO A COURT OR JURY TRIAL OR TO PARTICIPATE IN A CLASS ACTION. YOU AGREE THAT YOU MAY BRING CLAIMS AGAINST WUSSUP ONLY IN YOUR INDIVIDUAL CAPACITY AND NOT AS A PLAINTIFF OR CLASS MEMBER IN ANY PURPORTED CLASS, REPRESENTATIVE, OR COLLECTIVE PROCEEDING. ANY ARBITRATION WILL TAKE PLACE ON AN INDIVIDUAL BASIS; CLASS ARBITRATIONS AND CLASS ACTIONS ARE NOT PERMITTED.\nYOU AGREE THAT ANY AND ALL CLAIMS AND DISPUTES ARISING FROM OR RELATING IN ANY WAY TO THE SUBJECT MATTER OF THESE TERMS, YOUR USE OF THE APP OR SERVICES, OR YOUR DEALINGS WITH WUSSUP SHALL BE FINALLY SETTLED AND RESOLVED THROUGH BINDING INDIVIDUAL ARBITRATION AS DESCRIBED IN THIS SECTION. THIS AGREEMENT TO ARBITRATE IS INTENDED TO BE INTERPRETED BROADLY PURSUANT TO THE FEDERAL ARBITRATION ACT AND THE UNIFORM ARBITRATION ACT AS ADOPTED BY THE STATE OF NEVADA (CHAPTER 38, NEVADA REVISED STATUTES). THE ARBITRATION WILL BE GOVERNED BY THE COMMERCIAL ARBITRATION RULES AND THE SUPPLEMENTARY PROCEDURES FOR CONSUMER RELATED DISPUTES OF THE AMERICAN ARBITRATION ASSOCIATION (“AAA”), AS MODIFIED BY THIS SECTION. THE ARBITRATION WILL BE CONDUCTED USING ONE ARBITRATOR WITH SUBSTANTIAL EXPERIENCE IN RESOLVING COMMERCIAL CONTRACT DISPUTES, WHO SHALL BE SELECTED FROM THE APPROPRIATE LIST OF ARBITRATORS IN ACCORDANCE WITH THE ARBITRATION RULES AND PROCEDURES OF ANY ARBITRATION ORGANIZATION OR ARBITRATOR THAT YOU AND WUSSUP AGREE UPON IN WRITING OR THAT IS APPOINTED PURSUANT TO SECTION 5 OF THE FEDERAL ARBITRATION ACT OR THE UNIFORM ARBITRATION ACT AS ADOPTED BY THE STATE OF NEVADA (CHAPTER 38, NEVADA REVISED STATUTES). FOR ANY CLAIM WHERE THE TOTAL AMOUNT OF THE AWARD SOUGHT IS $10,000 OR LESS YOU MUST ABIDE BY THE FOLLOWING RULES: (A) THE ARBITRATION SHALL BE CONDUCTED SOLELY BASED ON TELEPHONE OR ONLINE APPEARANCES AND WRITTEN SUBMISSIONS; AND (B) THE ARBITRATION SHALL NOT INVOLVE ANY PERSONAL APPEARANCE BY THE PARTIES OR WITNESSES UNLESS OTHERWISE MUTUALLY AGREED BY THE PARTIES. IF THE CLAIM EXCEEDS $10,000, THE RIGHT TO A HEARING WILL BE DETERMINED BY THE AAA RULES, AND THE HEARING (IF ANY) MUST TAKE PLACE IN THE CITY OF RENO, WASHOE COUNTY, NEVADA. THE ARBITRATOR’S RULING IS BINDING AND MAY BE ENTERED AS A JUDGMENT IN ANY COURT OF COMPETENT JURISDICTION, OR APPLICATION MAY BE MADE TO SUCH COURT FOR JUDICIAL ACCEPTANCE OF ANY AWARD AND AN ORDER OF ENFORCEMENT, AS THE CASE MAY BE.\nTHE FEDERAL RULES OF EVIDENCE AND FEDERAL RULES OF CIVIL PROCEDURE SHALL APPLY TO ANY SUCH ARBITRATION PROCEEDING INITIATED PURSUANT TO THIS SECTION, INCLUDING THE ABILITY TO CONDUCT THIRD PARTY DISCOVERY OUTSIDE OF THE STATE OF NEVADA AND TO PRESERVE SUCH THIRD PARTY DISCOVERY VIA DEPOSITION.  THE ARBITRATOR SHALL HAVE THE AUTHORITY TO ISSUE SUBPOENAS AND SUBPOENAS DUCES TECUM PURSUANT TO THE FEDERAL RULES OF CIVIL PROCEDURE (EVEN TO WITNESSES OUTSIDE OF THE STATE OF NEVADA) AS IF THE ARBITRATOR WERE JUDGE OF THE UNITED STATES DISTRICT COURT, DISTRICT OF NEVADA.  DEPOSITION TRANSCRIPTS MAY BE USED IN THE ARBITRATION IN THE CITY OF RENO, COUNTY OF WASHOE, STATE OF NEVADA IN ACCORD WITH THE FEDERAL RULES OF EVIDENCE.  THE LIMITATIONS OF THE FEDERAL ARBITRATION ACT SHALL NOT PREVENT DISCOVERY TO PROCEED IN ACCORD WITH THE FEDERAL RULES OF EVIDENCE AND FEDERAL RULES OF CIVIL PROCEDURE.  ALL DISPUTES OVER SUBPOENAS ISSUED BY THE ARBITRATOR SHALL BE RESOLVED PURSUANT TO FEDERAL RULE OF CIVIL PROCEDURE 45.\nTHERE IS NO JUDGE OR JURY IN ARBITRATION. ARBITRATION PROCEDURES ARE SIMPLER AND MORE LIMITED THAN RULES APPLICABLE IN COURT AND REVIEW BY A COURT IS LIMITED. YOU WILL NOT BE ABLE TO HAVE A COURT OR JURY TRIAL OR PARTICIPATE IN A CLASS ACTION OR CLASS ARBITRATION. YOU UNDERSTAND AND AGREE THAT BY AGREEING TO RESOLVE ANY DISPUTE THROUGH INDIVIDUAL ARBITRATION, YOU ARE WAIVING THE RIGHT TO A COURT OR JURY TRIAL. ANY DISPUTE SHALL BE ARBITRATED ON AN INDIVIDUAL BASIS, AND NOT AS A CLASS ACTION, REPRESENTATIVE ACTION, CLASS ARBITRATION OR ANY SIMILAR PROCEEDING. THE ARBITRATOR MAY NOT CONSOLIDATE THE CLAIMS OF MULTIPLE PARTIES.\nANY CAUSE OF ACTION OR CLAIM YOU MAY HAVE ARISING OUT OF OR RELATING IN ANY WAY TO THESE TERMS, YOUR USE OF THE APP OR SERVICES, OR YOUR DEALINGS WITH WUSSUP MUST BE COMMENCED IN ARBITRATION WITHIN TWO (2) YEARS AFTER THE CAUSE OF ACTION ACCRUES. AFTER THAT TWO (2)-YEAR PERIOD, SUCH CAUSE OF ACTION OR CLAIM IS PERMANENTLY BARRED. SOME JURISDICTIONS DO NOT ALLOW TIME LIMITATIONS OTHER THAN THOSE SET FORTH IN SUCH STATE’S STATUTE OF LIMITATIONS LAWS. IN SUCH CASES, THE APPLICABLE STATUTE OF LIMITATIONS PROVIDED FOR UNDER THE LAWS OF SUCH STATE SHALL APPLY.\nYOU AGREE THAT ALL CHALLENGES TO THE VALIDITY AND APPLICABILITY OF THE ARBITRATION PROVISION—I.E. WHETHER A PARTICULAR CLAIM OR DISPUTE IS SUBJECT TO ARBITRATION—SHALL BE DETERMINED BY THE ARBITRATOR. NOTWITHSTANDING ANY PROVISION IN THESE TERMS TO THE CONTRARY, IF THE CLASS-ACTION WAIVER ABOVE IS DEEMED INVALID OR UNENFORCEABLE YOU AGREE THAT YOU SHALL NOT SEEK TO, AND WAIVE ANY RIGHT TO, ARBITRATE CLASS OR COLLECTIVE CLAIMS. IF THE ARBITRATION PROVISION IN THIS SECTION IS FOUND UNENFORCEABLE OR TO NOT APPLY FOR A GIVEN DISPUTE, THEN THE PROCEEDING MUST BE BROUGHT EXCLUSIVELY IN THE STATE COURTS OF COMPETENT JURISDICTION OR THE UNITED STATES DISTRICT COURT LOCATED IN WASHOE COUNTY, NEVADA, AS APPROPRIATE, AND YOU AGREE TO SUBMIT TO THE PERSONAL JURISDICTION OF EACH OF THESE COURTS FOR THE PURPOSE OF LITIGATING SUCH CLAIMS OR DISPUTES, AND YOU STILL WAIVE YOUR RIGHT TO A JURY TRIAL, WAIVE YOUR RIGHT TO INITIATE OR PROCEED IN A CLASS OR COLLECTIVE ACTION, AND REMAIN BOUND BY ANY AND ALL LIMITATIONS ON LIABILITY AND DAMAGES INCLUDED IN THESE TERMS. THIS ARBITRATION AGREEMENT WILL SURVIVE TERMINATION OF YOUR USE OF THE APP AND/OR SERVICES AND YOUR RELATIONSHIP WITH WUSSUP. THIS ARBITRATION AGREEMENT INVOLVES INTERSTATE COMMERCE AND, THEREFORE, SHALL BE GOVERNED BY THE FEDERAL ARBITRATION ACT, 9 U.S.C. §§ 1-16 (“FAA”), AND NOT BY STATE LAW. INFORMATION ON AAA AND HOW TO START ARBITRATION CAN BE FOUND AT WWW.ADR.ORG.\nIF YOU WISH TO OPT-OUT OF THE AGREEMENT TO ARBITRATE, WITHIN 45 DAYS OF WHEN YOU FIRST USE THE APP OR SERVICE, OR SUBMIT THROUGH THE APP SERVICE A REQUEST FOR INFORMATION, YOU MUST SEND US A LETTER STATING, “REQUEST TO OPT-OUT OF AGREEMENT TO ARBITRATE” AT THE FOLLOWING ADDRESS:\nWussUp, LLC\n620 Kresge Lane\nSparks, NV 89431\nIn the event you opt out of the arbitration provision, you agree to litigate exclusively in the state or Federal courts in Washoe County, Nevada, and you hereby consent and submit to the personal jurisdiction of such courts for the purpose of litigating any such action. These Terms will be governed by the laws of the State of Nevada, without giving effect to any principles of conflicts of laws.\nDISCLAIMER OF WARRANTIES\nWE MAKE NO REPRESENTATIONS OR WARRANTIES WITH RESPECT TO THE APP, SERVICES OR CONTENT, OR ANY PRODUCT OR SERVICE AVAILABLE ON OR PROMOTED THROUGH THE APP OR SERVICES. THE APP, SERVICES AND ALL OF THE INFORMATION, PRODUCTS AND SERVICES MADE AVAILABLE THROUGH THE APP AND SERVICES ARE PROVIDED ON AN “AS IS,” “AS AVAILABLE” BASIS, WITHOUT REPRESENTATIONS OR WARRANTIES OF ANY KIND. TO THE FULLEST EXTENT PERMITTED BY LAW, WE AND OUR AFFILIATES DISCLAIM ANY AND ALL REPRESENTATIONS AND WARRANTIES, WHETHER EXPRESS OR IMPLIED, WITH RESPECT TO THE APP, SERVICES AND THE INFORMATION, PRODUCTS AND SERVICES MADE AVAILABLE THROUGH THE APP AND SERVICES. WITHOUT LIMITING THE GENERALITY OF THE FOREGOING, WE AND OUR AFFILIATES DISCLAIM ALL REPRESENTATIONS AND WARRANTIES, EXPRESS OR IMPLIED, (A) OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE; (B) ARISING FROM COURSE OF DEALING OR COURSE OF PERFORMANCE; (C) RELATING TO THE SECURITY OF OUR APP OR SERVICES; (D) THAT THE CONTENT OF OUR APP OR SERVICES IS ACCURATE, COMPLETE, CURRENT OR RELIABLE; AND (E) THAT OUR APP OR SERVICES WILL OPERATE WITHOUT INTERRUPTION OR ERROR.\nWUSSUP DOES NOT ENDORSE AND IS NOT RESPONSIBLE FOR STATEMENTS, ADVICE AND OPINIONS MADE BY ANYONE OTHER THAN AUTHORIZED WUSSUP SPOKESPERSONS. WE DO NOT ENDORSE AND ARE NOT RESPONSIBLE FOR ANY STATEMENTS, ADVICE OR OPINIONS CONTAINED IN USER CONTRIBUTIONS OR PROVIDED BY ANY THIRD PARTIES, AND SUCH STATEMENTS, ADVICE AND OPINIONS DO NOT IN ANY WAY REFLECT THE STATEMENTS, ADVICE AND OPINIONS OF WUSSUP. WE DO NOT MAKE ANY REPRESENTATIONS OR WARRANTIES AGAINST THE POSSIBILITY OF DELETION, MISDELIVERY OR FAILURE TO STORE COMMUNICATIONS, PERSONALIZED SETTINGS, OR OTHER DATA.\nSOME JURISDICTIONS DO NOT ALLOW THE EXCLUSION OF CERTAIN WARRANTIES. ACCORDINGLY, SOME OF THE ABOVE DISCLAIMERS OF WARRANTIES MAY NOT APPLY TO YOU.\nLIMITATION OF LIABILITY\nTO THE FULLEST EXTENT PERMITTED BY APPLICABLE LAW, AND WITHOUT LIMITING ANYTHING ELSE IN THESE TERMS OR THE RULES, OUR ENTIRE LIABILITY AND EXCLUSIVE REMEDY WITH RESPECT TO THE USE OF THE APP OR SERVICES WILL BE THE AMOUNT OF $200.\nIN NO EVENT WILL WE BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, PUNITIVE OR CONSEQUENTIAL DAMAGES ARISING FROM YOUR USE OF THE APP OR SERVICES OR FOR ANY OTHER CLAIM RELATED IN ANY WAY TO YOUR USE OF THE APP OR SERVICES. BECAUSE SOME STATES OR JURISDICTIONS DO NOT ALLOW THE EXCLUSION OR LIMITATION OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, IN SUCH STATES OR JURISDICTIONS OUR LIABILITY WILL BE LIMITED TO THE EXTENT PERMITTED BY APPLICABLE LAW.\nTHE FOREGOING LIMITATIONS WILL APPLY WHETHER SUCH DAMAGES ARISE OUT OF BREACH OF CONTRACT, TORT (INCLUDING NEGLIGENCE) OR OTHERWISE AND REGARDLESS OF WHETHER SUCH DAMAGES WERE FORESEEABLE, OR WE WERE ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. SOME JURISDICTIONS DO NOT ALLOW CERTAIN LIMITATIONS OF LIABILITY SO SOME OR ALL OF THE ABOVE LIMITATIONS OF LIABILITY MAY NOT APPLY TO YOU.\nIF YOU ARE A CALIFORNIA RESIDENT, YOU HEREBY WAIVE CALIFORNIA CIVIL CODE SECTION 1542 IN CONNECTION WITH THE FOREGOING, WHICH STATES: “A GENERAL RELEASE DOES NOT EXTEND TO CLAIMS WHICH THE CREDITOR DOES NOT KNOW OR SUSPECT TO EXIST IN HIS OR HER FAVOR AT THE TIME OF EXECUTING THE RELEASE, WHICH IF KNOWN BY HIM OR HER MUST HAVE MATERIALLY AFFECTED HIS OR HER SETTLEMENT WITH THE DEBTOR.”.\nIF YOU ARE ACCESSING THE SERVICE FROM NEW JERSEY, YOU (A) ASSUME ALL RISKS OF LOSSES OR DAMAGES RESULTING FROM YOUR USE OF OR INABILITY TO USE THE APP OR ANY SERVICE; (B) IRREVOCABLY WAIVE ALL LOSSES OR INDIRECT, SPECIAL, CONSEQUENTIAL, PUNITIVE OR INCIDENTAL DAMAGES (INCLUDING, WITHOUT LIMITATION, THOSE RESULTING FROM LOST PROFITS, LOST DATA OR BUSINESS INTERRUPTION) THAT MAY OCCUR AS A RESULT OF YOUR USE OF THE APP OR ANY SERVICE; AND (C) EXPRESSLY AGREE TO RELEASE AND DISCHARGE WUSSUP AND ITS AFFILIATES, EMPLOYEES, AGENTS, REPRESENTATIVES, SUCCESSORS, OR ASSIGNS FROM ANY AND ALL CLAIMS OR CAUSES OF ACTION RESULTING, DIRECTLY OR INDIRECTLY, FROM YOUR USE OF THE APP OR ANY SERVICE; AND (D) YOU VOLUNTARILY GIVE UP OR WAIVE ANY RIGHT THAT YOU MAY OTHERWISE HAVE TO BRING A LEGAL ACTION AGAINST WUSSUP FOR LOSSES OR DAMAGES, WHETHER BASED ON WARRANTY, CONTRACT, TORT OR OTHER LEGAL THEORY, INCLUDING ANY CLAIM BASED ON ALLEGED NEGLIGENCE ON THE PART OF WUSSUP AND THEIR AGENTS AND EMPLOYEES. YOU ACKNOWLEDGE THAT YOU HAVE CAREFULLY READ THIS “WAIVER AND RELEASE” AND FULLY UNDERSTAND THAT IT IS A RELEASE OF LIABILITY.\nINDEMNIFICATION\nYou agree to defend, indemnify and hold harmless WussUp, its affiliates, licensors and service providers, and its and their respective officers, directors, employees, contractors, agents, licensors, suppliers, successors and assigns from and against any claims, liabilities, damages, judgments, awards, losses, costs, expenses or fees (including reasonable attorneys’ fees) arising out of or relating to your violation of these Terms or your use of the App or Services including, but not limited to, your contribution of any User Content, any use of the WussUp Content, services and products other than as expressly authorized in these Terms or your use of any information obtained from the App or Services. In such as case WussUp shall have the exclusive right to select and approve of counsel, whom you will pay pursuant to your obligation herein, to defend WussUp.\nNOTICE REGARDING MOBILE CARRIER FEES AND CHARGES\nUsing the App or Services may allow you to receive Content on your mobile phone or other wireless device. The manner in which that Content is delivered to your phone or device may cause you to incur extra data, text messaging or other charges from your wireless carrier. MESSAGE AND DATA RATES MAY APPLY. You, not WussUp, will be solely responsible for any carrier charges associated with your use of the App or Services. Please contact your carrier if you have questions about how the use of mobile applications and associated services might impact your wireless usage fees.\nTERMINATION\nWussUp may cancel, suspend or block your use of the App or Services without notice if there has been a violation of these Terms or the Rules. Your ability to use the certain portions of the App and certain Services will end once your account is terminated, and any data you have stored through the App or Services may be unavailable later, unless WussUp is required to retain it by law. You may terminate your account at any time. WussUp is not responsible or liable for any records or information that is made unavailable to you as the result of your termination of your account.\nYOU AGREE THAT WUSSUP WILL NOT BE LIABLE TO YOU OR ANY OTHER PARTY FOR ANY TERMINATION OF YOUR ACCOUNT OR ACCESS, IN WHOLE OR IN PART, TO THE APP AND SERVICES.\nAny limitations on liability that favor WussUp will survive the expiration or termination of these Terms for any reason.\nACKNOWLEDGEMENT\nWussUp and you acknowledge that these Terms are between you and WussUp only, and not with any other party, including, but not limited to, Facebook, Inc., Apple, Inc., Amazon, Inc. or Alphabet Inc., or any of their subsidiaries or affiliated companies. WussUp, not Facebook, Inc., Apple, Inc., Amazon, Inc. or Alphabet Inc., or any of their subsidiaries or affiliated companies, is solely responsible for the App and the Content thereof.\nTo the extent that these Terms provide for usage rules for the App that are less restrictive than the usage rules set forth for the App in, or otherwise conflict with, the terms of service for the App Store, Google Play Store or other authorized website or service that made the App available to you for download (the “Usage Rules”), the more restrictive or conflicting Usage Rules published by the applicable website or service (including, but not limited to, the App Store or the Google Play Store) applies.\nSCOPE OF LICENSE\nThe license granted to you for the App is limited to a non-transferable license to use the App, as applicable, on an iOS, Android or Amazon Fire product or on the Facebook platform that you own or control and as permitted by the applicable Usage Rules.\nMAINTENANCE AND SUPPORT\nWussUp is solely responsible for providing any maintenance and support services with respect to the App, as specified in these Terms (if any), or as required under applicable law. WussUp and you acknowledge that neither Facebook Inc., Apple, Inc., Amazon, Inc. nor Alphabet Inc., nor any of their subsidiaries or affiliated companies, has any obligation whatsoever to furnish any maintenance and support services with respect to the App.\nWARRANTY\nWith respect to the App, WussUp is solely responsible for any product warranties, whether express or implied by law, to the extent not effectively disclaimed. With respect to any items listed for sale via the App, however, the applicable user or brand listing such item is solely responsible for all product warranties, if any. In the event of any failure of the App to conform to any applicable warranty, you may notify Facebook, Inc., Apple, Inc., Amazon, Inc. or Alphabet Inc., as applicable, and Facebook, Inc., Apple, Inc., Amazon, Inc. or Alphabet Inc., as applicable, will refund the purchase price of the App to you. To the maximum extent permitted by applicable law, Facebook, Inc., Apple, Inc., Amazon, Inc. and Alphabet Inc., and their subsidiaries and related companies, will not have any other warranty obligations whatsoever with respect to the App, and any other claims, losses, liabilities, damages, costs or expenses attributable to any failure to conform to any warranty will be WussUp’s sole responsibility.\nPRODUCT CLAIMS\nWussUp and you acknowledge that WussUp, not Facebook, Inc., Apple, Inc., Amazon, Inc. or Alphabet Inc., or any of their subsidiaries or affiliated companies, is responsible for addressing any claims by you or any third party relating to the App or your possession and/or use of the App, including, but not limited to: (a) product liability claims; (b) any claim that the App fails to conform to any applicable legal or regulatory requirement; and (c) claims arising under consumer protection or similar legislation. These Terms do not limit WussUp’s liability to you beyond what is permitted by applicable law.\nINTELLECTUAL PROPERTY RIGHTS\nWussUp and you acknowledge that, in the event of any third party claim that the App or your possession and use of the App infringes that third party’s intellectual property rights, WussUp, not Facebook, Inc., Apple, Inc., Amazon, Inc. or Alphabet Inc., or any of their subsidiaries or affiliated companies, will be solely responsible for the investigation, defense, settlement and discharge of any such intellectual property infringement.\nLEGAL COMPLIANCE\nYou represent and warrant that: (a) you are not located in a country that is subject to a U.S. Government embargo, or that has been designated by the U.S. Government as a “terrorist supporting” country; and (b) you are not listed on any U.S. Government list of prohibited or restricted parties.\nOTHER TERMS\nWussUp’s failure to enforce any provision of these Terms shall not be deemed a waiver of such provision nor of the right to enforce such provision. If any part of these Terms are determined to be invalid or unenforceable pursuant to applicable law, including, but not limited to, the warranty disclaimers and liability limitations set forth above, then the invalid or unenforceable provision will be deemed superseded by a valid, enforceable provision that most closely matches the intent of the original provision and the remainder of these Terms shall continue in effect. A printed version of these Terms and of any notice given in electronic form shall be admissible in judicial or administrative proceedings based upon or relating to these Terms to the same extent and subject to the same conditions as other business documents and records originally generated and maintained in printed form.\nCONTACT INFORMATION\nYou may contact us for any reason, including to report potential violations of these Terms or the Rules by others, by email at info@arvzapp.com."
    }
}
