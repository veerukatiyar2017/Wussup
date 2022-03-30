//
//  WUVenueIndividualPhotoViewController.swift
//  Wussup
//
//  Created by MAC219 on 5/10/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class WUVenueIndividualPhotoViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableViewIndividualPhotos    : UITableView!
    @IBOutlet private weak var ImageViewIcon                : UIImageView!
    @IBOutlet private weak var labelPhotoTitle              : UILabel!
    @IBOutlet private weak var labelPhotosCount             : UILabel!
    @IBOutlet private weak var collectionViewPhotos         : UICollectionView!
    @IBOutlet private weak var buttonPrevious               : UIButton!
    @IBOutlet private weak var buttonNext                   : UIButton!
    @IBOutlet private weak var buttonShare                  : UIButton!
    @IBOutlet private weak var viewCollectionPhoto          : UIView!
    @IBOutlet private weak var buttonSearch: UIButton!
    @IBOutlet private weak var buttonGoToTop    : UIButton!
    
    // MARK: - Variables
    var photosindividual : Any!
    var venueOrEvent : Any!
    var currentVisibleIndex = 0
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.buttonSearch.isSelected = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        self.tableViewIndividualPhotos.tableHeaderView?.frame = CGRect(x: 0.0, y: 0.0, width: self.tableViewIndividualPhotos.frame.width, height: 465.0)
        self.ImageViewIcon.sd_imageIndicator = SDWebImageActivityIndicator.white
