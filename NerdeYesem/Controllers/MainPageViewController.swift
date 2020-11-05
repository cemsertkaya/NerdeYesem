//
//  MainPageViewController.swift
//  NerdeYesem
//
//  Created by Cem Sertkaya on 5.11.2020.
//  Copyright © 2020 Cem Sertkaya. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainPageViewController: UIViewController,CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var newLocationLatitude = Double()//Our new location's latitude value
    var newLocationLongitude = Double()//Our new location's longitude value
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func findButtonAction(_ sender: Any)//Our new location will have been refreshing when we tap the button
    {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.newLocationLatitude = locValue.latitude
        self.newLocationLongitude = locValue.longitude
        locationManager.delegate = nil
    }
    

}
