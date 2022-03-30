//
//  WUCreateProfileViewController.swift
//  Wussup
//
//  Created by MAC26 on 27/06/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUCreateProfileViewController: UIViewController {

    @IBOutlet private weak var viewMiddle: UIView!
    @IBOutlet private weak var buttonContinue: UIButton!
    @IBOutlet private weak var imageViewBeeGif          : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefault.bool(forKey: Text.UDKeys.isFromSignUp) == true{
            if UserDefault.bool(forKey: Text.UDKeys.isCreateProfileViewed) == true {
                self.navigationController?.setViewControllers([(self.storyboard?.get(WUProfileViewController.self))!], animated: false)
            }else{
                self.buttonContinue.layer.borderColor = UIColor.GreenColor.cgColor
                self.buttonContinue.isSelected = false
            }
        }
        else{
            self.navigationController?.setViewControllers([(self.storyboard?.get(WUProfileViewController.self))!], animated: false)
            
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewMiddle.backgroundColor = .DarkGrayColor
        Utill.loadBeeGif(imageView: self.imageViewBeeGif)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Methods
    @IBAction func buttonBackAction(_ sender: Any) {
        (self.tabBarController as! WUTabbarViewController).selectIndexForTabbar(selectedIndex: .Home)
    }
    @IBAction func buttonContinueAction(_ sender: UIButton) {
        UserDefault.set(true, forKey: Text.UDKeys.isCreateProfileViewed)
        UserDefault.synchronize()
        self.buttonContinue.layer.borderColor = UIColor.SearchBarYellowColor.cgColor
        self.buttonContinue.isSelected = true
        self.performSegue(withIdentifier: Text.Segue.continueToProfileVC, sender: nil)
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