//        self.ImageViewIcon.sd_setShowActivityIndicatorView(true)
//        self.ImageViewIcon.sd_setIndicatorStyle(.white)
        
        if self.photosindividual is WUVenueProfilePhotos {
            self.labelPhotoTitle.text = (self.photosindividual as! WUVenueProfilePhotos).CategoryName
            self.labelPhotosCount.text = "(\((self.photosindividual as! WUVenueProfilePhotos).VenueImages.count))"
            self.ImageViewIcon.sd_setImage(with:URL(string:(self.photosindividual as! WUVenueProfilePhotos).CategoryImage) , placeholderImage: UIImage(named:"placeholder.png" ))
        }
        if self.photosindividual is WUEventPhotoDetail{
            self.labelPhotoTitle.text = (self.photosindividual as! WUEventPhotoDetail).Name
            self.labelPhotosCount.text = "(\((self.photosindividual as! WUEventPhotoDetail).eventPhotos.count))"
            self.ImageViewIcon.sd_setImage(with:URL(string:(self.photosindividual as! WUEventPhotoDetail).ImageURL) , placeholderImage: UIImage(named:"placeholder.png" ))
        }
        
        self.collectionViewPhotos.register(UINib(nibName: Utill.getClassNameFor(classType:WUVenuePhotoCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUVenuePhotoCollectionCell()))
        self.buttonPrevious.isHidden = true
        
        if self.photosindividual is WUVenueProfilePhotos{
            if (self.photosindividual as! WUVenueProfilePhotos).VenueImages.count == 1 {
                self.buttonNext.isHidden = true
            }
        }else {
            if (self.photosindividual as! WUEventPhotoDetail).eventPhotos.count == 1 {
                self.buttonNext.isHidden = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.collectionViewPhotos.scrollToItem(at:IndexPath(row: self.currentVisibleIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
        })
    }
    
    private func mangeShareButtonUI(isSelected : Bool){
        self.buttonShare.setTitle(Text.Label.text_Share, for: .normal)
        if isSelected == true{
            self.buttonShare.isSelected = true
            self.buttonShare.setTitleColor(UIColor.AddToCalenderSelectedColor, for: .normal)
        }else{
            self.buttonShare.isSelected = false
            self.buttonShare.setTitleColor(UIColor.AddToCalenderNormalColor, for: .normal)
        }
    }
    
    // MARK: - Action Methods
    @IBAction func buttonBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSearchAction(_ sender: UIButton) {
        self.buttonSearch.isSelected = true
        if self.photosindividual is WUVenueProfilePhotos {
            self.pushToSearchViewController()
        }else {
            if let vc = UIStoryboard.events.get(WUEventSearchViewController.self){
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func buttonShareAction(_ sender: UIButton) {
        self.mangeShareButtonUI(isSelected: true)
        var venueID : String = ""
        var FourSquareVenueID : String = ""
        var EventID : String = ""
        var name_Venue_Event : String  = ""
        var eventStartDate : String = ""
//        var eventEndDate : String = ""
        if self.venueOrEvent is WUVenueDetail{
            let venueProfile = self.venueOrEvent as! WUVenueDetail
            venueID = venueProfile.SponsoredVenuID
            FourSquareVenueID = venueProfile.FourSquareVenueID
            name_Venue_Event = "Venue Name : \((self.venueOrEvent as! WUVenueDetail).VenueName)"
        }else {
            let EventProfile = self.venueOrEvent as! WUEventDetail
            EventID = EventProfile.ID
            name_Venue_Event = "Event Name : \((self.venueOrEvent as! WUEventDetail).Name)"
            
            let strtDate = Date.dateObject(dateStr: (self.venueOrEvent as! WUEventDetail).StartDate)
            let endedDate = Date.dateObject(dateStr: (self.venueOrEvent as! WUEventDetail).EndDate)
            let finalStartDate = Date.stringFromCustomDate(fromDate: strtDate!, withFormat: "MM/dd/yyyy hh:mm a")
            let finalEndDate = Date.stringFromCustomDate(fromDate: endedDate!, withFormat: "MM/dd/yyyy hh:mm a")
            
            eventStartDate = "Event StartDate : \(finalStartDate)\nEvent EndDate : \(finalEndDate) "
        }
        WEB_API.call_api_GetShareLinkForVenueOrEvent(strVenueID: venueID, strFourSquareVenueID : FourSquareVenueID, strEventID: EventID, strLiveCamID: "") { (response, success, message) in
            if success == true{
                let dicShare = response?.dictionary!
                let shareText = dicShare!["ShareMessage"]?.string!
                //let shareLink = dicShare!["ShareLink"]?.string!
                let shareLink = "https://apps.arvzapp.com/venue/\(venueID)/FourSquareID/\(FourSquareVenueID)"
                
                let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: shareText ?? Text.Message.msg_Deeplinking_Share) as Any,WUShareActivityItemProvider(placeholderItem: shareLink ?? "https://apps.arvzapp.com/") as Any,WUShareActivityItemProvider(placeholderItem:name_Venue_Event) as Any,WUShareActivityItemProvider(placeholderItem:eventStartDate) as Any]
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
                activityViewController.excludedActivityTypes = [.addToReadingList ,.saveToCameraRoll , .copyToPasteboard , .addToReadingList ,.assignToContact ,.print , activityTypeCloud, .airDrop]
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
                
                activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                    if completed == true{
                        Utill.showAlertView(viewController: self, message: Text.Message.venueShareMsg)
                    }
                }
            }
        }
        /*  Utill.printInTOConsole(printData:"buttonShareAction")
         var imageUrl = ""
         if self.photosindividual is WUVenueProfilePhotos{
         imageUrl = ((self.photosindividual as! WUVenueProfilePhotos).VenueImages[currentVisibleIndex].SquareImage)
         }else {
         imageUrl = ((self.photosindividual as! WUEventPhotoDetail).eventPhotos[currentVisibleIndex].ImageURL)
         }
         
         Utill.getImageFrom(path: imageUrl) { (img) in
         DispatchQueue.main.async {
         //                let shareAll = [img] as [Any]
         
         let shareAll : [Any] = [WUShareActivityItemProvider(placeholderItem: img) as Any]
         
         let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
         let activityTypeCloud = UIActivityType.init("com.apple.CloudDocsUI.AddToiCloudDriven")
         activityViewController.excludedActivityTypes = [.addToReadingList ,.saveToCameraRoll , .copyToPasteboard , .addToReadingList ,.assignToContact ,.print , activityTypeCloud]
         activityViewController.popoverPresentationController?.sourceView = self.view
         self.present(activityViewController, animated: true, completion: nil)
         
         self.present(activityViewController, animated: true) {
         self.mangeShareButtonUI(isSelected: true)
         }
         activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
         self.mangeShareButtonUI(isSelected: false)
         if completed == true{
         Utill.showAlertView(viewController: self, message: Text.Message.applicationShareMsg)
         }
         }
         }
         }*/
    }
    
    @IBAction func buttonPreviousAction(_ sender: Any) {
        self.currentVisibleIndex -= 1
        if self.currentVisibleIndex <= 0{
            self.currentVisibleIndex = 0
        }
        self.mangeShareButtonUI(isSelected: false)
        collectionViewPhotos.scrollToItem(at:IndexPath(row: self.currentVisibleIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
        self.tableViewIndividualPhotos.reloadData()
    }
    
    @IBAction func buttonNextAction(_ sender: Any) {
        self.currentVisibleIndex += 1
        
        if self.photosindividual is WUVenueProfilePhotos{
            if self.currentVisibleIndex >= (self.photosindividual as! WUVenueProfilePhotos).VenueImages.count{
                self.currentVisibleIndex = (self.photosindividual as! WUVenueProfilePhotos).VenueImages.count - 1
            }
        }else {
            if self.currentVisibleIndex >= (self.photosindividual as! WUEventPhotoDetail).eventPhotos.count{
                self.currentVisibleIndex = (self.photosindividual as! WUEventPhotoDetail).eventPhotos.count - 1
            }
        }
        self.tableViewIndividualPhotos.reloadData()
        
        self.mangeShareButtonUI(isSelected: false)
        collectionViewPhotos.scrollToItem(at:IndexPath(row: self.currentVisibleIndex, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
    }
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.tableViewIndividualPhotos.setContentOffset(CGPoint.zero, animated: true)
    }
}

//MARK: - TableView
extension WUVenueIndividualPhotoViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUPhotoDescriptionTableCell()), for: indexPath)as! WUPhotoDescriptionTableCell
        if self.photosindividual is WUVenueProfilePhotos {
            cell.labelDescription.text = (self.photosindividual as! WUVenueProfilePhotos).VenueImages[self.currentVisibleIndex].Description
        }else {
            cell.labelDescription.text = (self.photosindividual as! WUEventPhotoDetail).eventPhotos[indexPath.row].Description
        }
        return cell
    }
}

