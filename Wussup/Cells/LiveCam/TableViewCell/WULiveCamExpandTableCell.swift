//
//  WULiveCamExpandTableCell.swift
//  Wussup
//
//  Created by MAC219 on 7/17/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - Delegate
protocol WULiveCamExpandTableCellDelegate : class {
    func expandTableCellLiveCamPlayButtonClicked(cell : WULiveCamExpandTableCell, withLiveCam obj : WUVenueLiveCams)
}
extension WULiveCamExpandTableCellDelegate{
    func expandTableCellLiveCamPlayButtonClicked(cell : WULiveCamExpandTableCell, withLiveCam obj : WUVenueLiveCams){
        
    }
}

class WULiveCamExpandTableCell: UITableViewCell {

    @IBOutlet private weak var imageViewIcon    : UIImageView!
    @IBOutlet private weak var buttonPlay       : UIButton!
    @IBOutlet private weak var labelTitle       : UILabel!
    
    // MARK: - Variables
    weak var delegate : WULiveCamExpandTableCellDelegate?
    
    var  liveCamVenue: [String: Any]!{
        didSet{
            self.setCellDetail()
        }
    }
//    var  liveCamVenue: WUVenueLiveCams!{
//        didSet{
//            self.setCellDetail()
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInterfaceSetUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: - Initial Interface SetUp
    
    private func initialInterfaceSetUp() {
       self.labelTitle.textColor = UIColor.white
    }
    
    private func setCellDetail(){
        self.imageViewIcon.sd_imageIndicator = SDWebImageActivityIndicator.white
//        self.imageViewIcon.sd_setIndicatorStyle(.white)
//        self.imageViewIcon.sd_setShowActivityIndicatorView(true)
        print(self.liveCamVenue["url"])
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
        }
   
//        self.imageViewIcon.sd_setImage(with: URL(string: self.liveCamVenue["imageUrl"] as! String), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: .refreshCached)
        self.labelTitle.text = self.liveCamVenue["name"] as! String
    }
    
    @IBAction func buttonPlayAction(_ sender: Any) {
        if let delegate = self.delegate {
          //  delegate.expandTableCellLiveCamPlayButtonClicked(cell: self, withLiveCam: self.liveCamVenue)
        }
    }
}
