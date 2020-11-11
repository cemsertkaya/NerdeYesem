//
//  ListViewController.swift
//  NerdeYesem
//
//  Created by Cem Sertkaya on 5.11.2020.
//  Copyright © 2020 Cem Sertkaya. All rights reserved.
//

import UIKit

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var listNearRestaurants = [Restaurant]()
    @IBOutlet weak var tableView: UITableView!
    var selectedRestaurant = Restaurant(id: "", name: "", url: "", address: "", image: "", cuisines: "")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    ///Classical table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{return listNearRestaurants.count}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
          let cell = tableView.dequeueReusableCell(withIdentifier: "restCell", for: indexPath) as! RestCell
          cell.nameLabel.text = self.listNearRestaurants[indexPath.row].getName()
          cell.cuisineLabel.text = self.listNearRestaurants[indexPath.row].getCuisines()
          return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.selectedRestaurant = self.listNearRestaurants[indexPath.row]
        performSegue(withIdentifier: "toShowRest", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toShowRest"//We give our selected restaurant to next page
        {
            let destinationVC = segue.destination as! SelectedOneViewController
            destinationVC.selectedRestaurant = self.selectedRestaurant
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return 38}

}



class RestCell: UITableViewCell
{

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    
    override func awakeFromNib() {super.awakeFromNib()}
    override func setSelected(_ selected: Bool, animated: Bool) {super.setSelected(selected, animated: animated)}
}
