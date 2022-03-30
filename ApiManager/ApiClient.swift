//
//  ApiClient.swift
//  Wussup
//
//  Created by MAC26 on 17/04/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class ApiClient: NSObject {
    static let sharedClient = ApiClient()
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
}
