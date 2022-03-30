//
//  WUClaimABussinessAcceptView.swift
//  Wussup
//
//  Created by MAC219 on 7/30/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUClaimABussinessAcceptView: UIView {

    @IBOutlet private weak var viewContainer        : UIView!
    @IBOutlet private weak var viewConfirmClaim     : UIView!
    @IBOutlet private weak var viewAcceptButton     : UIView!
    @IBOutlet private weak var buttonClose          : UIButton!
    @IBOutlet private weak var buttonAccept         : UIButton!
    
   
    //MARK: - Load Methods
    override func awakeFromNib() {
        self.initialInterfaceSetUp()
    }
    
    class func instanceFromNib() -> WUClaimABussinessAcceptView {
        return UINib(nibName: Utill.getClassNameFor(classType: WUClaimABussinessAcceptView()), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WUClaimABussinessAcceptView
    }
    
    private func initialInterfaceSetUp() {
        
        self.viewConfirmClaim.backgroundColor = UIColor.SearchBarYellowColor
        
        if #available(iOS 11.0, *){
            self.viewConfirmClaim.layer.cornerRadius = 15
            self.viewConfirmClaim.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.viewConfirmClaim.frame
            rectShape.path = UIBezierPath(roundedRect: self.viewConfirmClaim.bounds,    byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 12, height: 12)).cgPath
            self.viewConfirmClaim.layer.mask = rectShape
        }
        if #available(iOS 11.0, *){
            self.viewAcceptButton.layer.cornerRadius = 15
            self.viewAcceptButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.viewAcceptButton.frame
            rectShape.path = UIBezierPath(roundedRect: self.viewAcceptButton.bounds,    byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 12, height: 12)).cgPath
            self.viewAcceptButton.layer.mask = rectShape
        }
    }
    
    //MARK: - animation
    func showInView(superView : UIView) {
        self.initialInterfaceSetUp()
        self.frame = UIScreen.main.bounds
        superView.addSubview(self)
        self.alpha = 0.0
        self.transform = (self.transform).scaledBy(x: 1/1.3, y: 1/1.3)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .beginFromCurrentState] , animations: {
            self.transform = (self.transform).scaledBy(x: 1.3, y: 1.3)
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func removeFromView()  {
        self.alpha = 1.0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn, .beginFromCurrentState] , animations: {
            self.transform = (self.transform).scaledBy(x: 1/1.3, y: 1/1.3)
            self.alpha = 0
        }, completion: { (finished: Bool) -> Void in
            self.removeFromSuperview()
            self.transform = (self.transform).scaledBy(x:1.3, y: 1.3)
        })
        
    }
    
    //MARK: - Action Methods
    @IBAction func buttonCloseAction(_ sender: Any) {
//        if let delegate = self.delegate {
//            delegate.venueRateCancel(didSelectCancelButton: sender)
//        }
        self.removeFromView()
    }
    
    @IBAction func buttonAcceptAction(_ sender: Any) {
//        if let delegate = self.delegate {
//            delegate.venueRateCancel(didSelectCancelButton: sender)
//        }
        self.removeFromView()
    }
    
}
