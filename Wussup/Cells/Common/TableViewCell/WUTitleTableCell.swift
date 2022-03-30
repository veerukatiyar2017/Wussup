//
//  WUTitleTableCell.swift
//  Wussup
//
//  Created by MAC219 on 5/24/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUTitleTableCell: UITableViewCell {

   
    // MARK: - IBOutlets
    
    @IBOutlet weak var labelTitle: UILabel!
    
    // MARK: - Variables
    
    var searchText : String!
    var venueSuggestion : WUVenueSuggestion! {
        didSet{
            self.setCellDetail()
        }
    }
    
    var event : WUEvent!{
        didSet{
            self.setEventCellDetail()
        }
    }
    
    //MARK: - Load Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Initial Interface SetUp
    private func setCellDetail(){
        self.labelTitle.text = venueSuggestion.Name
        //        self.labelTitle.attributedText = Utill.filterAndModifyTextAttributes(searchStringCharacters: self.searchText, completeStringWithAttributedText: venueSuggestion.Name)
    }
    
    private func setEventCellDetail(){
        self.labelTitle.text = event.Name
        //        self.labelTitle.attributedText = Utill.filterAndModifyTextAttributes(searchStringCharacters: self.searchText, completeStringWithAttributedText: venueSuggestion.Name)
    }
    
}
