//
//  CurrentCityManager.swift
//  Wussup
//
//  Created by Serik on 5/4/19.
//  Copyright © 2019 MAC26. All rights reserved.
//

import Foundation

final class CurrentCityManager {
    
    static let shared = CurrentCityManager()
    let userDefaults = UserDefaults.standard
    let keyCurrentCity = "keyCurrentCity"
    
    private init() {
    }
    
    var currentCity: String {
        get {
            guard let value = self.userDefaults.value(forKey: self.keyCurrentCity) as? String else {
                return ""
            }
            return value
        }
        set (keyNewSity) {
            self.userDefaults.set(keyNewSity, forKey: self.keyCurrentCity)
        }
    }
}

