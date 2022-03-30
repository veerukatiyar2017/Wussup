
//
//  LPResponse.swift
//
//

import Foundation
import Alamofire
import SwiftyJSON

extension JSON {
    func to<T>(type: T?) -> Any? {
        if let baseObj = type as? JSONable.Type {
            guard self.type != .null, self.type != .unknown else {
                return nil
            }
            
            if self.type == .array {
                var arrObject: [Any] = []
                arrObject = self.arrayValue.map { baseObj.init(parameter: $0)! }
                return arrObject
            } else {
                let object = baseObj.init(parameter: self)
                return object!
            }
        }
        return nil
    }
}


class WUResponse {
    var status      : Bool!
    var statusCode  : Int!
    var message     : String!
    var data        : Any!
    
    init() {
        status            = false
        message           = ""
        statusCode        = 100
        data              = nil
    }
    
    init<T>(parameter: JSON, type: T? = nil) {
        status     = parameter["resultState"]["Status"].boolValue
        message    = parameter["resultState"]["Message"].stringValue
        statusCode = parameter[""].intValue
        if let _ = type {
            data = parameter["data"].to(type: type)
        } else {
            data = parameter[""].dictionaryObject
        }
    }
    
    static var noInternetResponse: WUResponse {
        let response        = WUResponse()
        response.status     = false
        response.statusCode = 502
        response.message    = Text.Message.noInternet
        response.data       = nil
        return response
    }
}
