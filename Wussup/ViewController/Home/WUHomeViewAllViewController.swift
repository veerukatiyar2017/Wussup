//
//  WUHomeViewAllViewController.swift
//  Wussup
//
//  Created by MAC219 on 5/2/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WUHomeViewAllViewControllerDelegate: class {
    func HomeVenueUpdateRating(category obj : Any!)
    func HomeVenueUpdateClaimBusinees(category obj : Any!)
}

extension WUHomeViewAllViewControllerDelegate {
    func HomeVenueUpdateRating(category obj : Any!){
    }
    
    func HomeVenueUpdateClaimBusinees(category obj : Any!) {
        
    }
}


class WUHomeViewAllViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var buttonGoToTop            : UIButton!
    @IBOutlet private weak var labelNavigationTitle     : UILabel!
    @IBOutlet private weak var collectionView           : UICollectionView!
    
    // MARK: - Variables
    var verticalContentOffset : CGFloat!
    var isFromViewAllVC : Bool = true
    var selectedHomeVenueData : Any!
    weak var delegate : WUHomeViewAllViewControllerDelegate?
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.verticalContentOffset != nil {
            DispatchQueue.main.async {
                let offset = CGPoint.init(x: 0, y:self.verticalContentOffset)
                self.collectionView.setContentOffset(offset, animated: false)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        
        self.labelNavigationTitle.font = UIFont.ProximaNovaMedium(20)
        self.buttonGoToTop.isHidden = true
        
        if let category = self.selectedHomeVenueData as? WUCategorisedVenues,
            ((category.CategoryID == VenueCategoryID.ArtsEntertainment.rawValue) ||
                (category.CategoryID == VenueCategoryID.Other.rawValue) ||
                (category.CategoryID == VenueCategoryID.Event.rawValue)){
            
            self.labelNavigationTitle.text = category.CategoryName.uppercased()
            self.collectionView.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeTitleCollectionCell()),
                                                bundle: nil),
                                         forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeTitleCollectionCell()))
            
        } else if self.selectedHomeVenueData is WULocalPromotions{
            
            self.labelNavigationTitle.text = (selectedHomeVenueData as! WULocalPromotions).CategoryName.uppercased()
            self.collectionView.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()),
                                               bundle: nil),
                                         forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()))
        } else {
            
            if self.selectedHomeVenueData is WUTopSpots{
                self.labelNavigationTitle.text = (selectedHomeVenueData as! WUTopSpots).CategoryName.uppercased()
            } else {
                self.labelNavigationTitle.text = (selectedHomeVenueData as! WUCategorisedVenues).CategoryName.uppercased()
            }
            self.collectionView.register(UINib(nibName: Utill.getClassNameFor(classType:WUHomeRatingCollectionCell()),
                                               bundle: nil),
                                         forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUHomeRatingCollectionCell()))
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func buttonBackAction(_ sender: Any) {
        
        if selectedHomeVenueData != nil {
            if let delegate = self.delegate {
                if self.selectedHomeVenueData is WUTopSpots{
                    delegate.HomeVenueUpdateRating(category: (self.selectedHomeVenueData as! WUTopSpots))
                }else if self.selectedHomeVenueData is WULocalPromotions{
                    delegate.HomeVenueUpdateRating(category: (self.selectedHomeVenueData as! WULocalPromotions))
                }else {
                    delegate.HomeVenueUpdateRating(category: (self.selectedHomeVenueData as! WUCategorisedVenues))
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func updateClaimBusineesValueWithVenueName(_ venueName : String)
    {
        if let category = self.selectedHomeVenueData as? WUCategorisedVenues
        {
            let arr = category.Venues.filter({$0.VenueName == venueName})
            if arr.count > 0
            {
                let index = category.Venues.index(of: arr.first!)
                let venue = category.Venues[index!]
                venue.IsClaimVenue = "True"
                self.collectionView.reloadData()
            }
        }
    }
}

//MARK: - CollectionView
extension WUHomeViewAllViewController  : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let category = self.selectedHomeVenueData as? WUCategorisedVenues,
            ((category.CategoryID == VenueCategoryID.ArtsEntertainment.rawValue) ||
                (category.CategoryID == VenueCategoryID.Other.rawValue)) {
            
            return (self.selectedHomeVenueData as! WUCategorisedVenues).Venues.count
        }else if self.selectedHomeVenueData is WUTopSpots{
            return (self.selectedHomeVenueData as! WUTopSpots).Venues.count
        }else if self.selectedHomeVenueData is WULocalPromotions{
            return (self.selectedHomeVenueData as! WULocalPromotions).VenuePromotions.count
        }else if let category = self.selectedHomeVenueData as? WUCategorisedVenues, (category.CategoryID == VenueCategoryID.Event.rawValue) {
            return (self.selectedHomeVenueData as! WUCategorisedVenues).Events.count
        }else {
            return (self.selectedHomeVenueData as! WUCategorisedVenues).Venues.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let category = self.selectedHomeVenueData as? WUCategorisedVenues,
            ((category.CategoryID == VenueCategoryID.ArtsEntertainment.rawValue)
                || (category.CategoryID == VenueCategoryID.Other.rawValue) ||
                (category.CategoryID == VenueCategoryID.Event.rawValue)) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeTitleCollectionCell()), for: indexPath)as! WUHomeTitleCollectionCell
//            cell.buttonClaimThisBusiness.titleLabel?.font = UIFont.ProximaNovaMedium(11.5.propotional)
            if (category.CategoryID == VenueCategoryID.Event.rawValue) {
                cell.venueLiveCamsOrArtEntmt = category.Events[indexPath.row]
            }else {
                cell.venueLiveCamsOrArtEntmt = category.Venues[indexPath.row]
            }
//            cell.venueLiveCamsOrArtEntmt = category.Venues[indexPath.row]
            cell.delegate = self
            return cell
        } else if self.selectedHomeVenueData is WULocalPromotions{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeSliderCollectionCell()), for: indexPath)as! WUHomeSliderCollectionCell
            cell.venueLocalPromotion = (self.selectedHomeVenueData as! WULocalPromotions).VenuePromotions[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUHomeRatingCollectionCell()), for: indexPath)as! WUHomeRatingCollectionCell
