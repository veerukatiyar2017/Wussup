//
//  Endpoint.swift
//  SimpleApiClient
//
//  Created by ShengHua Wu on 8/19/16.
//  Copyright © 2016 ShengHua Wu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol JSONable {
    init?(parameter: JSON)
}

protocol EndPointProtocol {
    var path       : String { get }
    var method     : HTTPMethod { get }
    var parameters : Parameters? { get }
    var type       : JSONable.Type? { get }
}

enum Endpoint: EndPointProtocol {
    case CityNameFromCordinates(param: Parameters)
    case GetHomeAds(param: Parameters)
    case GetCategoryList()
    case GetHomeVenuesList(param: Parameters)
    case SaveUserCategories(param: Parameters)
    case GetUserFavouriteCategory(param: Parameters)
    case GetSearchSuggestions(param: Parameters)
    case GetRecentSearchList(param: Parameters)
    case ClearRecentSearchList(param: Parameters)
    case SearchVenues(param: Parameters)
    case GetVenueProfileDetail(param: Parameters)
    case FavouriteVenue(param: Parameters)
    case RateVenue(param: Parameters)
    case GetEventList(param: Parameters)
    case GetEventDetail(param: Parameters)
    case GetEventCategories()
    
    case GetEventSearchSuggestions(param: Parameters)
    case GetRecentEventSearchList(param: Parameters)
    case ClearEventRecentSearchList(param: Parameters)
    
    case SignUp(param: Parameters)
    case Login(param: Parameters)
    case ForgotPassword(param: Parameters)
    case LoginWithFacebook(param: Parameters)
    
    case GetUserFavoriteVenues(param: Parameters)
    case GetUserProfile(param: Parameters)
    case EditUserProfile(param: Parameters)
    case LogoutUser(param: Parameters)
    case UpdateUserFavoriteVenuesSetting(param: Parameters)
    case GetFoodCategory()
    
    case GetLiveCamList(param: Parameters)
    case GetLiveCamDetail(param: Parameters)
    
    case GetGeoPositionSearch(param : Parameters)
    case GetCurrnetConditionWeather(locationKey: String)
    
    case GetShareLinkForVenueOrEvent(param : Parameters)
    case APIVersionCheck(param : Parameters)
    
    case VenueClaim(param : Parameters)
    case GetClaimSuggestions(param : Parameters)
    
    case GetTotalUnreadNotification(param : Parameters)
    case MarkNotificationAsRead(param : Parameters)
    
    var debugDescription: String {
        var printString = ""
        
        printString     += "\n*********************************"
        printString     += "\nMethod    : \(method)"
        printString     += "\nParameter : \(parameters.orNil)"
        printString     += "\nPath      : \(path)"
        printString     += "\n*********************************\n"
        printString     += "\nType      : \(type.orNil)"
        
        return printString
    }
    
    static func ==(lhs: Endpoint, rhs: Endpoint) -> Bool {
        return lhs.path == rhs.path
    }
    
}

extension Endpoint {
    var path: String {
        switch self {
        case .CityNameFromCordinates(_):
            return API_URL_Location + "CityNameFromCordinates"
        case .GetHomeAds(_):
            return API_URL_Wussup + "GetHomeAds"
        case .GetCategoryList:
            return API_URL_Wussup + "GetCategoryList"
        case .GetHomeVenuesList(_):
            return API_URL_Wussup + "GetHomeVenuesList"
        case .SaveUserCategories(_):
            return API_URL_Wussup + "SaveUserCategories"
        case .GetUserFavouriteCategory(_):
            return API_URL_Wussup + "GetUserFavouriteCategory"
        case .GetSearchSuggestions(_):
            return API_URL_Wussup + "GetSearchSuggestions"
        case .GetRecentSearchList(_):
            return API_URL_Wussup + "GetRecentSearchList"
        case .ClearRecentSearchList(_):
            return API_URL_Wussup + "ClearRecentSearchList"
        case .SearchVenues(_):
            return API_URL_Wussup + "SearchVenues"
        case .GetVenueProfileDetail(_):
            return API_URL_Wussup + "GetVenueProfileDetail"
        case .FavouriteVenue(_):
            return API_URL_Wussup + "FavouriteVenue"
        case .RateVenue(_):
            return API_URL_Wussup + "RateVenue"
        case .GetEventList(_):
            return API_URL_Wussup + "GetEventList"
        case .GetEventDetail(_):
            return API_URL_Wussup + "GetEventDetail"
        case .GetEventCategories(_):
            return API_URL_Wussup + "GetEventCategories"
        case .GetEventSearchSuggestions(_):
            return API_URL_Wussup + "GetEventSearchSuggestions"
        case .GetRecentEventSearchList(_):
            return API_URL_Wussup + "GetRecentEventSearchList"
        case .ClearEventRecentSearchList(_):
            return API_URL_Wussup + "ClearEventRecentSearchList"
        case .SignUp(_):
            return API_URL_Wussup + "SignUp"
        case .Login(_):
            return API_URL_Wussup + "Login"
        case .ForgotPassword(_):
            return API_URL_Wussup + "ForgotPassword"
        case .LoginWithFacebook(_):
            return API_URL_Wussup + "LoginWithFacebook"
            
        case .GetUserFavoriteVenues(_):
            return API_URL_Wussup + "GetUserFavoriteVenues"
        case .GetUserProfile(_):
            return API_URL_Wussup + "GetUserProfile"
        case .EditUserProfile(_):
            return API_URL_Wussup + "EditUserProfile"
        case .LogoutUser(_):
            return API_URL_Wussup + "LogoutUser"
        case .UpdateUserFavoriteVenuesSetting(_):
            return API_URL_Wussup + "UpdateUserFavoriteVenuesSetting"
            
        case .GetLiveCamList(_):
            return API_URL_Wussup + "GetLiveCamList"
        case .GetLiveCamDetail(_):
            return API_URL_Wussup + "GetLiveCamDetail"
            
        case .GetFoodCategory():
            return API_URL_Wussup + "GetFoodCategory"
            
        case .GetGeoPositionSearch(let param):
            return ACCUWEATHER_API_URL + "locations/v1/search?q=" + "\(param["Lattitude"] ?? "0"),\(param["Longitude"] ?? "0")&apikey=\(WEATHER_API_KEY)"
        case .GetCurrnetConditionWeather(let locationKey):
            return ACCUWEATHER_API_URL + "currentconditions/v1/\(locationKey).json?language=en&apikey=\(WEATHER_API_KEY)"
            
        case .GetShareLinkForVenueOrEvent(_):
            return API_URL_Wussup + "GetShareLink"
        case .APIVersionCheck(_):
            return API_URL_Wussup + "APIVersionCheck"
            
            
        case .VenueClaim(_):
            return API_URL_Wussup + "VenueClaim"
        case .GetClaimSuggestions(_):
            return API_URL_Wussup + "GetClaimSuggestions"
            
        case .GetTotalUnreadNotification(_):
            return API_URL_Wussup + "GetTotalUnreadNotification"
        case .MarkNotificationAsRead(_):
            return API_URL_Wussup + "MarkNotificationAsRead"
        }
    }
}

