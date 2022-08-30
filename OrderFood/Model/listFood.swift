//
//  listFood.swift
//  OrderFood
//
//  Created by ThanhThuy on 09/08/2022.
//

import Foundation

struct listFood : Codable {
    let id: Int
    let nameFood: String
    let price: Int
    let describe: String
    let imageFood: String
    var amount: Int
}
