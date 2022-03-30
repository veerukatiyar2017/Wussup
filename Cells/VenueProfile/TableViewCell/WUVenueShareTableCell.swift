//
//  WUVenueShareTableCell.swift
//  Wussup
//
//  Created by MAC219 on 5/10/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUVenueShareTableCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var viewContainer    : UIView!
    @IBOutlet  weak var imageViewShare          : UIImageView!
    @IBOutlet private weak var buttonShare      : UIButton!
    @IBOutlet weak var viewSeparator            : UIView!
    
    weak var delegate : WUVenueProfileTableCellDelegate?
   
    
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
        self.viewContainer.dropShadow()
    }

    //MARK: - Action Method
    @IBAction func buttonShareAction(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.venueShareButton(cell: self, didSelectShareButton: sender)
        }
    }
}
