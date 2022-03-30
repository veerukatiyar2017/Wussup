//
//  Api.swift
//  SimpleApiClient
//
//  Created by ShengHua Wu on 8/22/16.
//  Copyright © 2016 ShengHua Wu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class WUWebService : SessionManager {
    /// Custom header field
    var webserviceCallsCount = 0
    var header  = ["Content-Type":"application/json",
                   "Accept": "application/json"]
    
    static let API: WUWebService = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 60
        configuration.timeoutIntervalForRequest  = 60
        
        return WUWebService(configuration: configuration)
    }()
    
    func cancelAllTasks() {
        self.session.getAllTasks { tasks in
            tasks.forEach {
                $0.cancel()
            }
        }
    }
    
    //    func setToken(authorizeToken : String) {
    //        self.header[Key.AccessToken] = authorizeToken
    //    }
    
    func set(sessionCookie cookie: String?) {
        self.header["Set-Cookie"] = cookie
    }
    
    /// Remove Bearer token with this method
    func removeAuthorizeToken() {
        header.removeValue(forKey: "Authorization")
    }
    
    func removeSessionCookie() {
        header.removeValue(forKey: "Set-Cookie")
    }
    
    //All webservices of this application by pass from this method // LPResponse
    func callRequest(_ endpoint: Endpoint,
                     retryCount: Int = 1,
                     completion:((JSON?, String?, Bool) -> Void)?) {
        
        isNetworkConnected = (NetworkReachabilityManager()?.isReachable)!
        
        guard isNetworkConnected == true else {
             Utill.showNoInternetView()
            //Utill.showAlertViewOnWindow(message: Text.Message.noInternet)
            completion?(nil, Text.Message.noInternet, false)
            return
        }
        
        let path = endpoint.path.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        
         Utill.printInTOConsole(printData:"Path Of service *-------- \(String(describing: path))")
        
        var parameter = endpoint.parameters
        if endpoint.parameters == nil {
            parameter = [:]
        }
        
        if let user = Utill.getUserModel()  {
            let token = user.Token
//            let token = "r4621mGD-qEAfRUBH0i2SS4G5GbL1yWKmCUe1DCKWdvbPszfNEY0k_CIKC_1m0auVzu5_4NBI90vChQxOLvcG4FkV_Xmkp69ZAhBIBG-mIHbG4SPpBcg5JSMY_XEjp5fsmBlgFPA0bgsqmimYmwDCTrwGdu3b9l9vPIJHic8Ln8jF1sxbZt0AuDA8Q8NTWRoLMX3YW1xMNINhFTw40gAijFpFeIea4NBuFIE4ncVCTFgV4AJYgdhHsYdHm0qtX6QA8jg5LGvXJMkvGf12p6X1L-j0ObM7IWoUCVGBaSIpyq2AU6zuT6Zq9YcPFcMKdKCknsF95Jxfgveq-CEO4hE3s7m5jGhzZNpyaBUaFyzgH-x0-LWV-s2TQ1Td7C4dMNNpaZDYNvXxleJolpdmkGao02wMUEqD97zO69QNUyasvC1cBBmzqgGyUVqfJwGuzMeoW-umM6lSEDQYZYGbmm9cg"
                //user.Token

            header["Authorization"] = "bearer \(token)"
        }else{
            removeAuthorizeToken()
        }
        
         Utill.printInTOConsole(printData:"Header ---- \(header)")
        //parameter![Key.language] = Global.language.locale
        
        //Update encoding here
        var encoding: ParameterEncoding = JSONEncoding.default
        if endpoint.method == .get {
            encoding = URLEncoding.default
        }
        
        Utill.printInTOConsole(printData:"Parameter ------ \(String(describing: parameter))")
        
        self.request(path!, method: endpoint.method,
                     parameters: parameter!,
                     encoding: encoding, headers: header).responseJSON
            { response in
                Utill.printInTOConsole(printData:"Response ---- \(String(describing: response.request))")
                switch response.result {
                case .success:
                    if let _ = response.result.value {
                        let jsonResult: JSON = JSON(response.result.value!)
                        let resp = WUResponse(parameter: jsonResult, type: endpoint.type)
                        
                        Utill.printInTOConsole(printData:"Status Code ------- \(resp.statusCode!)")
                        if resp.statusCode! == 501 {//code for "Server is under maintenance process" message
                            if retryCount <= 3 {
                                self.callRequest(endpoint, retryCount: retryCount + 1, completion: completion)
                            } else {
                                completion?(jsonResult,resp.message, resp.status)
                            }
                        } else {
                            if let errorMessage = jsonResult["Message"].string{
                                if errorMessage.lowercased() == "Authorization has been denied for this request.".lowercased(){
                                    Utill.logOutAndClearData()
                                    completion?(jsonResult,"Authorization has been denied for this request.", resp.status)
                                }
                            }
                            else {
                                completion?(jsonResult,resp.message, resp.status)
                            }
                        }
                        
                    } else {
                        completion?(nil,"Error",false)
                    }
                    
                case .failure(let error):
                    Utill.printInTOConsole(printData:"Error: \(error)")
                    if response.response?.statusCode == 403
                    {
                        Utill.logOutAndClearData()
                        completion?(nil,"User not authorized",false)
                    }else {
                        completion?(nil,error.localizedDescription,false)
                    }
                }
        }
    }
    
    
    func sendProfilePicRequest(_ endpoint: Endpoint,ID : String = "", completion:@escaping ((JSON?,String?)->Void)) {
        //No network logic
        guard isNetworkConnected == true else {
            completion(nil,  Text.Message.noInternet)
            return
        }
        
        var path = endpoint.path.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        
        if ID.isEmpty == false{
            path = path! + "/\(ID)"
        }
        Utill.printInTOConsole(printData:"Path Of service *-------- \(String(describing: path))")
        
        var parameter = endpoint.parameters
        if endpoint.parameters == nil {
            parameter = [:]
        }
        
        //        if let _ = Global.token {
        //            let token = Global.token?.access_token
        //            header["Authorization"] = "bearer \(token!)"
        //        }
        Utill.printInTOConsole(printData:"Header ---- \(header)")
        /*
         //Basic Auth
         if let _ = Global.user {
         let credentialData = "\(Global.user!.email!):\(Global.user!.password!)".data(using: String.Encoding.utf8)!
         let base64Credentials = credentialData.base64EncodedString(options: [])
         header[Key.auth] = "Basic \(base64Credentials)"
         }
         */
        
        self.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameter! {
                if key == "profile_picture" {
                    let imageData = value as! Data
                    if imageData.count > 0 {
                        multipartFormData.append(imageData, withName: "profile_picture",fileName: "image.jpg", mimeType: "image/jpg")
                    }
                } else {
                    let string = value as! String
                    let data = string.data(using: String.Encoding.utf8)
                    multipartFormData.append(data!, withName: key)
                }
            }
        }, to: path!,method: endpoint.method, headers: header) { encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON {response in
                    if let _ = response.result.value {
                        let jsonResult: JSON = JSON(response.result.value!)
                        let resp = WUResponse(parameter: jsonResult, type: endpoint.type)
                        
                        resp.data = jsonResult[""][""].stringValue
                        completion(jsonResult,"success")
                        
                    } else {
                        completion(nil,"error")
                    }
                }
            case .failure(let encodingError):
                Utill.printInTOConsole(printData:"error: \(encodingError )")
                completion(nil,"error")
            }
        }
    }
    
    /* func call_api_Remove_ProductFromCart(objProduct : CDProduct,withCompletionHandler completion:@escaping ((JSON?)-> Void)){
     if AppDel.isInternetActive == false{
     Utill.showAlertWithSnackbar(message: Text.Message.noInternet, backgroundColor: UIColor.white, withTextColor: UIColor.snackBarAlertRed)
     return
     }
     
     var id = ""
     if Global.user == nil{
     id = "\(Global.guestUser?.id! ?? "")/carts/\(Global.orderId ?? "")/remove_cart_item"
     }else{
     id = "\(Global.user?.id! ?? "")/carts/\(Global.orderId ?? "")/remove_cart_item"
     }
     
     let param = ["uuid":UniqueID,
     "product_id":objProduct.productID!] as [String : Any]
     Web.callRequest(.deleteProductFromCart(param), retryCount: 1, product_ID: id) { (response, message) in
      Utill.printInTOConsole(printData:"Response of deleteProductFromCart ------ \(String(describing: response))")
     completion(response)
     }
     }*/
    
    //MARK: - WUHomeViewController
    
    func call_api_CityNameFromCordinates(withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)) {
        Utill.showProgressHud()
        self.webserviceCallsCount += 1

        
        // Anaheim
//        let latitude = 33.794137
//        let longitude = -117.806426
//
//        let param = ["Latitude":"\(latitude)",
//            "Longitude":"\(longitude)"]
        
        let lattitude = GlobalShared.geolocationFilterData?.Latitude ?? ""
        let longitude = GlobalShared.geolocationFilterData?.Longitude ?? ""
   
        let lat = lattitude.count == 0 ? "\(GlobalShared.currentLocationCoordinate.latitude)" : lattitude
        let long = longitude.count == 0 ? "\(GlobalShared.currentLocationCoordinate.longitude)" : longitude
              
        let param = ["Latitude": lat,
                    "Longitude": long]

        WEB_API.callRequest(Endpoint.CityNameFromCordinates(param: param))
        { (response, message, status) in
            self.webserviceCallsCount -= 1
            
            if status == false{
                Utill.hideProgressHud()
            }
            else if self.webserviceCallsCount == 0 {
                Utill.hideProgressHud()
            }
            Utill.printInTOConsole(printData:"Response of CityNameFromCordinates ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    func call_api_GetHomeAds(withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)) {
        Utill.showProgressHud()
        self.webserviceCallsCount += 1
                
        let param = ["Latitude":"\(GlobalShared.currentLocationCoordinate.latitude)",
                    "Longitude":"\(GlobalShared.currentLocationCoordinate.longitude)"]
        
        WEB_API.callRequest(Endpoint.GetHomeAds(param: param))
        { (response, message, status) in
            self.webserviceCallsCount -= 1
            
            if status == false {
                Utill.hideProgressHud()
            }
            else if self.webserviceCallsCount == 0 {
                Utill.hideProgressHud()
            }
            Utill.printInTOConsole(printData:"/////RESPONCE of GetHomeAds ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    func call_api_GetHomeVenuesList(user : User,
                                    geolocationFilterData: WUGeolocationFilterData,
                                    withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void))
    {
        
        var latitude = geolocationFilterData.Latitude ?? "\(GlobalShared.currentLocationCoordinate.latitude)"
        var longitude = geolocationFilterData.Longitude ?? "\(GlobalShared.currentLocationCoordinate.longitude)"
        let radius = geolocationFilterData.Radius == 0 ? String(90) : String(geolocationFilterData.Radius)
        
        if geolocationFilterData.IsNearBy{
            latitude = "\(GlobalShared.currentLocationCoordinate.latitude)"
            longitude = "\(GlobalShared.currentLocationCoordinate.longitude)"
        }
        
        let param = ["UserID" : user.ID,
                     "Latitude": latitude,
                     "Longitude": longitude,
                     "UserLattitude": "\(GlobalShared.currentLocationCoordinate.latitude)",
                     "UserLongitude": "\(GlobalShared.currentLocationCoordinate.longitude)",
                     "Radius": radius]
        
        Utill.showProgressHud()
        self.webserviceCallsCount += 1
        WEB_API.callRequest(Endpoint.GetHomeVenuesList(param: param))
        { (response, message, status) in
            self.webserviceCallsCount -= 1
            
            if self.webserviceCallsCount == 0 {
                Utill.hideProgressHud()
            }
            Utill.printInTOConsole(printData:"/////RESPONCE  of GetHomeVenuesList ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
  
    //MARK: - Common
    func call_api_GetCategoryList(withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        Utill.showProgressHud()
        self.webserviceCallsCount += 1
        WEB_API.callRequest(Endpoint.GetCategoryList()) { (response, message, status) in
            self.webserviceCallsCount -= 1
            
            if status == false{
                Utill.hideProgressHud()
            }
            else if self.webserviceCallsCount == 0{
                Utill.hideProgressHud()
            }
             Utill.printInTOConsole(printData:"Response of GetCategoryList ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    func call_api_GetUserFavouriteCategory(user : User, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserID": user.ID]
        
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.GetUserFavouriteCategory(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of GetUserFavouriteCategory ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
   
    //MARK: - WUInterestsViewController
    func call_api_SaveUserCategories(user : User, categories : String, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserID": user.ID, "Categories" : categories]
        
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.SaveUserCategories(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of SaveUserCategories ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    //MARK: - WUHomeSearchViewController
    func call_api_GetSearchSuggestions(searchText : String,
                                       withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        //let param = ["Search": searchText]
        
        var latitude = "\(GlobalShared.geolocationFilterData?.Latitude ?? String(GlobalShared.currentLocationCoordinate.latitude))"
        var longitude = "\(GlobalShared.geolocationFilterData?.Longitude ?? String(GlobalShared.currentLocationCoordinate.longitude))"
        
        let radius = GlobalShared.geolocationFilterData?.Radius == 0 ? String(90) : (String(GlobalShared.geolocationFilterData?.Radius ?? 90))
               
        if GlobalShared.geolocationFilterData?.IsNearBy ?? false{
            latitude = "\(GlobalShared.currentLocationCoordinate.latitude)"
            longitude = "\(GlobalShared.currentLocationCoordinate.longitude)"
        }
               
               let param = ["Search": searchText,
                            "Latitude": latitude,
                            "Longitude": longitude,
                            "UserLattitude": "\(GlobalShared.currentLocationCoordinate.latitude)",
                            "UserLongitude": "\(GlobalShared.currentLocationCoordinate.longitude)",
                            "Radius": radius]

        WEB_API.callRequest(Endpoint.GetSearchSuggestions(param: param)) { (response, message, status) in
             Utill.printInTOConsole(printData:"Response of GetSearchSuggestions ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
   
    //MARK: - WUHomeRecentSearchViewController
    func call_api_GetRecentSearchList(user : User, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserID": user.ID]
        
        WEB_API.callRequest(Endpoint.GetRecentSearchList(param: param)) { (response, message, status) in
             Utill.printInTOConsole(printData:"Response of GetRecentSearchList ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    func call_api_ClearRecentSearchList(user : User, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserID": user.ID]
        
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.ClearRecentSearchList(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
            
             Utill.printInTOConsole(printData:"Response of ClearRecentSearch ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    //MARK: - WUHomeSearchResultViewController , WUEventSearchResultViewController
    //        {
    //            "UserID" : 459,
    //            "Lattitude" : 33.833860,
    //            "Longitude" : -117.910039,
    //            "Search" : " ",
    //            "SelectedCategoryIDs" : "5",
    //            "FilteredIDs" : "",
    //            "CurrentDateTime" : "05/24/2019 09:03:28",
    //            "SelectedCategoryFourSquareIDs" : "4d4b7105d754a06374d81259"
    //        }
    
    func call_api_SearchVenues(user : User, searchData : SearchVenueAndEventData, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        //        let selectedCategoryIDs = searchData.selectedCategories
        let selectedCategoryIDs = searchData.selectedCategories.map { $0.ID }.joined(separator: ",")
        let selectedFilterIDs = searchData.selectedfilters.map { $0.filterId }.joined(separator: ",")
        let selectedCategoryFourSquareIDs = searchData.selectedCategories.map { $0.FourSquareCategoryID }.joined(separator: ",")

         var latitude = "\(GlobalShared.geolocationFilterData?.Latitude ?? String(GlobalShared.currentLocationCoordinate.latitude))"
           var longitude = "\(GlobalShared.geolocationFilterData?.Longitude ?? String(GlobalShared.currentLocationCoordinate.longitude))"
           
           let radius = GlobalShared.geolocationFilterData?.Radius == 0 ? String(90) : (String(GlobalShared.geolocationFilterData?.Radius ?? 90))
                  
           if GlobalShared.geolocationFilterData?.IsNearBy ?? false{
               latitude = "\(GlobalShared.currentLocationCoordinate.latitude)"
               longitude = "\(GlobalShared.currentLocationCoordinate.longitude)"
           }
           
           var searchText = " "
           if searchData.searchText != "" {
               searchText = searchData.searchText
           }
           
           let param = ["UserID"                           : user.ID,
                        "Search"                           : searchText,
                        "SelectedCategoryIDs"              : selectedCategoryIDs,
                        "SelectedCategoryFourSquareIDs"    : selectedCategoryFourSquareIDs ,
                        "FilteredIDs"                      : selectedFilterIDs,
                        "Lattitude"                         : latitude,
                        "Longitude"                        : longitude,
                        "UserLattitude"                    : "\(GlobalShared.currentLocationCoordinate.latitude)",
                        "UserLongitude"                    : "\(GlobalShared.currentLocationCoordinate.longitude)",
                        "Radius"                           : radius,
                        "CurrentDateTime"                  : Date.currentDateString()]
         
        
  
        print("param - \(param)")
        Utill.printInTOConsole(printData:"/////SearchVenues param ------ \(String(describing: param))")

        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.SearchVenues(param: param))
        { (response, message, status) in
            
            Utill.hideProgressHud()
            
            Utill.printInTOConsole(printData:"/////RESPONCE of SearchVenues ------ \(String(describing: response))")
            completion(response, status, message!)
        }
    }
    /*
    /////SearchVenues param ------
     {
    "SelectedCategoryIDs": "",
    "Lattitude": "33.6797",
    "FilteredIDs": "",
    "Longitude": "-117.8904",
    "Search": "Dish Cafe",
    "CurrentDateTime": "07/23/2019 20:56:10",
    "SelectedCategoryFourSquareIDs": "",
    "UserID": "459"
     }
    */
    
    //MARK: - WUVenueProfileViewController
    /*
     {
     "FourSquareVenueID":"51638846e4b0ec7be1d274fd",
     "SponsoredVenueID":"1",
     "UserID":"1",
     "TodayDateTime":"05/20/2018 22:24:00"
     }
     */
    
    func call_api_GetVenueProfileDetail(user : User,
                                        fourSquareVenueId : String,
                                        sponsoredVenuID : String,
                                        venueLatitude: String,
                                        venueLongitude: String,
                                        withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
       
        let venueLat = venueLatitude.count == 0 ? "\(GlobalShared.currentLocationCoordinate.latitude)" : venueLatitude
        let venueLong = venueLatitude.count == 0 ? "\(GlobalShared.currentLocationCoordinate.longitude)" : venueLongitude

        let param = ["UserID": user.ID,
                     "FourSquareVenueID":fourSquareVenueId,
                     "SponsoredVenueID":sponsoredVenuID,
                     "TodayDateTime":Date.currentDateString(),
                     "Latitude":"\(GlobalShared.currentLocationCoordinate.latitude)",
                     "Longitude":"\(GlobalShared.currentLocationCoordinate.longitude)",
                     "VenueLatitude": venueLat,
                     "VenueLongitude":venueLong]
        
        print("param - \(param)")
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.GetVenueProfileDetail(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of GetVenueProfileDetail ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    /* {
     "FourSquareVenueID":"51638846e4b0ec7be1d274fd",
     "UserID":"1",
     "IsFavorite":"false"
     }*/
    
    func call_api_FavouriteVenue(user : User, venueDetail : WUVenueDetail, isFavorite : Bool, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserID": user.ID,
                     "FourSquareVenueID":venueDetail.FourSquareVenueID,
                     "IsFavorite": isFavorite ? "True" :"false"
        ]
        
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.FavouriteVenue(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of FavouriteVenue ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    /*{
     "FourSquareVenueID":"53ea6f0b498eb372eabde208",
     "UserID":"1",
     "Rating":"4"
     }*/
    
    func call_api_RateVenue(user : User, venueDetail : WUVenueDetail, rating : Int , withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserID": user.ID,
                     "FourSquareVenueID":venueDetail.FourSquareVenueID,
                     "Rating":"\(rating)"
        ]
        
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.RateVenue(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of RateVenue ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    //MARK: - WUEventHomeViewController
    
    /* {
     "UserID":459,
     "CategoryID":0,
     "Search":"",
     "EventDate": "07/09/2019 09:42:49",
     "Offset":"0",
     "VenueCategoryIDs":"",
     "FilteredIDs":"",
     "Latitude":"33.6797",
     "Longitude":"-117.8904"
     }*/
    
    func call_api_GetEventList(user : User,
                               categoryId : String = "0",
                               date : Date,
                               searchData : SearchVenueAndEventData = SearchVenueAndEventData(),
                               geolocationFilterData: WUGeolocationFilterData,
                               withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)) {
        
        let selectedCategoryIDs = searchData.selectedCategories.map { $0.ID }.joined(separator: ",")
        let selectedFilterIDs = searchData.selectedfilters.map { $0.filterId }.joined(separator: ",")
      
        //        let selectedCategoryFourSquareIDs = searchData.selectedCategories.map { $0.FourSquareCategoryID }.joined(separator: ",")
        
       // var latitude = geolocationFilterData.Latitude ?? "\(GlobalShared.currentLocationCoordinate.latitude)"
       // var longitude = geolocationFilterData.Longitude ?? "\(GlobalShared.currentLocationCoordinate.longitude)"
        //let radius = geolocationFilterData.Radius == 0 ? String(90) : String(geolocationFilterData.Radius)
        
       // if geolocationFilterData.IsNearBy{
       //     latitude = "\(GlobalShared.currentLocationCoordinate.latitude)"
        //    longitude = "\(GlobalShared.currentLocationCoordinate.longitude)"
       // }
        
        let param = ["UserID": user.ID,
                     "CategoryID":categoryId,
                     "Search" : searchData.searchText,
                     "EventDate":date.toUTCString(), 
                     "Offset":"0",//Utill.getTimeZoneOffsetInMinutes(),
                     "VenueCategoryIDs":selectedCategoryIDs,
                     "FilteredIDs":selectedFilterIDs,
                     "Latitude": "\(GlobalShared.currentLocationCoordinate.latitude)",
                     "Longitude": "\(GlobalShared.currentLocationCoordinate.longitude)",
                     //"UserLattitude": "\(GlobalShared.currentLocationCoordinate.latitude)",
                     //"UserLongitude": "\(GlobalShared.currentLocationCoordinate.longitude)",
                   //  "Radius": radius
        ]
        
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.GetEventList(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of GetEventList ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    /*{
     "EventID":6
     }*/
    //MARK: - WUEventProfileViewController
    func call_api_GetEventDetail(eventId : String,
                                 latitude : String,
                                 longitude: String,
                                 withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = [
            "EventID": eventId,
            "Latitude": latitude,
            "Longitude": longitude
        ]
        
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.GetEventDetail(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of GetEventDetail ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    //MARK: - WUEventCategoiesViewController
    func call_api_GetEventCategories(withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.GetEventCategories()) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of GetEventCategories ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    //MARK: - WUEventSearchViewController
    /*
     {
     "Search":"event"
     }
     */
    func call_api_GetEventSearchSuggestions(searchText : String, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){

        var latitude = "\(GlobalShared.geolocationFilterData?.Latitude ?? String(GlobalShared.currentLocationCoordinate.latitude))"
        var longitude = "\(GlobalShared.geolocationFilterData?.Longitude ?? String(GlobalShared.currentLocationCoordinate.longitude))"
                  
        let radius = GlobalShared.geolocationFilterData?.Radius == 0 ? String(90) : (String(GlobalShared.geolocationFilterData?.Radius ?? 90))
                         
        if GlobalShared.geolocationFilterData?.IsNearBy ?? false{
            latitude = "\(GlobalShared.currentLocationCoordinate.latitude)"
            longitude = "\(GlobalShared.currentLocationCoordinate.longitude)"
        }

        let param = ["Search"                           : searchText,
                     "Lattitude"                        : latitude,
                     "Longitude"                        : longitude,
                     "UserLattitude"                    : "\(GlobalShared.currentLocationCoordinate.latitude)",
                     "UserLongitude"                    : "\(GlobalShared.currentLocationCoordinate.longitude)",
                     "Radius"                           : radius]
        
        WEB_API.callRequest(Endpoint.GetEventSearchSuggestions(param: param)) { (response, message, status) in
             Utill.printInTOConsole(printData:"Response of GetEventSearchSuggestions ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    //MARK: - WUEventRecentSearchViewController
    /*
     {
     "UserID":"1"
     }
     
     */
    
    func call_api_GetRecentEventSearchList(user : User, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserID": user.ID]
        WEB_API.callRequest(Endpoint.GetRecentEventSearchList(param: param)) { (response, message, status) in
             Utill.printInTOConsole(printData:"Response of GetRecentEventSearchList ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    /*
     {
     "UserID":"1"
     }
     */
    
    func call_api_ClearEventRecentSearchList(user : User, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserID": user.ID]
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.ClearEventRecentSearchList(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of ClearEventRecentSearchList ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    //MARK: - WUSignUpViewController
    /*{
     "UserName":"98980229681",
     "Password":"123",
     "DeviceToken":"123456"
     }*/
    func call_api_SignUp(userName : String,mobile : String,passWord : String, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserName": userName,
                     "Mobile": mobile,
                     "Password":passWord,
                     "DeviceToken":GlobalShared.deviceToken]
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.SignUp(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of SignUp ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    //MARK: - WULoginViewController
    func call_api_Login(userName : String,passWord : String, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserName": userName,
                     "Password":passWord,
                     "DeviceToken":GlobalShared.deviceToken]
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.Login(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of Login ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    /* {
     "UserName":"milangorakhiait3@gmail.com",
     "FacebookID":"FB9898022968345",
     "DeviceToken":"123456"
     }*/
    
    func call_api_LoginWithFacebook(userName : String,facebookID : String, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserName": userName,
                     "FacebookID":facebookID,
                     "DeviceToken":GlobalShared.deviceToken]
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.LoginWithFacebook(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of LoginWithFacebook ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    //MARK: - WUForgotPasswordViewController
    func call_api_ForgotPassword(userName : String, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserName": userName]
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.ForgotPassword(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of ForgotPassword ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    //MARK: - WUFavoriteViewController
    /*
     {
    "Search":"",
     "UserID":"1",
     "TodayDateTime":"05/29/2018 10:27:00",
     "Latitude":"0",
     "Longitude":"0"
     }
     */
    func call_api_GetUserFavoriteVenues(user : User, date : Date ,searchText : String, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){

        guard GlobalShared.geolocationFilterData != nil else {return}
        
        let param = ["Search":searchText,
                     "UserID": user.ID,
                     "TodayDateTime":Date.currentDateString(),
                     "Latitude": "\(GlobalShared.geolocationFilterData.Latitude ?? "")",
                     "Longitude": "\(GlobalShared.geolocationFilterData.Longitude ?? "")",
                     "UserLattitude": "\(GlobalShared.currentLocationCoordinate.latitude)",
                     "UserLongitude": "\(GlobalShared.currentLocationCoordinate.longitude)"]
        
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.GetUserFavoriteVenues(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of GetUserFavoriteVenues ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    //MARK: - GetUserProfile
 /*
    {
    "UserID":"1",
    }
*/
    func call_api_GetUserProfile(withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserID": GlobalShared.user.ID]
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.GetUserProfile(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of GetUserProfile ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    //MARK: - EditUserProfile
    /*
     {
     "UserID":"1",
     "UserName":"test1@gmail.com",
     "City":"Surat",
     "Email":"test1@gmail.com",
     "Birthdate":"12/13/1987",
     "Categories":"1,2,3,4"
     }
     */
    func call_api_EditUserProfile(username: String,
                                  imageUrl : String,
                                  email : String,
                                  mobile : String,
                                  birthDate: String,
                                  city : String = "",
                                  allowNotification : String,
                                  //categories : String,
                                  postalCode: String,
                                  categoriesPreference: String,
                                  withCompletionHandler
        completion:@escaping ((JSON?, Bool, String)-> Void)){
        
        // let selectedCategoriesIDs = searchData.selectedfilters.map { $0.filterId }.joined(separator: ",")
        
        let param = ["UserID": GlobalShared.user.ID,
                     "ImageURL" : imageUrl,
                     "UserName":username,
                     "Mobile": mobile,
                     "City": city,
                     "Email":email,
                     "Birthdate":birthDate,
                     "IsAllowedNotification": allowNotification,
                     //"Categories": categories,
                     "PostalCode": postalCode,
                     "CategoriesPreference": categoriesPreference]
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.EditUserProfile(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
            Utill.printInTOConsole(printData:"Response of EditUserProfile ------ \(String(describing: response))")
            completion(response, status, message!)
        }
    }
    //MARK: - LogOutUSer
    func call_api_LogoutUser(withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)) {
        
        let param = ["UserID": GlobalShared.user.ID]
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.LogoutUser(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of LogoutUser ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    /*
     {
     "UserFavoriteVenueID":4,
     "IsSendPromotionalAlert":"True",
     "IsSendCustomNotification":"False",
     "IsWeekEndNotification":"True",
     "IsSpecialEventNotification":"True",
     "PerDay":"3",
     "PerWeek":"4",
     "PerMonth":"5"
     }

     */
    
    func call_api_UpdateUserFavoriteVenuesSetting(userNotification : WUUserFavNotificationSettings, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserFavoriteVenueID": userNotification.UserFavoriteVenueID,
                     "IsSendPromotionalAlert": userNotification.IsSendPromotionalAlert,
                     "IsSendCustomNotification": userNotification.IsSendCustomNotification,
                     "IsWeekEndNotification": userNotification.IsWeekEndNotification,
                     "IsSpecialEventNotification": userNotification.IsSpecialEventNotification,
                     "PerDay": userNotification.PerDay,
                     "PerWeek": userNotification.PerWeek,
                     "PerMonth": userNotification.PerMonth
                     ]
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.UpdateUserFavoriteVenuesSetting(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of UpdateUserFavoriteVenuesSetting ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
   /* {
    "Longitude": "-122.406417",
    "Latitude": "37.785834"
    }*/

    //MARK: - LiveCam
    
    func call_api_GetLiveCamList(withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["Latitude":"\(GlobalShared.currentLocationCoordinate.latitude)",
            "Longitude":"\(GlobalShared.currentLocationCoordinate.longitude)"]
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.GetLiveCamList(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of GetLiveCamList ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    func call_api_GetLiveCamDetail(strLiveCamID : String,withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        
        let param = [
            "Lattitude":"\(GlobalShared.currentLocationCoordinate.latitude)",
            "Longitude":"\(GlobalShared.currentLocationCoordinate.longitude)",
            "LiveCamID":strLiveCamID
        ]
        
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.GetLiveCamDetail(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
            Utill.printInTOConsole(printData:"Response of GetLiveCamDetail ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    //MARK: - WUHomeSearchFoodCategoryViewController
    func call_api_GetFoodCategoryList(withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.GetFoodCategory()) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of GetFoodCategory ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    //MARK: - AccuWeather API
    func call_api_GetLocationKeyOfCity(withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)) {

        let lattitude = GlobalShared.geolocationFilterData?.Latitude ?? ""
        let longitude = GlobalShared.geolocationFilterData?.Longitude ?? ""
        
        let lat = lattitude.count == 0 ? "\(GlobalShared.currentLocationCoordinate.latitude)" : lattitude
        let long = longitude.count == 0 ? "\(GlobalShared.currentLocationCoordinate.longitude)" : longitude
        
        let param = ["Lattitude": lat,
                     "Longitude": long]
        
        WEB_API.callRequest(Endpoint.GetGeoPositionSearch(param: param)) { (response, message, status) in
             Utill.printInTOConsole(printData:"Response of GetGeoPositionSearch ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    func call_api_GetCurrnetConditionWeather(strLocationKey : String,
                                             withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)) {
        
        WEB_API.callRequest(Endpoint.GetCurrnetConditionWeather(locationKey: strLocationKey))
        { (response, message, status) in
            Utill.printInTOConsole(printData:"Response of GetCurrnetConditionWeather ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    //MARK: - Get Share Text For Venue or Event

    func call_api_GetShareLinkForVenueOrEvent(strVenueID : String,
                                              strFourSquareVenueID: String ,
                                              strEventID : String ,
                                              strLiveCamID : String ,
                                              withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)) {
        
        let param = ["VenueID" :strVenueID,
                     "EventID" :strEventID,
            "FourSquareVenueID": strFourSquareVenueID,
                   "LiveCamID" : strLiveCamID]
        
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.GetShareLinkForVenueOrEvent(param: param)) { (response, message, status) in
            Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of call_api_GetShareUrlForVenueOrEvent ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    //MARK: - APIVersionCheck
    func call_api_APIVersionCheck(withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let buildNo = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String

        let param = ["DeviceType":"1",
                     "VersionName":version,
                     "VersionID": buildNo]
       
        WEB_API.callRequest(Endpoint.APIVersionCheck(param: param)) { (response, message, status) in
             Utill.printInTOConsole(printData:"Response of call_api_APIVersionCheck ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    
    
    //MARK: - Get Autocomplete List Cities
    
    func call_api_GetListOfCities(strLocationKey : String,
                                  withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)) {
       // Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.GetListOfCities(locationKey: strLocationKey)){ (response, message, status) in
           // Utill.hideProgressHud()

            Utill.printInTOConsole(printData:"Response of GetListOfCities ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    func call_api_GetLocationOfCity(strPlace_id : String,
                                    withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)) {
           
            Utill.showProgressHud()
            WEB_API.callRequest(Endpoint.GetLocationOfCity(place_id: strPlace_id)) { (response, message, status) in
            Utill.hideProgressHud()
               Utill.printInTOConsole(printData:"Response of GetLocationOfCity ------ \(String(describing: response))")
               completion(response,status, message!)
           }
       }
    
    
      //MARK: - API Geolocation Filter Data
    func call_api_SaveLatLongDetails(user: User,
                                     latitude  : String,
                                     longitude : String,
                                     radius    : String,
                                     isNearBy    : Bool,
                                     withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)) {
        let param = ["UserId"   : user.ID,
                     "Latitude" : latitude,
                     "Longitude": longitude,
                     "Radius"   : radius,
                     "IsNearBy" : isNearBy] as [String : Any]
            
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.SaveLatLongDetails(param: param)) { (response, message, status) in
        Utill.hideProgressHud()
             Utill.printInTOConsole(printData:"Response of call_api_SaveLatLongDetails ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    
    func call_api_GetLatLongDetails(user: User,
                                    withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)) {
        let param = ["UserId" : user.ID]
        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.GetLatLongDetails(param: param)) { (response, message, status) in
        Utill.hideProgressHud()

            Utill.printInTOConsole(printData:"Response of call_api_GetLatLongDetails ------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }

    //MARK: - VenueClaim

    /*
     {
     "UserID":"5",
     "FourSquareID":"5af4d6a24e8f430024e5482b",
     "VenueName":"Blaze Pizza",
     "Email":"milangorakhiait@gmail.com",
     "Phone":"7048588392",
     }
     */
    
//    func call_api_VenueClaim(user : User,
//                             fourSquareID : String,
//                             venueName: String ,
//                             withCompletionHandler completion:@escaping ((JSON?, Bool, String) -> Void)) {
//
//        let param = ["UserID"       : user.ID,
//                     "FourSquareID" : fourSquareID,
//                     "VenueName"    : venueName,
//                     "Email"        : user.Email,
//                     "Phone"        : user.Mobile]
//
//        print("/////strFourSquareID = \(param)")
//
//        Utill.showProgressHud()
//
//        WEB_API.callRequest(Endpoint.VenueClaim(param: param)) { (response, message, status) in
//            Utill.hideProgressHud()
//            Utill.printInTOConsole(printData:"Response of call_api_VenueClaim ------ \(String(describing: response))")
//            completion(response,status, message!)
//        }
//    }
    
    //MARK: - GetClaimSuggestions
    /*{
    "Search":"pizza",
    "UserID":"1"
    }*/
    func call_api_GetClaimSuggestions(user : User,strSearchText: String, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["Search":strSearchText,
                     "UserID":user.ID,
                     "Latitude":"\(GlobalShared.currentLocationCoordinate.latitude)",
            "Longitude":"\(GlobalShared.currentLocationCoordinate.longitude)"]
        WEB_API.callRequest(Endpoint.GetClaimSuggestions(param: param)) { (response, message, status) in
            Utill.printInTOConsole(printData:"Response of call_api_GetClaimSuggestions------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }

    //MARK: - GetTotalUnreadNotification
    func call_api_GetTotalUnreadNotification(user : User, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserID":user.ID]
//        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.GetTotalUnreadNotification(param: param)) { (response, message, status) in
//            Utill.hideProgressHud()
            Utill.printInTOConsole(printData:"Response of call_api_GetTotalUnreadNotification------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    //MARK: - Mark All Notification As Read
    func call_api_MarkNotificationAsRead(user : User,venueID : String, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserID"   :user.ID,
                     "VenueID"  :venueID]
//        Utill.showProgressHud()
        WEB_API.callRequest(Endpoint.MarkNotificationAsRead(param: param)) { (response, message, status) in
//            Utill.hideProgressHud()
            Utill.printInTOConsole(printData:"Response of call_api_MarkNotificationAsRead------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
        //MARK: - Mark One Notification As Read
        func call_api_MarkOneNotificationAsRead(user : User, notificationID : Int, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
            let param = ["UserID"   :user.ID,
                         "NotificationID"  : String(notificationID)]
    //        Utill.showProgressHud()
            WEB_API.callRequest(Endpoint.MarkOneNotificationAsRead(param: param)) { (response, message, status) in
    //            Utill.hideProgressHud()
                Utill.printInTOConsole(printData:"Response of call_api_MarkOneNotificationAsRead------ \(String(describing: response))")
                completion(response,status, message!)
            }
        }
    
        
    //MARK: - Get Notification
    func call_api_GetNotification(user : User, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
        let param = ["UserID":user.ID,
                     "CurrentDateTime": Date.currentDateString()]
        WEB_API.callRequest(Endpoint.GetNotification(param: param)) { (response, message, status) in
            Utill.printInTOConsole(printData:"Response of call_api_GetNotification------ \(String(describing: response))")
            completion(response,status, message!)
        }
    }
    
    //MARK: - Remove Notification
      func call_api_RemoveNotification(notificationId: String, withCompletionHandler completion:@escaping ((JSON?, Bool, String)-> Void)){
          let param = ["NotificationId": notificationId]
          WEB_API.callRequest(Endpoint.RemoveNotification(param: param)) { (response, message, status) in
              Utill.printInTOConsole(printData:"Response of call_api_RemoveNotification------ \(String(describing: response))")
              completion(response,status, message!)
          }
      }
    
}
