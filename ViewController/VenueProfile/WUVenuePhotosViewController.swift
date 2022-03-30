//
//  WUVenuePhotosViewController.swift
//  Wussup
//
//  Created by MAC219 on 5/10/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUVenuePhotosViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var ImageViewIcon            : UIImageView!
    @IBOutlet weak var labelPhotoTitle          : UILabel!
    @IBOutlet weak var labelPhotosCount         : UILabel!
    @IBOutlet private weak var buttonGoToTop    : UIButton!
    @IBOutlet weak var collectionViewPhotos     : UICollectionView!
    @IBOutlet private weak var buttonSearch     : UIButton!
    
    // MARK: - Variables
    var photos          : Any!
    var venueOrEvent    : Any!
    var selectedIndex   = 0
    
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
        self.buttonGoToTop.isHidden = true
        
        self.ImageViewIcon.sd_setShowActivityIndicatorView(true)
        self.ImageViewIcon.sd_setIndicatorStyle(.white)
        
        if self.photos is WUVenueProfilePhotos {
            self.labelPhotoTitle.text = (self.photos as! WUVenueProfilePhotos).CategoryName
            self.labelPhotosCount.text = "(\((self.photos as! WUVenueProfilePhotos).VenueImages.count))"
            self.ImageViewIcon.sd_setImage(with:URL(string:(self.photos as! WUVenueProfilePhotos).CategoryImage) , placeholderImage: UIImage(named:"placeholder.png" ))
        }
        if self.photos is WUEventPhotoDetail{
            self.labelPhotoTitle.text = (self.photos as! WUEventPhotoDetail).Name
            self.labelPhotosCount.text = "(\((self.photos as! WUEventPhotoDetail).eventPhotos.count))"
            self.ImageViewIcon.sd_setImage(with:URL(string:(self.photos as! WUEventPhotoDetail).ImageURL) , placeholderImage: UIImage(named:"placeholder.png" ))
        }
        
        self.collectionViewPhotos.register(UINib(nibName: Utill.getClassNameFor(classType:WUVenuePhotoCollectionCell()), bundle: nil), forCellWithReuseIdentifier: Utill.getClassNameFor(classType:WUVenuePhotoCollectionCell()))
    }
    
    // MARK: - Action Methods
    @IBAction func buttonBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSearchAction(_ sender: UIButton) {
        self.buttonSearch.isSelected = true
        if self.photos is WUVenueProfilePhotos {
            self.pushToSearchViewController()
        }else {
            if let vc = UIStoryboard.events.get(WUEventSearchViewController.self){
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func buttonGoToTopAction(_ sender: UIButton) {
        self.collectionViewPhotos.setContentOffset(CGPoint.zero, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  Text.Segue.venuePhotosToVenueIndividualPhoto {
            let individualPhotosVc = segue.destination as! WUVenueIndividualPhotoViewController
            individualPhotosVc.photosindividual = self.photos
            individualPhotosVc.venueOrEvent = self.venueOrEvent
            individualPhotosVc.currentVisibleIndex = self.selectedIndex
        }
    }
}

//MARK: - CollectionView
extension WUVenuePhotosViewController  : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.photos is WUVenueProfilePhotos {
            return (self.photos as! WUVenueProfilePhotos).VenueImages.count
        }else {
            return (self.photos as! WUEventPhotoDetail).eventPhotos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUVenuePhotoCollectionCell()), for: indexPath)as! WUVenuePhotoCollectionCell
        if self.photos is WUVenueProfilePhotos {
            cell.venueImage = (self.photos as! WUVenueProfilePhotos).VenueImages[indexPath.row]
        }else {
            cell.eventPhotos = (self.photos as! WUEventPhotoDetail).eventPhotos[indexPath.row]
        }
        cell.enableCornerRadius = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier:Text.Segue.venuePhotosToVenueIndividualPhoto , sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (UIScreen.main.bounds.width/2)-(34/2)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Utill.manageGoToTopButton(scrollView: scrollView, view: self.view, buttonGoToTop: self.buttonGoToTop)
    }
}
