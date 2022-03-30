//
//  WUGetReadyViewController.swift
//  Wussup
//
//  Created by MAC26 on 14/06/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUGetReadyViewController: UIViewController {
    
    @IBOutlet private weak var viewMiddle: UIView!
    @IBOutlet private weak var buttonContinue: UIButton!
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialDataSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Initial Interface SetUp
    private func initialDataSetup(){
        self.buttonContinue.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Continue, color: .btnLightGrayColor ), for: .normal)
        self.viewMiddle.backgroundColor = .DarkGrayColor
       
        UserDefault.set(true, forKey: Text.UDKeys.isLaunchedOnce)
        UserDefault.synchronize()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func buttonGetReadyAction(_ sender: UIButton) {
    }
    
    
}
