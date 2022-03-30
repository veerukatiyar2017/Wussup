//
//  WUSignUpConfirmViewController.swift
//  Wussup
//
//  Created by MAC219 on 6/21/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUSignUpConfirmViewController: UIViewController {

    @IBOutlet private weak var imageViewAnimation       : UIImageView!
    @IBOutlet private weak var labelConfirm             : UILabel!
    @IBOutlet private weak var viewGreeting             : UIView!
    @IBOutlet private weak var imageViewWussUpConfirm   : UIImageView!
    @IBOutlet private weak var labelWussUp              : UILabel!
    @IBOutlet private weak var labelDots                : UILabel!
    @IBOutlet private weak var labelCustomApp           : UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.initaialInterfaceSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initaialInterfaceSetup(){
        self.viewGreeting.alpha = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
            self.loadGifDuringConfirm()
        })
    }
    
   private func loadGifDuringConfirm(){
        let gif = UIImage.gifImageWithName("confirmed")
        self.imageViewAnimation.image = gif
        Timer.scheduledTimer(timeInterval: 3.0,
                             target: self,
                             selector: #selector(self.viewGreetingDisplay),
                             userInfo: nil,
                             repeats: false)
    }
    
  private func loadGifDuringGreeting(){
//        FirebaseManager.sharedInstance.SignUpGreetingScreenShow(parameter: nil)
        let gif = UIImage.gifImageWithName("greetings")
        self.imageViewAnimation.image = gif
        Timer.scheduledTimer(timeInterval: 5.6,
                             target: self,
                             selector: #selector(self.moveToTabBar),
                             userInfo: nil,
                             repeats: false)
    }
    
    @objc private func viewGreetingDisplay(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.labelConfirm.alpha = 0.0
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.6, animations: {
             self.viewGreeting.alpha = 1.0
            self.loadGifDuringGreeting()
            self.view.layoutIfNeeded()
        })
        
//        UIView.animate(withDuration: 0.3, animations: {
//            self.viewGreeting.alpha = 1.0
//
//            self.view.layoutIfNeeded()
//
//        })
    }
    
    @objc private func moveToTabBar(){
        self.performSegue(withIdentifier: Text.Segue.signUpConfirmToInterest, sender: nil)
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
