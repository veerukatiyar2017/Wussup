//
//  WUEventCollectionCell.swift
//  Wussup
//
//  Created by MAC219 on 5/23/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WUEventCollectionCellDelegate : class {
    func eventCollectionLiveCamButtonClicked(cell : WUEventCollectionCell, withEvent event : WUEvent)
}

extension WUEventCollectionCellDelegate{
    func eventCollectionLiveCamButtonClicked(cell : WUEventCollectionCell, withEvent event : WUEvent){
        
    }
}

class WUEventCollectionCell: UICollectionViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var viewDescriptionContainer : UIView!
    @IBOutlet private weak var viewContainer            : UIView!
    @IBOutlet private weak var imageViewCoverPhoto      : UIImageView!
    @IBOutlet private weak var buttonVideo              : UIButton!
    @IBOutlet private weak var labelMainTitle           : UILabel!
    @IBOutlet private weak var labelDayTime             : UILabel!
    @IBOutlet private weak var labelDescription         : UILabel!
    
    @IBOutlet weak var labelMonth                      : UILabel!
    @IBOutlet weak var labelDate                       : UILabel!
    @IBOutlet weak var lebelEndMonth: UILabel!
    @IBOutlet weak var lebelEndDate: UILabel!
    @IBOutlet weak var endDateStackView: UIStackView!
    @IBOutlet weak var centerMonthLabel: UILabel!
    
    @IBOutlet weak var viewBg: UIView!
    weak var delegate : WUEventCollectionCellDelegate?
    var event : WUEvent!{
        didSet{
            self.setCellDetail()
        }
    }
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initialInterfaceSetUp()
    }
    
    //MARK: - Initial Interface SetUp
    private func initialInterfaceSetUp() {
        self.viewDescriptionContainer.dropShadow(color: .lightGray,
                                                 opacity: 1.0,
                                                 offSet: CGSize(width: 0.0, height: 4.0), radius: 4.0, scale: true)
        
    }
    
    private func setCellDetail() {
        self.buttonVideo.isHidden = true
        if self.event.LiveCamsURL.count > 0 {
            self.buttonVideo.isHidden = false
        }
        self.imageViewCoverPhoto.sd_setShowActivityIndicatorView(true)
        self.imageViewCoverPhoto.sd_setIndicatorStyle(.white)
        self.imageViewCoverPhoto.sd_setImage(with:URL(string:self.event.ConverPhotoURL),
                                             placeholderImage: UIImage(named:"placeholder.png" ))
        self.labelMainTitle.text = event.Name
        self.labelDescription.text = self.event.Description
        
        var startDate = Date.stringFromCustomDate(fromDate: Date.dateObjectNotUTC(dateStr: self.event.StartDate)!,
                                                           withFormat: "hh:mm a")
        
        var endDate = Date.stringFromCustomDate(fromDate: Date.dateObjectNotUTC(dateStr: self.event.EndDate)!,
                                                  withFormat: "hh:mm a")
        
        if startDate.first == "0" {
            startDate.removeFirst()
        }

        if endDate.first == "0" {
            endDate.removeFirst()
        }
        
        self.labelDayTime.text = "\(startDate) - \(endDate)"
    }
    
    //MARK: - Action Methods
    @IBAction func buttonVideoAction(_ sender: Any) {
        if let delegate = self.delegate{
            delegate.eventCollectionLiveCamButtonClicked(cell: self, withEvent: self.event)
        }
    }
}




