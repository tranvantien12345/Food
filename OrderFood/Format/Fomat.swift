//
//  Fomat.swift
//  OrderFood
//
//  Created by ThanhThuy on 17/08/2022.
//

import Foundation

struct Fomat {
    func formatNumberMoney (price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "VND"
        let result = formatter.string(from: price as NSNumber)!
        return result
    }
}
