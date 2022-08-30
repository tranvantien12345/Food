//
//  ShopData.swift
//  OrderFood
//
//  Created by ThanhThuy on 09/08/2022.
//

import Foundation

struct Shop : Codable {
    let id: Int
    let nameShop: String
    let vote: Double
    let location: Double
    let imageShop: String
    let listFood:[listFood]
    
    
}

