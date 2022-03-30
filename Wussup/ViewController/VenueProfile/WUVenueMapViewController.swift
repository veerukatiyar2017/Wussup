//
//  WUVenueMapViewController.swift
//  Wussup
//
//  Created by MAC219 on 5/15/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class WUVenueMapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var labelDistance        : UILabel!
    @IBOutlet private weak var labelAddress         : UILabel!
    @IBOutlet private weak var labelTitle           : UILabel!
    @IBOutlet private weak var mapView              : MKMapView!
    @IBOutlet private weak var buttonSearch         : UIButton!
    @IBOutlet private weak var viewOpenMap          : UIView!
    @IBOutlet private weak var viewAddress          : UIView!
    
    // MARK: - Variables
    var venueMapDetail  : WUVenueDetail!
    var eventMapDetail  : WUEventDirectionDetail?
    var toLatitude      : CLLocationDegrees = 0.0
    var toLongitude     : CLLocationDegrees = 0.0
    var fromLatitude    : CLLocationDegrees = 0.0
    var fromLongitude   : CLLocationDegrees = 0.0
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        if eventMapDetail != nil {
            self.initialInterfaceSetUpForEvent()
        }else{
            self.initialInterfaceSetUp()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.buttonSearch.isSelected = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func setUpView(){
        self.viewOpenMap.backgroundColor = UIColor.SearchBarYellowColor
        self.viewAddress.backgroundColor = UIColor.SearchBarYellowColor
    }
    
    private func initialInterfaceSetUp() {
        if self.venueMapDetail.VenueLattitude != "" && self.venueMapDetail.VenueLongitude != ""{
            self.labelDistance.text = NSString(format: "%0.2f Mi - Away", Float(self.venueMapDetail.VenueDistance) ?? 0) as String
            
            self.labelAddress.text = self.venueMapDetail.VenueFullAddress

            self.toLatitude = CLLocationDegrees(self.venueMapDetail.VenueLattitude)!
            self.toLongitude = CLLocationDegrees(self.venueMapDetail.VenueLongitude)!
            
            self.fromLatitude = GlobalShared.currentLocationCoordinate.latitude
            self.fromLongitude = GlobalShared.currentLocationCoordinate.longitude
            self.labelTitle.text = self.venueMapDetail.VenueName
            self.setLocationPin()
        }
    }
    
    private func initialInterfaceSetUpForEvent() {
        if self.eventMapDetail?.Latitude != "" && self.eventMapDetail?.Longitude != ""{
            if self.eventMapDetail?.Distance != ""{
                self.labelDistance.text = NSString(format: "%0.2f Mi - Away", Float(self.eventMapDetail!.Distance) ?? 0) as String
            }
            if self.eventMapDetail?.FullAddress != ""{
                self.labelAddress.text = "\(self.eventMapDetail?.FullAddress ?? "")" == "" ?  "No information found" : "\(self.eventMapDetail?.FullAddress ?? "")"
            }
            self.toLatitude = CLLocationDegrees(self.eventMapDetail!.Latitude)!
            self.toLongitude = CLLocationDegrees(self.eventMapDetail!.Longitude)!
            
            self.fromLatitude = GlobalShared.currentLocationCoordinate.latitude
            self.fromLongitude = GlobalShared.currentLocationCoordinate.longitude
            self.labelTitle.text = self.eventMapDetail?.Name
            self.setLocationPin()
        }
    }
    
    private func setLocationPin(){
        mapView.mapType = MKMapType.standard
        let location = CLLocationCoordinate2D(latitude: self.toLatitude , longitude:self.toLongitude)
        let span = MKCoordinateSpanMake(0.049,0.049)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = WUMap.init(coordinate: location, title: "")
        
        if self.venueMapDetail != nil {
            if self.venueMapDetail.VenueLattitude != ""{
                annotation.title = self.venueMapDetail.VenueName
            }
        }
        if self.eventMapDetail != nil {
            if self.eventMapDetail?.Latitude != ""{
                annotation.title = self.eventMapDetail?.Name//"required Event Name "
            }
        }
        //        annotation.subtitle = "xyz"
        mapView.addAnnotation(annotation)
    }
    
    // MARK: - Action Methods
    @IBAction func buttonBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSearchAction(_ sender: UIButton) {
        self.buttonSearch.isSelected = true
        self.pushToSearchViewController()
    }
    
    /*
     // Open and show coordinate
     let url = "http://maps.apple.com/maps?saddr=\(coord.latitude),\(coord.longitude)"
     UIApplication.shared.openURL(URL(string:url)!)
     
     // Navigate from one coordinate to another
     let url = "http://maps.apple.com/maps?saddr=\(from.latitude),\(from.longitude)&daddr=\(to.latitude),\(to.longitude)"
     UIApplication.shared.openURL(URL(string:url)!)
     */
    
    @IBAction func buttonOpenMapAction(_ sender: Any) {
        if CLLocationManager.authorizationStatus() == .denied , CLLocationManager.authorizationStatus() == .restricted {
            Utill.showAlert_GoToSettingCancle_ViewOnWindow(message: Text.Label.text_AllowAccessToLocation) { (bool) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }else {
            let url = "http://maps.apple.com/maps?saddr=\(self.fromLatitude),\(self.fromLongitude)&daddr=\(self.toLatitude),\(self.toLongitude)"
            UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - MapView Delegate
extension WUVenueMapViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is WUMap{
            
            if self.venueMapDetail != nil {
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: self.venueMapDetail.VenueName)
                if anView == nil {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: self.venueMapDetail.VenueName)
                } else {
                    anView?.annotation = annotation
                }
                Utill.getImageFrom(path: self.venueMapDetail.MapPinImageUrl) { (image) in
                    DispatchQueue.main.async {
                        anView?.image = image
                    }
                }
                anView?.canShowCallout = true
                return anView
            }
            
            if self.eventMapDetail != nil {
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: (self.eventMapDetail?.Name)!)
                if anView == nil {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: (self.eventMapDetail?.Name)!)
                } else {
                    anView?.annotation = annotation
                }
                Utill.getImageFrom(path: (self.eventMapDetail?.MapPinImageUrl)!) { (image) in
                    DispatchQueue.main.async {
                        anView?.image = image
                    }
                }
                anView?.canShowCallout = true
                
                return anView
            }else{
                return nil
            }
        }else{
            Utill.printInTOConsole(printData:"not map")
            return nil
        }
    }
}
