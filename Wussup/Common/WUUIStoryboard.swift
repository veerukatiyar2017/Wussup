//
//  WUUIStoryboard.swift
//  Wussup
//
//  Created by MAC219 on 6/14/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
//    static var loginSignUp: UIStoryboard {
//        return UIStoryboard(name: "LoginSignUp", bundle: nil)
//    }
    
    static var tabBar: UIStoryboard {
        return UIStoryboard(name: "Tabbar", bundle: nil)
    }
    
    static var home: UIStoryboard {
        return UIStoryboard(name: "Home", bundle: nil)
    }
    
    static var venue: UIStoryboard {
        return UIStoryboard(name: "Venue", bundle: nil)
    }
    
    static var liveCam: UIStoryboard {
        return UIStoryboard(name: "LiveCam", bundle: nil)
    }
    
    static var events: UIStoryboard {
        return UIStoryboard(name: "Events", bundle: nil)
    }
    
    static var favorites: UIStoryboard {
        return UIStoryboard(name: "Favorites", bundle: nil)
    }
    
    static var userProfile: UIStoryboard {
        return UIStoryboard(name: "UserProfile", bundle: nil)
    }
    
}


extension UIStoryboard {
    
   
//    var homeViewController: WUWelComeViewController {
//        guard let viewController = instantiateViewController(withIdentifier: String(describing: HomeViewController.self)) as? HomeViewController else {
//            fatalError(String(describing: HomeViewController.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
//        }
//        return viewController
//    }
//
//    var homeSearchViewController:WUHomeSearchViewController  {
//        guard let viewController = instantiateViewController(withIdentifier:Utill.get)
//            else {
//            fatalError(String(describing: HomeViewController.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
//        }
//        return viewController
//    }

}
