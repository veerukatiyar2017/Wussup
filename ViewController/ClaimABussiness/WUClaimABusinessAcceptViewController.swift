//
//  WUClaimABusinessAcceptViewController.swift
//  Wussup
//
//  Created by MAC219 on 8/1/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUClaimABusinessAcceptViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var viewLabelHeader      : UIView!
    @IBOutlet private weak var textViewBusiness     : UITextView!
    @IBOutlet private weak var viewLabelFooter      : UIView!
    @IBOutlet private weak var buttonAcceptCheckBox : UIButton!
    @IBOutlet private weak var labelTermsAndCondi   : UILabel!
    @IBOutlet private weak var buttonAccept         : UIButton!
    @IBOutlet private weak var buttonBack           : UIButton!
    
    var typeTransition                              : TypeTransition = .banner

    enum TypeTransition: Int {
        case foursquare = 0
        case banner
    }
    
    // MARK: - Variables
    var dictTextField : [String : String] = [:]
    var claimVenue : Any!
   
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUIView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("LayOut SubView")
        self.textViewBusiness.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    // MARK: - Initial Setup
    private func setUpUIView()
    {
        self.buttonBack.isSelected = false
        self.buttonAcceptCheckBox.isSelected = false

//        self.textViewBusiness.contentInset = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
        
        self.textViewBusiness.text = Text.TextView.text_termsOfUse
        
        if #available(iOS 11.0, *) {
            self.viewLabelHeader.layer.cornerRadius = 12
            self.viewLabelHeader.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
        } else {
            let rectShape = CAShapeLayer()
            rectShape.path = UIBezierPath(roundedRect: self.viewLabelHeader.bounds,byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 12, height: 12)).cgPath
            self.viewLabelHeader.layer.mask = rectShape
        }
        
        if #available(iOS 11.0, *){
            self.viewLabelFooter.layer.cornerRadius = 12
            self.viewLabelFooter.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.path = UIBezierPath(roundedRect: self.viewLabelFooter.bounds,byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 12, height: 12)).cgPath
            self.viewLabelFooter.layer.mask = rectShape
        }

        self.labelTermsAndCondi.attributedText = attributedText(withString: Text.Label.text_byChecking, boldString: Text.Label.text_legal_official, font: UIFont.ProximaNovaBold(11.0.propotional)!)
    }
    
   
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedStringKey.font: UIFont.ProximaNovaRegular(11.0.propotional)])
        let boldFontAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    // MARK: - Webservice Methods
//    private func callWS_VenueClaim()
//    {
//        guard let user = Utill.getUserModel() else { return }
//
//        var fourSquareID = ""
//        var venueName = ""
//
//        switch self.typeTransition {
//        case .foursquare:
//            fourSquareID = (self.claimVenue as! WUVenue).FourSquareVenueID
//            venueName = (self.claimVenue as! WUVenue).VenueName
//            break
//
//        case .banner:
//            fourSquareID = self.dictTextField[Text.DictKeys.venueFourSquareID]!
//            venueName = self.dictTextField[Text.DictKeys.venueName]!
//        }
//
//        WEB_API.call_api_VenueClaim(user: user,
//                                    fourSquareID: fourSquareID,
//                                    venueName: venueName)
//        { (response, status, message) in
//
//            if status == true {
//                Utill.showAlert_OK_ViewForTabManage(viewController: self,
//                                                    message: Text.Message.msg_CAB_SucessFully,
//                                                    completion: { (sucess) in
//
//                                                        if sucess == true {
//                                                            if let vc = UIStoryboard.userProfile.get(WUProfileThankViewController.self){
//                                                                vc.isFromCAB = true
//                                                                vc.dictTextField = self.dictTextField
//
//                                                                if self.claimVenue != nil {
//                                                                    vc.claimVenue = self.claimVenue
//                                                                }
//                                                                self.navigationController?.pushViewController(vc, animated: true)
//                                                            }
//                                                        }
//                })
//            } else {
//                Utill.showAlertView(viewController: self, message: message)
//            }
//        }
//    }
    
    // MARK: - Action Methods
    @IBAction func buttonBackAction(_ sender: Any)
    {
        self.view.endEditing(true)
        self.buttonBack.isSelected = true
        self.buttonBack.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Back,
                                                                                  color: .GreenColor ), for: .normal)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonAcceptCheckBoxAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true {
            self.buttonAcceptCheckBox.isSelected = true
        } else {
            self.buttonAcceptCheckBox.isSelected = false
        }
    }
    
    @IBAction func buttonAcceptAction(_ sender: Any)
    {
        if self.buttonAcceptCheckBox.isSelected == true {
            
            self.navigationController?.popToRootViewController(animated: true)
            self.openWebViewPage()

           // self.callWS_VenueClaim()
            
        } else {
            Utill.showAlertView(viewController: self, message: "Please agree with terms and conditions")
        }
    }
    
    func openWebViewPage()
    {
        guard let user = Utill.getUserModel() else { return }
        
        var fourSquareID = ""
        var url = ""
        
        switch self.typeTransition {
            
        case .foursquare:
            fourSquareID = (self.claimVenue as! WUVenue).FourSquareVenueID
            url = API_URL_ADMIN + "\(user.UID)" + "&venueid=" + "\(fourSquareID)"
            //example1 https://biz.arvzapp.com/account/signup?id=a8ebe41589bc41e99ca2e16ce24497d1&venueid=52e83b0211d23cbbe68d1e78
            break
            
        case .banner:
            fourSquareID = self.dictTextField[Text.DictKeys.venueFourSquareID]!
            
            if fourSquareID == "" { //user entered the name manually
                var venueName = self.dictTextField[Text.DictKeys.venueName]!
                venueName = venueName.replacingOccurrences(of: " ", with: "%20")
                url = API_URL_ADMIN + "\(user.UID)" + "&venuename=" + "\(venueName)"
                //example2 https://biz.arvzapp.com/account/signup?id=a8ebe41589bc41e99ca2e16ce24497d1&venuename=ffff
                
            } else { //the user entered the name manually and selected from the list
                url = API_URL_ADMIN + "\(user.UID)" + "&venueid=" + "\(fourSquareID)"
                //example1 https://biz.arvzapp.com/account/signup?id=a8ebe41589bc41e99ca2e16ce24497d1&venueid=52e83b0211d23cbbe68d1e78
            }
        }
        UIApplication.shared.open(URL(string: url)!,
                                  options: [:],
                                  completionHandler: nil)
    }
}
