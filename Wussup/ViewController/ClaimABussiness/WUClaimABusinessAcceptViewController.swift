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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func setUpUIView() {
        self.buttonBack.isSelected = false
//        self.textViewBusiness.contentInset = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)

        if #available(iOS 11.0, *){
            self.viewLabelHeader.layer.cornerRadius = 12
            self.viewLabelHeader.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }else{
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
    private func callWS_VenueClaim(){
        WEB_API.call_api_VenueClaim(user: Utill.getUserModel()!, strFourSquareID: self.dictTextField[Text.DictKeys.venueFourSquareID]!, strVenueName: self.dictTextField[Text.DictKeys.venueName]!, emailId: self.dictTextField[Text.DictKeys.emailAddress]!, phoneNo: self.dictTextField[Text.DictKeys.mobileNumber]!){ (response, status, message) in
            if status == true{
                Utill.showAlert_OK_ViewForTabManage(viewController: self, message: Text.Message.msg_CAB_SucessFully, completion: { (sucess) in
                    if sucess == true {
                        if let vc = UIStoryboard.userProfile.get(WUProfileThankViewController.self){
                            vc.isFromCAB = true
                            vc.dictTextField = self.dictTextField
                            if self.claimVenue != nil{
                                vc.claimVenue = self.claimVenue
                            }
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                })
            }else{
                Utill.showAlertView(viewController: self, message: message)
            }
        }
    }
    
    // MARK: - Action Methods
    @IBAction func buttonBackAction(_ sender: Any) {
        self.view.endEditing(true)
        self.buttonBack.isSelected = true
        self.buttonBack.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Back, color: .GreenColor ), for: .normal)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonAcceptCheckBoxAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            self.buttonAcceptCheckBox.isSelected = true
        }else{
            self.buttonAcceptCheckBox.isSelected = false
        }
    }
    
    @IBAction func buttonAcceptAction(_ sender: Any) {
        if self.buttonAcceptCheckBox.isSelected == true{
            self.callWS_VenueClaim()
        }else {
            Utill.showAlertView(viewController: self, message: "Please agree with terms and conditions")
        }
    }
}
