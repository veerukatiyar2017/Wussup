//
//  WUCompleteViewController.swift
//  Wussup
//
//  Created by MAC105 on 19/06/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class WUCompleteViewController: UIViewController {
    
    @IBOutlet private weak var labelUserName        : UILabel!
    @IBOutlet private weak var labelTitle           : UILabel!
    @IBOutlet private weak var labelDescription     : UILabel!
    @IBOutlet private weak var imageViewBeeGif      : UIImageView!

    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initaialInterfaceSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Initial Interface SetUp
    private func initaialInterfaceSetup(){
        let userInfo = Auth.auth().currentUser
        self.labelUserName.text = userInfo?.email
//        Utill.loadBeeAnimationForView(view: self.view)
         Utill.loadBeeGif(imageView: self.imageViewBeeGif)
    }
    
    //MARK:- Button Actions
    
    @IBAction func okButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: Text.Segue.confirmVCToHomeVC, sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Text.Segue.confirmVCToHomeVC{
            let tabbarvc = segue.destination as! WUTabbarViewController
            AppDel.tabbar = tabbarvc
        }
    }
    
}
