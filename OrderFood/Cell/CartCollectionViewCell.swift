//
//  CartCollectionViewCell.swift
//  OrderFood
//
//  Created by ThanhThuy on 15/08/2022.
//

import UIKit

class CartCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageCart: UIImageView!
    @IBOutlet weak var nameFoodCart: UILabel!
    @IBOutlet weak var priceCart: UILabel!
    @IBOutlet weak var minusCart: UIImageView!
    @IBOutlet weak var plusCart: UIImageView!
    @IBOutlet weak var amountCart: UILabel!
}
