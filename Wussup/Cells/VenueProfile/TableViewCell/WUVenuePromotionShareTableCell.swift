//
//  WUVenuePromotionShareTableCell.swift
//  Wussup
//
//  Created by MAC219 on 5/10/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - Delegate
protocol WUVenuePromotionShareTableCellDelegate : class{
    func venuePromotionShareButton(cell : UITableViewCell , didSelectShareButton button : UIButton , forIndex  index : Int)
}
extension WUVenuePromotionShareTableCellDelegate{
    func venuePromotionShareButton(cell : UITableViewCell , didSelectShareButton button : UIButton , forIndex  index : Int){
        
    }
}

class WUVenuePromotionShareTableCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var viewContainer: UIView!
    @IBOutlet private weak var tableViewPromotion: UITableView!
    weak var delegate : WUVenuePromotionShareTableCellDelegate?
    
    //MARK: - Load Methods
   var arrSharePromotion : [WUVenueLocalPromotions] = []{
        didSet{
            self.setDetail()
        }
    }
    
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
        self.tableViewPromotion.delegate = self
        self.tableViewPromotion.dataSource = self
        tableViewPromotion.estimatedRowHeight = 149.0
        tableViewPromotion.rowHeight = UITableViewAutomaticDimension
    }
    
    func setDetail(){
        self.tableViewPromotion.reloadData()
    }
}

//MARK: - TabelView
extension WUVenuePromotionShareTableCell : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSharePromotion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUVenueShareTableCell()), for: indexPath)as! WUVenueShareTableCell
        cell.delegate = self
        cell.imageViewShare.sd_imageIndicator = SDWebImageActivityIndicator.white
//        cell.imageViewShare.sd_setShowActivityIndicatorView(true)
//        cell.imageViewShare.sd_setIndicatorStyle(.white)
        cell.imageViewShare.sd_setImage(with: URL(string: self.arrSharePromotion[indexPath.row].ImageURL),
                                        placeholderImage: #imageLiteral(resourceName: "NullState_Banner"),
                                        options: .refreshCached)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        Utill.printInTOConsole(printData:"WUVenueLocalPromotions height : \(self.arrSharePromotion[indexPath.row].HeightFloat)")
        if (self.arrSharePromotion[indexPath.row].WidthFloat > 0)
        {
            if self.arrSharePromotion[indexPath.row].HeightFloat  == 0
            {
                return UITableViewAutomaticDimension
            }
            else {
                return (self.arrSharePromotion[indexPath.row].HeightFloat * (UIScreen.main.bounds.size.width)/self.arrSharePromotion[indexPath.row].WidthFloat) + 49
            }
        }
        return self.arrSharePromotion[indexPath.row].HeightFloat == 0 ? UITableViewAutomaticDimension : self.arrSharePromotion[indexPath.row].HeightFloat + 49
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.tableViewPromotion.frame = CGRect.init(x: 0, y: 0, width: targetSize.width, height: CGFloat(MAXFLOAT))
        self.tableViewPromotion.layoutSubviews()
        Utill.printInTOConsole(printData:"contentSize : \(self.tableViewPromotion.contentSize)")
        return CGSize(width: self.tableViewPromotion.contentSize.width, height: self.tableViewPromotion.contentSize.height+30)
    }
}

extension WUVenuePromotionShareTableCell : WUVenueProfileTableCellDelegate{
    func venueShareButton(cell: UITableViewCell, didSelectShareButton button: UIButton) {
        let indexPath = self.tableViewPromotion.indexPath(for: cell)
        if let delegate = self.delegate {
            delegate.venuePromotionShareButton(cell: self, didSelectShareButton: button, forIndex:(indexPath?.row)!)
        }
    }
}