extension Endpoint {
    var method: HTTPMethod {
        switch self {
        case .CityNameFromCordinates:
            return .post
        case .GetHomeAds:
            return .post
        case .GetCategoryList:
            return .post
        case .GetHomeVenuesList:
            return .post
        case .SaveUserCategories:
            return .post
        case .GetUserFavouriteCategory:
            return .post
        case .GetSearchSuggestions:
            return .post
        case .GetRecentSearchList:
            return .post
        case .ClearRecentSearchList:
            return .post
        case .SearchVenues:
            return .post
        case .GetVenueProfileDetail:
            return .post
        case .FavouriteVenue:
            return .post
        case .RateVenue:
            return .post
        case .GetEventList:
            return .post
        case .GetEventDetail:
            return .post
        case .GetEventCategories:
            return .post
        case .GetEventSearchSuggestions:
            return .post
        case .GetRecentEventSearchList:
            return .post
        case .ClearEventRecentSearchList:
            return .post
        case .SignUp:
            return .post
        case .Login:
            return .post
        case .ForgotPassword:
            return .post
        case .LoginWithFacebook:
            return .post
            
        case .GetUserFavoriteVenues:
            return .post
        case .GetUserProfile:
            return .post
        case .EditUserProfile:
            return .post
        case .LogoutUser:
            return .post
        case .UpdateUserFavoriteVenuesSetting:
            return .post
            
        case .GetLiveCamList:
            return .post
        case .GetLiveCamDetail:
            return .post
            
        case .GetFoodCategory:
            return .post
        case .GetGeoPositionSearch(_) :
            return .get
        case .GetCurrnetConditionWeather :
            return .get
        case .GetShareLinkForVenueOrEvent(_):
            return .post
        case .APIVersionCheck(_):
            return .post
            
        case .VenueClaim(_):
            return .post
        case .GetClaimSuggestions(_):
            return .post
            
        case .GetTotalUnreadNotification(_):
            return .post
        case .MarkNotificationAsRead(_):
            return .post
        }
    }
}

extension Endpoint {
    var parameters: Parameters? {
        switch self {
        case .CityNameFromCordinates(let param):
            return param
        case .GetHomeAds(let param):
            return param
        case .GetCategoryList:
            return nil
        case .GetHomeVenuesList(let param):
            return param
        case .SaveUserCategories(let param):
            return param
        case .GetUserFavouriteCategory(let param):
            return param
        case .GetSearchSuggestions(let param):
            return param
        case .GetRecentSearchList(let param):
            return param
        case .ClearRecentSearchList(let param):
            return param
        case .SearchVenues(let param):
            return param
        case .GetVenueProfileDetail(let param):
            return param
        case .FavouriteVenue(let param):
            return param
        case .RateVenue(let param):
            return param
        case .GetEventList(let param):
            return param
        case .GetEventDetail(let param):
            return param
        case .GetEventCategories:
            return nil
        case .GetEventSearchSuggestions(let param):
            return param
        case .GetRecentEventSearchList(let param):
            return param
        case .ClearEventRecentSearchList(let param):
            return param
        case .SignUp(let param):
            return param
        case .Login(let param):
            return param
        case .ForgotPassword(let param):
            return param
        case .LoginWithFacebook(let param):
            return param
        case .GetUserFavoriteVenues(let param):
            return param
        case .GetUserProfile(let param):
            return param
        case .EditUserProfile(let param):
            return param
        case .LogoutUser(let param):
            return param
        case .UpdateUserFavoriteVenuesSetting(let param):
            return param
            
        case .GetLiveCamList(let param):
            return param
        case .GetLiveCamDetail(let param):
            return param
            
            
        case .GetFoodCategory():
            return nil
        case .GetGeoPositionSearch(let param):
            return param
        case .GetCurrnetConditionWeather(let locationKey):
            return nil
        case .GetShareLinkForVenueOrEvent(let param):
            return param
        case .APIVersionCheck(let param):
            return param
            
        case .VenueClaim(let param):
            return param
        case .GetClaimSuggestions(let param):
            return param
            
        case .GetTotalUnreadNotification(let param):
            return param
        case .MarkNotificationAsRead(let param):
            return param
        }
    }
}

extension Endpoint {
    var type: JSONable.Type? {
        
        /* switch self {
         case .profile:
         return User.self
         default:
         return nil
         }
         */
        return nil
    }
}


