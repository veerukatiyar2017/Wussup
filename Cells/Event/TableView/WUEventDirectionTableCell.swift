//
//  WUEventDirectionTableCell.swift
//  Wussup
//
//  Created by MAC219 on 5/28/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage


class WUEventDirectionTableCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var viewContainer        : UIView!
    @IBOutlet private weak var imageViewMap         : UIImageView!
    @IBOutlet private weak var buttonDistance       : UIButton!
    @IBOutlet private weak var viewButtons          : UIView!
    @IBOutlet private weak var labelAddress         : UILabel!
    @IBOutlet private weak var labelTitle           : UILabel!
    @IBOutlet private weak var buttonClose          : UIButton!
    @IBOutlet private weak var viewContainerBottom  : NSLayoutConstraint!
    @IBOutlet private weak var viewButtonHeight     : NSLayoutConstraint!
    @IBOutlet private weak var viewSeparatorHeight  : NSLayoutConstraint!
    weak var delegate : WUVenueProfileTableCellDelegate?
    
    var eventDirection : WUEventDirectionDetail!{
        didSet{
            self.setDirectionDetail()
        }
    }
    
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        initialInterfaceSetUp()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Initial Interface SetUp
    private func initialInterfaceSetUp() {
        self.viewContainer.dropShadow()
        self.buttonClose.semanticContentAttribute = .forceRightToLeft
    }
    
    private func setDirectionDetail(){
        self.mangeConstraints(isExpanded: false)
        if self.eventDirection.isExpanded == true{
            self.mangeConstraints(isExpanded: true)
        }
         self.buttonDistance.backgroundColor = UIColor.buttonDistanceColor
        self.buttonDistance.setTitle(NSString(format: "%0.2f Mi", Float(self.eventDirection.Distance) ?? 0) as String, for:.normal)
        print("////////WUEventDirectionTableCell = Distance - \(self.eventDirection.Distance)")

        if self.eventDirection.FullAddress != "" {
//            let arr = self.eventDirection.FullAddress.components(separatedBy: " ")
            self.labelTitle.text = ""
            self.labelTitle.isHidden = true
//            let arrAdd = arr.dropFirst()
            self.labelAddress.text = self.eventDirection.FullAddress
        }
        
        var strUrl = Utill.getMapUrl(pinImageUrl: self.eventDirection.MapPinImageUrl, latitute: self.eventDirection.Latitude, longtitude: self.eventDirection.Longitude, size: CGSize(width: 350, height: 130))
        
        if URL(string: strUrl) == nil {
            strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        
        self.imageViewMap.sd_setShowActivityIndicatorView(true)
        self.imageViewMap.sd_setIndicatorStyle(.white)
        self.imageViewMap.sd_setImage(with: URL(string: strUrl), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
    }
    
    private func mangeConstraints(isExpanded : Bool){
        if isExpanded == true{
            self.viewContainerBottom.constant   = 30.0
            self.viewButtonHeight.constant      = 50.0
            self.viewSeparatorHeight.constant   = 1.0
        }else{
            self.viewContainerBottom.constant   = 0.0
            self.viewButtonHeight.constant      = 0.0
            self.viewSeparatorHeight.constant   = 0.0
        }
    }
    // MARK: - Action Methods
    @IBAction func buttonCloseAction(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.venueCloseButton(cell: self, didSelectCloseButton: sender)
        }
    }
    
    @IBAction func buttonDistanceAction(_ sender: UIButton) {
        
    }
}
