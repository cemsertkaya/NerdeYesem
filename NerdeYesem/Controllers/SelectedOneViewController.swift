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
import FirebaseStorage
import SwiftPhotoGallery
class SelectedOneViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate
{
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var lookPhotosButton: UIButton!
    let db = Firestore.firestore()
    var photosUrl = [String]()
    ///Image type of photosUrl array
    var images = [UIImage]()
    ///If this restaurant is a favorite, it shows photo upload and look buttons
    var isPhotoButtonsNeeded = false
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
        if !isPhotoButtonsNeeded
        {
            takePhotoButton.isHidden = true
            lookPhotosButton.isHidden = true
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
    
    ///Takes the photo and converts image to url and pushes it to database
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        self.imagePicker.dismiss(animated: true, completion: nil)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mediaFolder = storageRef.child("media")
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        if let data = image?.jpegData(compressionQuality: 0.5)
        {
            let uuid = NSUUID().uuidString
            //Creates url link ((UUID)+.jpg)
            let mediaImagesRef = mediaFolder.child("\(uuid).jpg")
            //Puts it to storage media/
            mediaImagesRef.putData(data,metadata: nil)
            { (metadata, error) in
                if error != nil
                {
                       let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                       let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                       alert.addAction(okButton)
                       self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    //Puts it to array in favorite restaurant
                    mediaImagesRef.downloadURL(completion: { (url, error) in
                    if error != nil
                    {
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        let imageURL = url?.absoluteString
                        self.db.collection("favorites").document(self.selectedRestaurant.getId()).getDocument
                            { (snapshot, error ) in
                                if  (snapshot?.exists)!
                                {
                                    self.db.collection("favorites").document(self.selectedRestaurant.getId()).updateData(["photos":FieldValue.arrayUnion([imageURL])])
                                }
                            }}
                    })
                }
            }}
    }
        
        
    @IBAction func seePhotosButtonAction(_ sender: Any)
    {
        self.db.collection("favorites").document(self.selectedRestaurant.getId()).getDocument { (snapshot, error ) in
            if  (snapshot?.exists)!
            {
                 self.photosUrl = snapshot?.get("photos") as! [String]
                 self.images.removeAll(keepingCapacity: false)
                 if self.photosUrl.count > 0
                 {
                    //I implemented SwiftPhotoGallery lib from https://github.com/justinvallely/SwiftPhotoGallery in there i called this gallery
                    for item in self.photosUrl
                    {
                        let url = URL(string: item as! String)
                        let data = try? Data(contentsOf:url!)
                        let image = UIImage(data: data!)
                        self.images.append(image!)
                    }
                    let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
                    gallery.backgroundColor = UIColor.black
                    gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
                    gallery.currentPageIndicatorTintColor = UIColor.white
                    gallery.hidePageControl = false
                    self.present(gallery, animated: true, completion: nil)
                 }
                 else
                 {
                    let alert = UIAlertController(title: "Error", message:"There is no photo for this restaurant.", preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                 }
                 
            }
            else
            {
               let alert = UIAlertController(title: "Error", message:"There is no photo for this restaurant.", preferredStyle: UIAlertController.Style.alert)
               let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
               alert.addAction(okButton)
               self.present(alert, animated: true, completion: nil)
            }
        }
       
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
        //If user has already liked, it can be unliked
        if isUserLiked
        {
            self.db.collection("favorites").document(self.selectedRestaurant.getId()).getDocument { (snapshot, error ) in
                if  (snapshot?.exists)!
                {
                    let favoritedBy = snapshot?.get("favoritedBy") as! [String]
                    let favoritedByCount = snapshot?.get("favoritedByCount") as! Int
                    //If this user is the only liker of this restaurant, when user unlike we have to delete document
                    if favoritedByCount == 1
                    {
                        self.db.collection("favorites").document(self.selectedRestaurant.getId()).delete()
                    }
                    else
                    {
                        self.db.collection("favorites").document(self.selectedRestaurant.getId()).updateData(["favoritedBy":FieldValue.arrayRemove([self.user!.uid]),"favoritedByCount":favoritedByCount-1])
                    }
                    self.getLikers()
                }
            }
        }
        // If user hasn't liked yet, it can be liked
        else
        {
            self.db.collection("favorites").document(self.selectedRestaurant.getId()).getDocument { (snapshot, error ) in
                if  (snapshot?.exists)!
                {
                    let favoritedBy = snapshot?.get("favoritedBy") as! [String]
                    let favoritedByCount = snapshot?.get("favoritedByCount") as! Int
                    self.db.collection("favorites").document(self.selectedRestaurant.getId()).updateData(["favoritedBy":FieldValue.arrayUnion([self.user!.uid]),"favoritedByCount":favoritedByCount-1])
                    self.getLikers()
                }
                else//User Document does not exist, first it creates document
                {
                    self.db.collection("favorites").document(self.selectedRestaurant.getId()).setData(["favoritedBy":[String](),"name":self.selectedRestaurant.getName(),"photo":self.selectedRestaurant.getImage(),"url":self.selectedRestaurant.getUrl(),"address": self.selectedRestaurant.getAddress(),"cuisine":self.selectedRestaurant.getCuisines(),"photos":[String](),"favoritedByCount": 1])
                    self.db.collection("favorites").document(self.selectedRestaurant.getId()).updateData(["favoritedBy":FieldValue.arrayUnion([self.user!.uid])])
                    self.getLikers()
                }
            }
        }
    }
    
    ///Gets the favoritedBy array from firebase and changes Like count
    func getLikers ()
    {
        var numberOfLikers = Int()
        self.db.collection("favorites").document(self.selectedRestaurant.getId()).getDocument { (snapshot, error ) in
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
    
    ///// I implemented SwiftPhotoGallery lib from https://github.com/justinvallely/SwiftPhotoGallery and these are the functions of this gallery class
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {return self.images.count}
    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {return self.images[forIndex]}
    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {dismiss(animated: true, completion: nil)}
    
}
