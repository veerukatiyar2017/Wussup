//
//  WUSplashViewController.swift
//  Wussup
//
//  Created by MAC26 on 14/06/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUSplashViewController: UIViewController {
    
    @IBOutlet weak var imageViewAnimation: UIImageView!
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initaialInterfaceSetup()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Initial Interface SetUp
    private func initaialInterfaceSetup(){
        UIApplication.shared.isStatusBarHidden = true
        let gif = UIImage.gifImageWithName("transmissionInitiated")
        self.imageViewAnimation.image = gif
        var timeDuration = 2.0
        if Utill.getUserModel() != nil {
            timeDuration = 2.3
        }
        Timer.scheduledTimer(timeInterval: timeDuration,
                             target: self,
                             selector: #selector(self.moveToNextVC),
                             userInfo: nil,
                             repeats: false)
    }
    
    @objc private func moveToNextVC(){
        if let vc = UIStoryboard.loginSignUp.get(WUWelComeViewController.self){
            if Utill.getUserModel() != nil {
                self.navigationController?.addChildViewController(vc)
                if let tabbarvc = UIStoryboard.tabBar.get(WUTabbarViewController.self){
                    AppDel.tabbar = tabbarvc
                    self.navigationController?.pushViewController(tabbarvc, animated: false)
                }
            }else{
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
