//
//  WUFavoriteListTableCell.swift
//  Wussup
//
//  Created by MAC219 on 7/27/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class WUFavoriteListTableCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet private weak var viewContainer        : UIView!
    @IBOutlet private weak var imageViewIcon        : UIImageView!
    @IBOutlet private weak var labelTitle           : UILabel!
    @IBOutlet weak var viewDropShadow: UIView!
    // MARK: - Variables
    weak var delegate : WUFavoriteDateRangeTableCellDelegate?
    
    // MARK: - Variables
    var  favoriteVenue: WUVenueDetail!{
        didSet{
            self.setCellDetail()
        }
    }
   
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
        self.viewContainer.dropShadow(color: .lightGray, opacity: 1.0, offSet: CGSize(width: 0.0, height: 1.5), radius: 1.2, scale: true)
        self.viewDropShadow.dropShadow(color: .gray, opacity: 1.0, offSet: CGSize(width: 0.0, height: 2.0), radius: 1.5, scale: true)
    }
    
    private func setCellDetail(){
        self.imageViewIcon.sd_setShowActivityIndicatorView(true)
        self.imageViewIcon.sd_setIndicatorStyle(.white)
//        self.imageViewIcon.sd_setImage(with: URL(string:self.favoriteVenue.VenueCoverPhoto.SquareImage.count > 0 ? self.favoriteVenue.VenueCoverPhoto.SquareImage : self.favoriteVenue.VenueCoverPhoto.RactangleImage ), placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto") , options: [SDWebImageOptions.cacheMemoryOnly])
        self.imageViewIcon.sd_setImage(with: URL(string:self.favoriteVenue.SelectedImageURL), placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto") , options: [SDWebImageOptions.cacheMemoryOnly])
        self.labelTitle.text = self.favoriteVenue.VenueName.uppercased()
    }
   
}