//MARK: - CollectionView
extension WUVenueIndividualPhotoViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.photosindividual is WUVenueProfilePhotos {
            return (self.photosindividual as! WUVenueProfilePhotos).VenueImages.count
        }else {
            return (self.photosindividual as! WUEventPhotoDetail).eventPhotos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUVenuePhotoCollectionCell()), for: indexPath)as! WUVenuePhotoCollectionCell
        if self.photosindividual is WUVenueProfilePhotos {
            cell.venueImage = (self.photosindividual as! WUVenueProfilePhotos).VenueImages[indexPath.row]
        }else {
            cell.eventPhotos = (self.photosindividual as! WUEventPhotoDetail).eventPhotos[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewPhotos.frame.width, height: self.collectionViewPhotos.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionViewPhotos{
            self.mangeShareButtonUI(isSelected: false)
            let currentPage = self.collectionViewPhotos.contentOffset.x / self.collectionViewPhotos.frame.size.width
            self.currentVisibleIndex = Int(currentPage)
            self.tableViewIndividualPhotos.reloadData()
            Utill.printInTOConsole(printData:"current index : \(currentPage)")
            self.buttonPrevious.isHidden = false
            self.buttonNext.isHidden = false
            
            if self.currentVisibleIndex == 0 {
                self.buttonPrevious.isHidden = true
            }
            
            if self.photosindividual is WUVenueProfilePhotos {
                if self.currentVisibleIndex ==  (self.photosindividual as! WUVenueProfilePhotos).VenueImages.count - 1 {
                    self.buttonNext.isHidden = true
                }
            }else {
                if self.currentVisibleIndex ==  (self.photosindividual as! WUEventPhotoDetail).eventPhotos.count - 1 {
                    self.buttonNext.isHidden = true
                }
            }
        }
        Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
    }
}


