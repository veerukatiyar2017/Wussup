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
    static var Label                : WULabel           = WULabel()
    static var Message              : WUMessage         = WUMessage()
    static var TextField            : WUTextField       = WUTextField()
    static var Segue                : WUSegue           = WUSegue()
    static var UDKeys               : WUUserDefaultKey  = WUUserDefaultKey()
    static var SearchFilterNames    : WUSearchFilterNames   = WUSearchFilterNames()
    static var DictKeys              : WUDictKey          = WUDictKey()
    static var FirebaseEventName    : WUFirebaseEventName = WUFirebaseEventName()

    
    static func reset() {
        Label       = WULabel()
        Message     = WUMessage()
        TextField   = WUTextField()
        Segue       = WUSegue()
        Label       = WULabel()
        UDKeys      = WUUserDefaultKey()
        DictKeys    = WUDictKey()
        FirebaseEventName    = WUFirebaseEventName()
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
        
        let text_Ok              = "OK"
        let text_Cancel          = "Cancel"
        let text_Yes             = "Yes"
        let text_Login           = "Sign In"
        let text_No              = "No"
        let text_GoToSetting     = "Go To Setting "
        let text_BlankSpace      = ""
        let text_UpdateLater = "Remind Me Later"
        let text_UpdateNow = "Update Now"
       
        let text_Closed = "CLOSED"//"Closed"
        let text_OpenNow = "OPEN NOW: "
        let text_NoInformationFound = "No Information For Open Time"
        let text_Closes = "CLOSES "
        let text_Opens = "OPENS "
        let text_Open = "OPEN NOW"
        
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
        let text_ComingUp                 = "COMING UP"
        let text_More                     = "MORE"
        let text_Weekend                  = "WEEKEND"
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
        let text_ProfileUserName          = "User Name:"
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
         let text_validPhoneNumber      = "Please enter a valid phone number"
         let text_validEmail            = "Please enter a valid email"
         let text_validPhoneNumberDigit = "Please enter a valid 10 digits phone number"
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
        let text_CAB_AddressLine1  = "Business Address Line 1"
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
        let isFromSignUp =  "isFromSignUp"
        let saveCurrentDate = "saveCurrentDate"
        let HomeBanner                          = "HomeBanner"
    }
    
    struct WUSearchFilterNames {
        let nearby            = "Nearby"
        let openNow           = "Open Now"
        let LiveMusic         = "Live Music"
        let FoodCategory      = "Food Category"
    }
    
    //Localize all these texts of Message for support multilanguage
    struct WUMessage {
        let noInternet                  = "Sorry!  We weren't able to complete your request.  Please try again shortly."//"Internet connection is not available."
        let noDataFound                 = "No Result Found."
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
        let pleaseEnterValidEmail       = "Please provide valid Email."
        let profileUpdatedSuccessfully  = "Profile updated successfully."
        let deleteRowMsg                = "Are you sure you wish to delete?"
        let imageUploadError            = "Failed to update profile."
        let claimBussiness              = "Coming Soon."
        let photoPermissionMsg          = "Your photo library permisssion disabled.please allow us to use your photos"
        let cameraPermissionMsg          = "Your camera permisssion disabled.please allow us to use your camera"
        let notficationUpdatedSuccessfully  = "Notification Preferences updated"//Notification Presence updated"//"Notification updated successfully."

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
}
