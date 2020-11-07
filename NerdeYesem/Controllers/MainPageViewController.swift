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
    var nearRestaurants = [Restaurant]()
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.newLocationLatitude = locValue.latitude//We are getting the latitude over here
        self.newLocationLongitude = locValue.longitude//We are getting the longitude over here
        locationManager.delegate = nil
        findRestaurants()
    }
    
    func findRestaurants()
    {
       let userKey = "db518cc79360e4cc2e95c1812d01c170"
       let url = URL(string: "https://developers.zomato.com/api/v2.1/geocode?lat="+String(self.newLocationLatitude)+"&lon="+String(self.newLocationLongitude))//We created our url with our new lat&long combination
       var request = URLRequest(url: url!)
       request.addValue("application/json", forHTTPHeaderField: "Accept")
       request.addValue(userKey, forHTTPHeaderField: "user-key")
       request.httpMethod = "GET"
       let sess = URLSession(configuration: .default)
       sess.dataTask(with: request)
       {
            (data, response, error) in
            if error != nil
            {
                /*let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)*/
            }
            else
            {
                if data != nil//We're decoded the data that came from api
                {
                    do {
                        let jSONResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                        var nearbyRestaurantsMap = jSONResult["nearby_restaurants"]
                        for restaurantMap in nearbyRestaurantsMap as! [AnyObject]
                        {
                            let newRestaurant = (restaurantMap["restaurant"]) as! Dictionary <String, AnyObject>
                            let newRestaurantAddress = (newRestaurant["location"]) as!  Dictionary <String, AnyObject>
                            let restaurant = Restaurant(id: newRestaurant["id"] as! String, name: newRestaurant["name"] as! String, url: newRestaurant["url"] as! String,address: newRestaurantAddress["address"] as! String,image: newRestaurant["featured_image"] as! String, cuisines:  newRestaurant["cuisines"] as! String)//After decoding the data  we created a restaurant object
                            self.nearRestaurants.append(restaurant)//We added our restaurant objects to nearRestaurants array for using other view controllers's table view
                        }
                    } catch {
                        
                    }
               }
          }
    }.resume()
            
            
            
    
    
    }
    
}
