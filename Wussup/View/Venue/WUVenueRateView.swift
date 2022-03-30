//
//  WUVenueRateView.swift
//  Wussup
//
//  Created by MAC219 on 5/15/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol  WUVenueRateDelegate : class {
    func venueRateCancel(didSelectCancelButton : UIButton)
    func venueRateConfirm(didSelectConfirmButton : UIButton, withRatings rating : Int)
}
extension WUVenueRateDelegate {
    func venueRateCancel(didSelectCancelButton : UIButton){
        
    }
    func venueRateConfirm(didSelectConfirmButton : UIButton, withRatings rating : Int){
        
    }
}

class WUVenueRateView: UIView {
    //MARK: - IBOutlet
    @IBOutlet private weak var viewContainer    : UIView!
    @IBOutlet private weak var viewLabel        : UIView!
    @IBOutlet private weak var viewStar         : UIView!
    @IBOutlet private weak var viewStarRating   : DXStarRatingView!
    @IBOutlet private weak var buttonCancel     : UIButton!
    @IBOutlet private weak var buttonConfirm    : UIButton!
    
     //MARK: - Variable
    var venueDetail : WUVenueDetail!
    weak var delegate : WUVenueRateDelegate?
    var rating : Int = 0 {
        didSet{
            //self.setDetail()
        }
    }
    //MARK: - Load Methods
    override func awakeFromNib() {
        self.initialInterfaceSetUp()
    }
    
    class func instanceFromNib() -> WUVenueRateView {
        return UINib(nibName: Utill.getClassNameFor(classType: WUVenueRateView()), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WUVenueRateView
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        self.viewContainer.dropShadow()
        let maskLayer = CAShapeLayer()
        let pathViewLabel = UIBezierPath(roundedRect:self.viewLabel.bounds,
                                         byRoundingCorners:[.topRight, .topLeft],
                                         cornerRadii: CGSize(width: 10, height:  10))
        maskLayer.path = pathViewLabel.cgPath
        self.viewLabel.layer.mask = maskLayer
        
        let maskLayer1 = CAShapeLayer()
        let pathViewStar = UIBezierPath(roundedRect:self.viewStar.bounds,
                                        byRoundingCorners:[.bottomRight, .bottomLeft],
                                        cornerRadii: CGSize(width: 10, height:  10))
        maskLayer1.path = pathViewStar.cgPath
        self.viewStar.layer.mask = maskLayer1
        self.viewStarRating.isSetRedStarImageIcons = true
        self.setDetail()
    }
    
    private func setDetail(){
        self.viewStarRating.setStars(Int32(self.rating) , target: self, callbackAction:  #selector(didChangeRating(_newRating:)))
        if self.rating == 0{
            self.buttonConfirm.isEnabled = false
        }else{
            self.buttonConfirm.isEnabled = false
            self.viewStarRating.isUserInteractionEnabled = false
        }
    }
    
    @objc func didChangeRating(_newRating: NSNumber?) {
         Utill.printInTOConsole(printData:"didChangeRating: \(_newRating ?? 0)")
        self.rating = Int(truncating: _newRating ?? 0)
        if self.rating > 0{
            self.buttonConfirm.isEnabled = true
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
    
    //MARK: - WebService Call
    private func callWS_rateVenue(ratingCount : Int, withCompletion completion: @escaping (Bool)-> Void){
        WEB_API.call_api_RateVenue(user: GlobalShared.user , venueDetail: self.venueDetail, rating: ratingCount) { (response, success, message) in
            Utill.printInTOConsole(printData:"response: \(response ?? "")")
            if success == true{
                self.venueDetail.UserVenueRating = response!["UserVenueRating"].stringValue
                self.venueDetail.VenueRating = response!["VenueRating"].stringValue
                self.venueDetail.NoOfUserGiveVenueRating = response!["NoOfUserGiveVenueRating"].stringValue
            }
            completion(success)
        }
    }
    
    //MARK: - Action Methods
    @IBAction func buttonCancelAction(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.venueRateCancel(didSelectCancelButton: sender)
        }
        self.removeFromView()
    }
    
    @IBAction func buttonConfirmAction(_ sender: UIButton) {
        if self.rating > 0{
            self.callWS_rateVenue(ratingCount: self.rating) { (sucess) in
                if sucess == true{
                    if let delegate = self.delegate {
                        delegate.venueRateConfirm(didSelectConfirmButton: sender, withRatings: self.rating)
                    }
                }
                self.removeFromView()
            }
        }
    }
}
