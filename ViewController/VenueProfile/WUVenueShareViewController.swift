//
//  WUVenueShareViewController.swift
//  Wussup
//
//  Created by MAC219 on 5/1/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class WUVenueShareViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var buttonGoToTop    : UIButton!
    @IBOutlet private weak var tableViewShare   : UITableView!
    
    // MARK: - Variable
    var venueShareDetail        : WUVenueDetail!
    private var arrShareOptions : [WUShareOptions] = []
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialInterfaceSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        self.buttonGoToTop.isHidden = true
        self.tableViewShare.contentInset = UIEdgeInsetsMake(0, 0, -20, 0)
        let headerNib = UINib.init(nibName:Utill.getClassNameFor(classType: WUVenueShareSectionHeaderView()), bundle: Bundle.main)
        self.tableViewShare.register(headerNib, forHeaderFooterViewReuseIdentifier: Utill.getClassNameFor(classType: WUVenueShareSectionHeaderView()))
        self.prepareArrayVenueProfileProperties()
    }
    
    private func prepareArrayVenueProfileProperties(){
        let shareSection1 = WUShareOptions(shareImage: self.venueShareDetail.VenueCoverPhoto.SquareImage, shareTitle:  "Share \(self.venueShareDetail.VenueName)")
        self.arrShareOptions.append(shareSection1)
        
        if self.venueShareDetail.Promotions.VenuePromotions.count > 0 {
            let shareSection2 = WUShareOptions(shareImage: "" , shareTitle:Text.Label.text_SharePromotion , arraySharePromotion:self.venueShareDetail.Promotions.VenuePromotions)
            self.arrShareOptions.append(shareSection2)
        }
        
        let shareSection3 = WUShareOptions(shareImage: "WussupBg", shareTitle: Text.Label.text_ShareApp)
        self.arrShareOptions.append(shareSection3)
    }
    
    // MARK: - Action Methods
    @IBAction func buttonBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.tableViewShare.setContentOffset(CGPoint.zero, animated: true)
    }
}

//MARK: - TableView
extension WUVenueShareViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Utill.getClassNameFor(classType: WUVenueShareSectionHeaderView())) as! WUVenueShareSectionHeaderView
        headerView.tag = section
        headerView.labelSectionTitle.text = self.arrShareOptions[section].shareTitle
        return headerView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UITableViewAutomaticDimension
        }else {
            return 45.0.propotionalHeight
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrShareOptions.count
        //        return 2 + (venueShareDetail.Promotions.VenuePromotions.count > 0 ? 1 : 0)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0{
            if (self.venueShareDetail.VenueCoverPhoto.WidthFloat > 0 ){
                if self.venueShareDetail.VenueCoverPhoto.HeightFloat == 0 {
                    return UITableViewAutomaticDimension
                }else {
                    return self.venueShareDetail.VenueCoverPhoto.HeightFloat * (UIScreen.main.bounds.size.width)/(self.venueShareDetail.VenueCoverPhoto.WidthFloat) + 49
                }
            }
             return self.venueShareDetail.VenueCoverPhoto.HeightFloat == 0 ? UITableViewAutomaticDimension : self.venueShareDetail.VenueCoverPhoto.HeightFloat + 49
        }else {
             return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.venueShareDetail.Promotions.VenuePromotions.count > 0 &&  indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier:Utill.getClassNameFor(classType: WUVenuePromotionShareTableCell()), for: indexPath)as! WUVenuePromotionShareTableCell
            cell.delegate = self
            cell.arrSharePromotion = self.arrShareOptions[indexPath.section].arraySharePromotion
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUVenueShareTableCell()), for: indexPath)as! WUVenueShareTableCell
            cell.imageViewShare.sd_setShowActivityIndicatorView(true)
            cell.imageViewShare.sd_setIndicatorStyle(.white)
            cell.imageViewShare.sd_setImage(with: URL(string: self.arrShareOptions[indexPath.section].shareImage), placeholderImage:#imageLiteral(resourceName: "WussupBg") , options: [SDWebImageOptions.cacheMemoryOnly])
            if indexPath.section == 0 {
                cell.imageViewShare.sd_setImage(with: URL(string: self.arrShareOptions[indexPath.section].shareImage), placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto") , options: [SDWebImageOptions.cacheMemoryOnly])
            }
            cell.delegate = self
            cell.viewSeparator.isHidden = false
            if indexPath.row == self.arrShareOptions.count - 1 {
                cell.viewSeparator.isHidden = true
            }
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
    }
}

//MARK: - Share Button Delegate
extension WUVenueShareViewController : WUVenueProfileTableCellDelegate{
    func venueShareButton(cell: UITableViewCell, didSelectShareButton button: UIButton) {
        
        let indexPath = self.tableViewShare.indexPath(for: cell)
        if indexPath?.section == self.arrShareOptions.count-1 {
            let text = Text.Message.msg_Deeplinking_Share_App
            let image = #imageLiteral(resourceName: "WussUpShareIcon")
            let webSite : URL = URL(string:APPSTORE_URL)!
          
            let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: image) as Any,
                                    WUShareActivityItemProvider(placeholderItem: "Ready to download ArvzApp?" ) as Any,
                                    WUShareActivityItemProvider(placeholderItem: text) as Any,
                                    WUShareActivityItemProvider(placeholderItem: "\n\(webSite)") as Any]
            
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            
            activityViewController.setValue("Ready to download ArvzApp?", forKey: "Subject")
            