//            cell.buttonClaimThisBusiness.titleLabel?.font = UIFont.ProximaNovaMedium(11.5.propotional)
            cell.delegate = self
            if self.selectedHomeVenueData is WUTopSpots{
                cell.venue = (self.selectedHomeVenueData as! WUTopSpots).Venues[indexPath.row]
            }else{
                cell.venue = (self.selectedHomeVenueData as! WUCategorisedVenues).Venues[indexPath.row]
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isFromViewAllVC = false
        if let category = self.selectedHomeVenueData as? WUCategorisedVenues,
            ((category.CategoryID == VenueCategoryID.Event.rawValue)){
           
            if let vc : WUEventProfileViewController = UIStoryboard.events.get(WUEventProfileViewController.self){
                vc.selectedEventId = (self.selectedHomeVenueData as! WUCategorisedVenues).Events[indexPath.row].ID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            
            if let vc : WUVenueProfileViewController = UIStoryboard.venue.get(WUVenueProfileViewController.self){
                
                if self.selectedHomeVenueData is WULocalPromotions{
                     vc.venue = (self.selectedHomeVenueData as! WULocalPromotions).VenuePromotions[indexPath.row]
                   
                    if (vc.venue as! WUVenueLocalPromotions).VenueStatusID == 1 {
                        self.verticalContentOffset  = self.collectionView.contentOffset.y
                        vc.delegate = self
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        Utill.goToClaimBussinessScreenWithVenue(viewController: self, venue: vc.venue as! WUVenueLocalPromotions)
                    }
                }else{
                    if self.selectedHomeVenueData is WUTopSpots{
                        vc.venue = (self.selectedHomeVenueData as! WUTopSpots).Venues[indexPath.row]
                    }else{
                        vc.venue = (self.selectedHomeVenueData as! WUCategorisedVenues).Venues[indexPath.row]
                    }
                    
                    if (vc.venue as! WUVenue).VenueStatusID == 1 {
                        self.verticalContentOffset  = self.collectionView.contentOffset.y
                        vc.delegate = self
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        Utill.goToClaimBussinessScreenWithVenue(viewController: self, venue: vc.venue as! WUVenue)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if self.selectedHomeVenueData is WULocalPromotions  {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0.0)
        }else {
            return UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12.0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if  self.selectedHomeVenueData is WULocalPromotions {
            return CGSize(width: self.collectionView.frame.size.width, height: 100.0)
        }else {
            let cellWidth = (UIScreen.main.bounds.width/2)-(34/2)
            return CGSize(width: cellWidth, height: cellWidth)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0.0{
            self.view.bringSubview(toFront: buttonGoToTop)
            self.buttonGoToTop.isHidden = false
            self.buttonGoToTop.alpha = 1.0
        }else{
            UIView.animate(withDuration: 0.3, animations:{
                self.buttonGoToTop.alpha = 0.0
            }, completion: { (isBool) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.buttonGoToTop.isHidden = true
                    self.view.sendSubview(toBack: self.buttonGoToTop)
                })
            })
        }
    }
}
//MARK: - WUHomeTitleCollectionCellDelegate
extension WUHomeViewAllViewController : WUHomeTitleCollectionCellDelegate{
    func homeTilteCollectionCellLiveCamButtonClicked(cell: WUHomeTitleCollectionCell, withVenueCategory venueCategory: Any) {
        self.verticalContentOffset  = self.collectionView.contentOffset.y
        Utill.goToLivecamProfile(viewController: self, withLivecamM: (venueCategory as! WUVenueLiveCams))

        /*if let vc : WUPlayLiveCamViewController = UIStoryboard.home.get(WUPlayLiveCamViewController.self){
            vc.hidesBottomBarWhenPushed = true
            vc.playLiveCamArray = [venueCategory as! WUVenueLiveCams]
            self.navigationController?.pushViewController(vc, animated: false)
        }*/
    }
    
    private func goToClaimBussinessScreenWithArtEntVenue(_ venue : Any) {
        self.verticalContentOffset  = self.collectionView.contentOffset.y
        if let vc = UIStoryboard.home.get(WUClaimABusinessPromptViewController.self){
            vc.venue = venue
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
//MARK: - WURatingCollectionCellDelegate
extension WUHomeViewAllViewController : WURatingCollectionCellDelegate {
    func ratingCollectionCellLiveCamButtonClicked(cell: WUHomeRatingCollectionCell, withVenueCategory venueCategory: Any) {
        Utill.goToLivecamProfile(viewController: self, withLivecamM: (venueCategory as! WUVenue).LiveCamsURLs[0])
        

      /*  if let vc : WUPlayLiveCamViewController = UIStoryboard.home.get(WUPlayLiveCamViewController.self){
            vc.hidesBottomBarWhenPushed = true
            vc.playLiveCamArray = (venueCategory as! WUVenue).LiveCamsURLs
            self.navigationController?.pushViewController(vc, animated: false)
        }*/
    }
    
      func goToClaimBussinessScreenWithVenue(_ venue : WUVenue) {
        if let vc = UIStoryboard.home.get(WUClaimABusinessPromptViewController.self){
            vc.venue = venue
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - WUVenueProfileViewControllerDelegate
extension WUHomeViewAllViewController : WUVenueProfileViewControllerDelegate {
    func venueProfileUpdateRating_Favorite(venueProfile obj: WUVenueDetail) {
        if self.selectedHomeVenueData is WUTopSpots{
            if (self.selectedHomeVenueData as! WUTopSpots).Venues.count > 0  {
                let arrTopVenueRating = (self.selectedHomeVenueData as? WUTopSpots)?.Venues.filter({$0.FourSquareVenueID == obj.FourSquareVenueID})
                if (arrTopVenueRating?.count)! > 0 {
                    arrTopVenueRating?.first?.VenueRating = obj.VenueRating
                    let index = (self.selectedHomeVenueData as! WUTopSpots).Venues.index(of: (arrTopVenueRating?.first)!)
                    collectionView.reloadItems(at: [IndexPath(row: index!, section: 0)])
                }
            }
        }else {
            if selectedHomeVenueData is WUCategorisedVenues {
                if (self.selectedHomeVenueData as! WUCategorisedVenues).Venues.count > 0  {
                    let arrTopVenueRating = (self.selectedHomeVenueData as? WUCategorisedVenues)?.Venues.filter({$0.FourSquareVenueID == obj.FourSquareVenueID})
                    if (arrTopVenueRating?.count)! > 0 {
                        arrTopVenueRating?.first?.VenueRating = obj.VenueRating
                        let index = (self.selectedHomeVenueData as! WUCategorisedVenues).Venues.index(of: (arrTopVenueRating?.first)!)
                        collectionView.reloadItems(at: [IndexPath(row: index!, section: 0)])
                    }
                }
            }
        }
    }
}
