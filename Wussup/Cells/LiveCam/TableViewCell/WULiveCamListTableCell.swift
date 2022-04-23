//
//  WULiveCamListTableCell.swift
//  Wussup
//
//  Created by MAC219 on 7/27/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class WULiveCamListTableCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet private weak var viewContainer        : UIView!
    @IBOutlet private weak var imageViewIcon        : UIImageView!
    @IBOutlet private weak var labelTitle           : UILabel!
    @IBOutlet private weak var labelSubTitleAddress     : UILabel!
    
    // MARK: - Variables
    weak var delegate : WUFavoriteDateRangeTableCellDelegate?
    
    // MARK: - Variables
    var  liveCamVenue: [String : Any]!{
        didSet{
            self.setCellDetailForLiveCam()
        }
    }
//    var  liveCamVenue: WUVenueLiveCams!{
//        didSet{
//            self.setCellDetailForLiveCam()
//        }
//    }
    
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInterfaceSetUp()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Initial Interface SetUp
    
    private func initialInterfaceSetUp() {
        self.viewContainer.dropShadow(color: .lightGray, opacity: 1.0, offSet: CGSize(width: 0.0, height: 2.0), radius: 1.0, scale: true)
    }
    
    private func setCellDetailForLiveCam(){
//        self.imageViewIcon.sd_setIndicatorStyle(.white)
//        self.imageViewIcon.sd_setShowActivityIndicatorView(true)
        self.imageViewIcon.sd_imageIndicator = SDWebImageActivityIndicator.white
      
                if let youtubeURL = self.liveCamVenue["url"] as? String, youtubeURL != "" {
                    let fullNameArr = youtubeURL.split(separator: "=")
                    var firstName: String = String(fullNameArr[0])
                    var youtubeId: String = String(fullNameArr[1])
                    print(youtubeId)
                    let thumbnilURl = "http://img.youtube.com/vi/\(youtubeId)/0.jpg"
                    print(thumbnilURl)
        //            if let streamOptions = self.liveCamVenue["url"] as? String {
                        self.imageViewIcon.sd_setImage(with: URL(string: thumbnilURl), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: .refreshCached)
                //    }
                    Utill.hideProgressHud()
                }
//        self.imageViewIcon.sd_setImage(with: URL(string: self.liveCamVenue.ImageURL), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: .refreshCached)
        self.labelTitle.text = self.liveCamVenue["name"] as? String
     //   self.labelSubTitleAddress.text = self.liveCamVenue.Description
    }
}
