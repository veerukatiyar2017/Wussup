//
//  WUProfileThankViewController.swift
//  Wussup
//
//  Created by MAC26 on 06/07/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUProfileThankViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var viewMiddle       : UIView!
    @IBOutlet private weak var labelName        : UILabel!
    @IBOutlet private weak var labelViewDetail  : UILabel!
    @IBOutlet private weak var viewBottomCAB    : UIView!
    @IBOutlet private weak var labelEmail       : UILabel!
    @IBOutlet private weak var viewBottomProfile: UIView!
    @IBOutlet private weak var imageViewBeeGif          : UIImageView!

    
    //MARK: - Variable
   var dictTextField : [String : String] = [:]
    var isFromCAB : Bool = false
    var claimVenue : Any!
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetup() {
        Utill.loadBeeGif(imageView: self.imageViewBeeGif)
        self.viewMiddle.backgroundColor = .DarkGrayColor
        self.viewBottomCAB.isHidden = true
        self.viewBottomProfile.isHidden = true
        
        if isFromCAB == true {
            self.labelName.text =  dictTextField[Text.DictKeys.venueName]//GlobalShared.user.UserName
            self.labelViewDetail.text = Text.Label.text_CABViewDetail_ThankYouVC
            self.viewBottomCAB.isHidden = false
            self.labelEmail.text = dictTextField[Text.DictKeys.emailAddress]
        }else{
            self.labelViewDetail.text = Text.Label.text_ProfileUpdated
            if GlobalShared.user.FacebookID != ""{
                 self.labelName.text = GlobalShared.user.Email.count > 0 ? GlobalShared.user.Email : Text.Label.text_LoggedWithFacebook
            }else {
              self.labelName.text = GlobalShared.user.UserName.count > 0 ? GlobalShared.user.UserName : GlobalShared.user.Email
            }
            self.viewBottomProfile.isHidden = false
        }
    }
    
    // MARK: - Action Methods
    @IBAction func buttonOkAction(_ sender: UIButton)
    {
        if isFromCAB == true {
            
            if self.dictTextField[Text.DictKeys.venueFourSquareID] != "" {
                
                self.navigationController?.popToRootViewController(animated: true)

//                if let vc = UIStoryboard.home.get(WUClaimABusinessDetailViewController.self){
//                    vc.fourSquareVenueId = self.dictTextField[Text.DictKeys.venueFourSquareID]!
////                    vc.labelNavigationTitle.text = self.dictTextField[Text.DictKeys.venueName]!
//                    vc.sponsoredVenuID = "0"
//                    vc.isScreenFromThankYouOfCAB = true
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
            } else {
                self.manageOkFlowWhenFourceIdIsNotGetting()
            }
        } else {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func manageOkFlowWhenFourceIdIsNotGetting(){
        for controller in self.navigationController!.viewControllers.reversed() as Array {
            if controller.isKind(of: WUHomeSearchViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            else if controller.isKind(of: WUHomeViewAllViewController.self)
            {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            else if controller.isKind(of: WUHomeViewController.self){
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        self.navigationController?.popViewController(animated: true)
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
