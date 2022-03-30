//
//  AllowLocationVC.swift
//  Wussup
//
//  Created by Serik on 7/4/19.
//  Copyright © 2019 MAC26. All rights reserved.
//

import UIKit

class AllowLocationVC: UIViewController {
    
    var infoLabelText: String!
    var buttonOkTitle: String!
    
    //MARK: - IBOutlet

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var buttonOkOutlet: UIButton!
    @IBOutlet weak var buttonTryAgainOutlet: UIButton!
    
    //MARK: - Variable

    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialInterfaceSetup()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetup()
    {
        if #available(iOS 13.0, *) {
                 overrideUserInterfaceStyle = .light
             } else {
                 // Fallback on earlier versions
             }
        
        if infoLabelText == Text.Message.noInternetConnection{ // No Internet Connection
            infoLabel.text = infoLabelText
            buttonOkOutlet.isHidden = true
        }else{                                                 // User Not allow Location
            buttonOkOutlet.isHidden = false
            buttonTryAgainOutlet.isHidden = true
        }
    }
    
    
    // MARK: - Action Methods
    
    
    @IBAction func buttonOkAction(_ sender: UIButton)
    {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func buttonTryAgainAction(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
