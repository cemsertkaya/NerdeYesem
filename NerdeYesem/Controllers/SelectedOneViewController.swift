//
//  SelectedOneViewController.swift
//  NerdeYesem
//
//  Created by Cem Sertkaya on 5.11.2020.
//  Copyright © 2020 Cem Sertkaya. All rights reserved.
//

import UIKit
import CoreLocation

class SelectedOneViewController: UIViewController
{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    var selectedRestaurant = Restaurant(id: "", name: "", url: "", address: "", image: "", cuisines: "")
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if selectedRestaurant.getImage() != ""
        {
            let url = URL(string:selectedRestaurant.getImage() as! String)
            let data = try? Data(contentsOf:url!)
            imageView.image = UIImage(data: data!)
        }
        nameLabel.text = selectedRestaurant.getName()
        cuisineLabel.text = selectedRestaurant.getCuisines()
        urlButton.setTitle(selectedRestaurant.getUrl(), for: .normal)
        addressButton.setTitle(selectedRestaurant.getAddress(), for: .normal)
        
    }
    @IBAction func takePhotoButtonAction(_ sender: Any) {}
    @IBAction func seePhotosButtonAction(_ sender: Any) {}
    @IBAction func urlButtonClicked(_ sender: Any)//Open url link on safari
    {
        guard let url = URL(string: self.selectedRestaurant.getUrl()) else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func adressButtonClicked(_ sender: Any)//Show location on apple map
    {
       let myAddress = selectedRestaurant.getAddress()
       let geoCoder = CLGeocoder()
       geoCoder.geocodeAddressString(myAddress) { (placemarks, error) in
           guard let placemarks = placemarks?.first else { return }
           let location = placemarks.location?.coordinate ?? CLLocationCoordinate2D()
           guard let url = URL(string:"http://maps.apple.com/?daddr=\(location.latitude),\(location.longitude)") else { return }
           UIApplication.shared.open(url)
       }
    }

    
}
