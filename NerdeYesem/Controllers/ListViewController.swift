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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{return listNearRestaurants.count}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
          let cell = tableView.dequeueReusableCell(withIdentifier: "restCell", for: indexPath) as! RestCell
          cell.nameLabel.text = self.listNearRestaurants[indexPath.row].getName()
          cell.cuisineLabel.text = self.listNearRestaurants[indexPath.row].getCuisines()
          return cell
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
