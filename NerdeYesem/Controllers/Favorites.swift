//
//  Favorites.swift
//  NerdeYesem
//
//  Created by Cem Sertkaya on 10.11.2020.
//  Copyright © 2020 Cem Sertkaya. All rights reserved.
//

import UIKit
import Firebase
class Favorites: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet weak var tableView: UITableView!
    var favoriteRestaurants = [Restaurant]()
    var selectedRestaurant = Restaurant(id: "", name: "", url: "", address: "", image: "", cuisines: "")
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self; tableView.dataSource = self
        getFavoriteRestaurants()
    }
    
    ///Gets favorite restaurants from firebase
    func getFavoriteRestaurants()
    {
        let db = Firestore.firestore()
        let fireStoreDatabase = Firestore.firestore()
        //Snapshot is added for real time update
        fireStoreDatabase.collection("favorites").addSnapshotListener { (snapshot, error) in
            if error != nil
            {
                print(error?.localizedDescription)
            }
            else
            {
               if snapshot?.isEmpty != true && snapshot != nil
               {
                 self.favoriteRestaurants.removeAll(keepingCapacity: false)
                 for document in snapshot!.documents
                  {
                     let id = document.documentID
                     let name =  document.get("name") as! String
                     let url = document.get("url") as! String
                     let address = document.get("address") as! String
                     let photo = document.get("photo") as! String
                     let cuisine = document.get("cuisine") as! String
                     let restaurant = Restaurant(id: id , name: name, url: url, address: address, image: photo, cuisines: cuisine)
                     self.favoriteRestaurants.append(restaurant)
                     }
                 }
                 self.tableView.reloadData()
            }
             }}
    
    ///Classical table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{return favoriteRestaurants.count}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
          let cell = tableView.dequeueReusableCell(withIdentifier: "restCell", for: indexPath) as! RestCell
          cell.nameLabel.text = self.favoriteRestaurants[indexPath.row].getName()
          cell.cuisineLabel.text = self.favoriteRestaurants[indexPath.row].getCuisines()
          return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.selectedRestaurant = self.favoriteRestaurants[indexPath.row]
        performSegue(withIdentifier: "toSingleRestFromFavorites", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toSingleRestFromFavorites"//We give our selected restaurant to next page
        {
            let destinationVC = segue.destination as! SelectedOneViewController
            destinationVC.selectedRestaurant = self.selectedRestaurant
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return 38}
        
}

