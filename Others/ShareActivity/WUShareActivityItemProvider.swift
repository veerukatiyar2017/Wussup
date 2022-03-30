//
//  WUShareActivityItemProvider.swift
//  Wussup
//
//  Created by MAC219 on 6/22/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import Foundation

class WUShareActivityItemProvider: UIActivityItemProvider {
    override func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType?) -> Any? {
         Utill.printInTOConsole(printData:"activity type selected: \(activityType!.rawValue)")
        // These are your accepted activity types
        if activityType == UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDrive")
        {
            return nil
        }
        return placeholderItem
    }
}
// || activityType == UIActivityType.init("com.apple.mobilenotes.SharingExtension")