            let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
            activityViewController.excludedActivityTypes = [.addToReadingList, .saveToCameraRoll, .copyToPasteboard, .assignToContact, .print,
                                                            activityTypeCloud, .airDrop]
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                if completed == true{
                    //Utill.showAlertView(viewController: self, message: Text.Message.applicationShareMsg)
                }
            }
        } else {
            WEB_API.call_api_GetShareLinkForVenueOrEvent(strVenueID: self.venueShareDetail.SponsoredVenuID,strFourSquareVenueID : self.venueShareDetail.FourSquareVenueID, strEventID: "", strLiveCamID: "") { (response, success, message) in
                if success == true{
                    let dicShare = response?.dictionary!
                    var coverPhotoURL = #imageLiteral(resourceName: "WussupBg")
                    if let cellFirst = self.tableViewShare.cellForRow(at: IndexPath(row: 0, section: 0)) as? WUVenueShareTableCell
                    {
                        coverPhotoURL = cellFirst.imageViewShare.image!
                    }
                    let shareText = dicShare!["ShareMessage"]?.string!
                    let shareLink = dicShare!["ShareLink"]?.string!
                    //let shareLink = "https://apps.arvzapp.com/venue/\(self.venueShareDetail.SponsoredVenuID)/FourSquareID/\(self.venueShareDetail.FourSquareVenueID)"
                    
                    let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: coverPhotoURL) as Any,
                                            WUShareActivityItemProvider(placeholderItem: "Check out this venue on ArvzApp!") as Any,
                                            WUShareActivityItemProvider(placeholderItem: "\nI found this venue on ArvzApp and wanted to share it!") as Any,
                                            WUShareActivityItemProvider(placeholderItem: "\nVenue Name : \(self.venueShareDetail.VenueName)") as Any,
                                            WUShareActivityItemProvider(placeholderItem: "\n\(shareLink ?? "https://apps.arvzapp.com/")") as Any]
                    
                    
                    let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                    activityViewController.setValue("Check out this venue on ArvzApp!", forKey: "Subject")

                    let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
                    activityViewController.excludedActivityTypes = [.addToReadingList, .saveToCameraRoll, .copyToPasteboard, .addToReadingList, .assignToContact, .print, activityTypeCloud, .airDrop]
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                    
                    activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                        if completed == true{
                            //Utill.showAlertView(viewController: self, message: Text.Message.venueShareMsg)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - WUVenuePromotionShareTableCellDelegate
extension WUVenueShareViewController : WUVenuePromotionShareTableCellDelegate{

    func venuePromotionShareButton(cell: UITableViewCell, didSelectShareButton button: UIButton, forIndex index: Int) {
        WEB_API.call_api_GetShareLinkForVenueOrEvent(strVenueID: self.venueShareDetail.SponsoredVenuID,strFourSquareVenueID : self.venueShareDetail.FourSquareVenueID, strEventID: "", strLiveCamID: "") { (response, success, message) in
            if success == true{
                let dicShare = response?.dictionary!
                var coverPhotoURL = #imageLiteral(resourceName: "WussupBg")
                if let cellFirst = self.tableViewShare.cellForRow(at: IndexPath(row: 0, section: 0)) as? WUVenueShareTableCell
                {
                    coverPhotoURL = cellFirst.imageViewShare.image!
                }
                let shareText = dicShare!["ShareMessage"]?.string!
                let shareLink = dicShare!["ShareLink"]?.string!
                //let shareLink = "https://apps.arvzapp.com/venue/\(self.venueShareDetail.SponsoredVenuID)/FourSquareID/\(self.venueShareDetail.FourSquareVenueID)"

                
                let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: coverPhotoURL) as Any,
                                        WUShareActivityItemProvider(placeholderItem: "Check out this venue on ArvzApp!") as Any,
                                        WUShareActivityItemProvider(placeholderItem: "\nI found this venue on ArvzApp and wanted to share it!") as Any,
                                        WUShareActivityItemProvider(placeholderItem: "\nVenue Name : \(self.venueShareDetail.VenueName)") as Any,
                                        WUShareActivityItemProvider(placeholderItem: "\n\(shareLink ?? "https://apps.arvzapp.com/")") as Any]
                
                
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                activityViewController.setValue("Check out this venue on ArvzApp!", forKey: "Subject")
                
                let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
                activityViewController.excludedActivityTypes = [.addToReadingList ,.saveToCameraRoll , .copyToPasteboard , .addToReadingList ,.assignToContact ,.print , activityTypeCloud, .airDrop]
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
                activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                    if completed == true{
                        //Utill.showAlertView(viewController: self, message: Text.Message.venueShareMsg)
                    }
                }
            }
        }
    }
}


