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
import Firebase
class MainPageViewController: UIViewController,CLLocationManagerDelegate
{

    @IBOutlet weak var mapKit: MKMapView!
    let locationManager = CLLocationManager()
    ///New location's latitude value
    var newLocationLatitude = Double()
    ///New location's longitude value
    var newLocationLongitude = Double()
    ///Restaurants array for keeping Restaurant objects
    var nearRestaurants = [Restaurant]()
    @IBOutlet weak var findButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Alert for waiting
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        //It calls the functions that call
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    @IBAction func findButtonAction(_ sender: Any)//Our new location will have been refreshing when we tap the button
    {
        //If decoding is okay we can go to the list page
        if nearRestaurants.count > 0
        {
             self.performSegue(withIdentifier: "toListController", sender: self)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //We are getting the latitude over here
        self.newLocationLatitude = locValue.latitude
        //We are getting the longitude over here
        self.newLocationLongitude = locValue.longitude
        //Mapkit location
        let location = CLLocation(latitude: self.newLocationLatitude, longitude: self.newLocationLongitude)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 7000, longitudinalMeters: 7000)
        mapKit.setRegion(coordinateRegion, animated: true)
        //Mapkit pin to our location
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.newLocationLatitude, longitude: self.newLocationLongitude)
        annotation.title = "You're here"
        mapKit.addAnnotation(annotation)
        locationManager.delegate = nil
        findRestaurants()
    }
    
    ///Gets restaurants from zomato api
    func findRestaurants()
    {
       self.nearRestaurants.removeAll(keepingCapacity: false)
       let userKey = "db518cc79360e4cc2e95c1812d01c170"
       let newUrl = "https://developers.zomato.com/api/v2.1/geocode?lat=\(self.newLocationLatitude.string)&lon=\(self.newLocationLongitude.string)"
       let url = NSURL(string: newUrl)
       var request = URLRequest(url: url! as URL)
       request.addValue("application/json", forHTTPHeaderField: "Accept")
       request.addValue(userKey, forHTTPHeaderField: "user-key")
       request.httpMethod = "GET"
       let sess = URLSession(configuration: .default)
       sess.dataTask(with: request)
       {
            (data, response, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "We cannot find your location", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                //We're decoded the data that came from api
                if data != nil
                {
                    do {
                        let jSONResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                        let nearbyRestaurantsMap = jSONResult["nearby_restaurants"]
                        for restaurantMap in nearbyRestaurantsMap as! [[String: Any]]
                        {
                            let newRestaurant = (restaurantMap["restaurant"]) as! Dictionary <String, AnyObject>
                            let newRestaurantAddress = (newRestaurant["location"]) as!  Dictionary <String, AnyObject>
                            //After decoding the data  we created a restaurant object
                            let restaurant = Restaurant(id: newRestaurant["id"] as! String, name: newRestaurant["name"] as! String, url: newRestaurant["url"] as! String,address: newRestaurantAddress["address"] as! String,image: newRestaurant["featured_image"] as! String, cuisines:  newRestaurant["cuisines"] as! String)
                            //We added our restaurant objects to nearRestaurants array for using other view controllers's table view
                            self.nearRestaurants.append(restaurant)
                        }
                        self.dismiss(animated: false, completion: nil)
                    }
                    catch {
                        //print("Error")
                    }
               }
          }
    }.resume()
    }
    
    ///It gives nearRestaurants array to other view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toListController"
        {
            let destinationVC = segue.destination as! ListViewController
            destinationVC.listNearRestaurants = self.nearRestaurants
        }
    }
    
    ///SignOut Button Clicked Function, it does sign out operation.
    @IBAction func signOutButtonAction(_ sender: Any)
    {
        do
        {
           try Auth.auth().signOut()
           self.performSegue(withIdentifier: "signOut", sender: self)
           
        }
        catch{print("SignOutError")}
    }
    
   
    
}
extension LosslessStringConvertible {
    var string: String { .init(self) }
}
