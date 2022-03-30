//
//  WUSearchFilters.swift
//  Wussup
//
//  Created by MAC26 on 04/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUSearchFilters: Copying  {
    
    
    var filterId : String = ""
    var filterName : String = ""
    var isSelected : Bool = false
    
    
    required init(original: WUSearchFilters) {
        self.filterId = original.filterId
        self.filterName = original.filterName
        self.isSelected = original.isSelected
    }
    init(filterId : String, filterName : String ,isSelected : Bool) {
        self.filterId = filterId
        self.filterName = filterName
        self.isSelected = isSelected
    }
    
    init(filterId : String, filterName : String) {
        self.filterId = filterId
        self.filterName = filterName
    }
}
