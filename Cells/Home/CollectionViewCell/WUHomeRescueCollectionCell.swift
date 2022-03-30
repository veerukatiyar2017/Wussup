//
//  WUHomeRescueCollectionCell.swift
//  Wussup
//
//  Created by MAC219 on 4/23/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUHomeRescueCollectionCell: UICollectionViewCell {
    
    @IBOutlet private weak var labelStatus      : UILabel!
    @IBOutlet private weak var labelDiscription : UILabel!
    @IBOutlet private weak var imageViewRescue  : UIImageView!
    
    var collectionVenue : WUVenue! {
        didSet{
            self.setCellDetail(collectionVenue: self.collectionVenue)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Initial Interface SetUp
    
    private  func initialInterfaceSetUp() {
        
    }
    
    private func setCellDetail(collectionVenue :WUVenue) {
        self.labelStatus.text = collectionVenue.title
        self.labelDiscription.text  = collectionVenue.title
        //Static Image
        //        self.imageViewRescue.image = UIImage(named: collectionVenue.image)
        
        //Image comes from Url
        self.imageViewRescue.sd_setShowActivityIndicatorView(true)
        self.imageViewRescue.sd_setIndicatorStyle(.white)
        self.imageViewRescue.sd_setImage(with:URL(string:collectionVenue.imageUrl) , placeholderImage: UIImage(named:"placeholder.png" ))
    }
}
