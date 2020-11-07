//
//  Restaurant.swift
//  NerdeYesem
//
//  Created by Cem Sertkaya on 6.11.2020.
//  Copyright © 2020 Cem Sertkaya. All rights reserved.
//

import Foundation
class Restaurant
{
    private var id : String
    private var name : String
    private var url : String
    private var address :String
    private var image :String
    private var cuisines :String

    init(id :String, name :String, url: String, address: String, image: String, cuisines: String)
    {
        self.id = id
        self.name = name
        self.url = url
        self.address  = address
        self.image = image
        self.cuisines = cuisines
    }
    
    func getId() -> String {return self.id}
    func getName() -> String {return self.name}
    func getUrl() -> String {return self.url}
    func getAddress() -> String{return self.address}
    func getImage() -> String{return self.image}
    func getCuisines() -> String{return self.cuisines}
}
