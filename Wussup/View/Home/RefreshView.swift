//
//  RefreshView.swift
//  CustomRefreshControl
//
//  Created by Yudiz on 18/04/18.
//  Copyright © 2018 Yudiz. All rights reserved.
//

import UIKit

/// RefreshView
class RefreshView: UIView {
    
    /// IBOutlets
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    /// Variable Declarations
    var gradientView: UIView!
}

// MARK: - UI Related
extension RefreshView {
    
    fileprivate func initializeGradientView() {
        gradientView = UIView(frame: CGRect(x: -30, y: 0, width: 100, height: 60))
        activityIndecator.addSubview(gradientView)
        gradientView.backgroundColor = UIColor.clear
    }

}
