//
//  SelectedOneViewController.swift
//  NerdeYesem
//
//  Created by Cem Sertkaya on 5.11.2020.
//  Copyright © 2020 Cem Sertkaya. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
class SelectedOneViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    ////It checks whether the user likes or not
    var isUserLiked = Bool()
    ///Current user on firebase
    let user = Auth.auth().currentUser
    var selectedRestaurant = Restaurant(id: "", name: "", url: "", address: "", image: "", cuisines: "")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getLikers()
        //If the restaurant has an image it loads it to view controller
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
    
    ///Takes photos to load firestore
    @IBAction func takePhotoButtonAction(_ sender: Any)
    {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        imagePicker.dismiss(animated: true, completion: nil)
        //Firebase setting
    }
    
    @IBAction func seePhotosButtonAction(_ sender: Any)
    {
        
    }
    
    ///Opens url link on safari
    @IBAction func urlButtonClicked(_ sender: Any)
    {
        guard let url = URL(string: self.selectedRestaurant.getUrl()) else { return }
        UIApplication.shared.open(url)
    }
    
    ///Shows location on apple map
    @IBAction func adressButtonClicked(_ sender: Any)
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
    
    ///Adds the restaurant to most prefered restaurants
    @IBAction func likeRestaurantButtonClicked(_ sender: Any)
    {
        let db = Firestore.firestore()
        //If user has already liked, it can be unliked
        if isUserLiked
        {
            db.collection("favorites").document(self.selectedRestaurant.getId()).getDocument { (snapshot, error ) in
                if  (snapshot?.exists)!//User document exist
                {
                    db.collection("favorites").document(self.selectedRestaurant.getId()).updateData(["favoritedBy":FieldValue.arrayRemove([self.user!.uid])])
                    self.getLikers()
                }
            }
        }
        // If user hasn't liked yet, it can be liked
        else
        {
            db.collection("favorites").document(self.selectedRestaurant.getId()).getDocument { (snapshot, error ) in
                if  (snapshot?.exists)!//User document exist
                {
                     db.collection("favorites").document(self.selectedRestaurant.getId()).updateData(["favoritedBy":FieldValue.arrayUnion([self.user!.uid])])
                    self.getLikers()
                }
                else//User Document does not exist, first it creates document
                {
                    db.collection("favorites").document(self.selectedRestaurant.getId()).setData(["favoritedBy":[String](),"name":self.selectedRestaurant.getName(),"photo":self.selectedRestaurant.getImage(),"url":self.selectedRestaurant.getUrl(),"address": self.selectedRestaurant.getAddress(),"cuisine":self.selectedRestaurant.getCuisines()])
                    db.collection("favorites").document(self.selectedRestaurant.getId()).updateData(["favoritedBy":FieldValue.arrayUnion([self.user!.uid])])
                    self.getLikers()
                }
            }
        }
        
        
    }
    
    ///Gets the favoritedBy array from firebase and changes Like count
    func getLikers ()
    {
        var numberOfLikers = Int()
        let db = Firestore.firestore()
        db.collection("favorites").document(self.selectedRestaurant.getId()).getDocument { (snapshot, error ) in
            //User document exist, it gets the number of likers
            if  (snapshot?.exists)!
            {
                    let favoritedBy = snapshot?.get("favoritedBy") as! [String]
                    numberOfLikers = (favoritedBy).count
                    //It checks whether the user likes or not and changes the button title Like->Unlike
                    if favoritedBy.contains(self.user!.uid)
                    {
                        self.likeButton.setTitle("Liked \(numberOfLikers)", for: .normal)
                        self.isUserLiked = true
                    }
                   else
                    {
                        self.likeButton.setTitle("Like \(numberOfLikers)", for: .normal)
                        self.isUserLiked = false
                    }
                    print(String(numberOfLikers))
            }
            //User Document does not exist likers number will be 0
            else
            {
                numberOfLikers = 0
                self.likeButton.setTitle("Like \(numberOfLikers)", for: .normal)
            }
            
        }
    }
    
}
