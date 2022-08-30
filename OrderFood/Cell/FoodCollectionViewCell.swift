//
//  FoodCollectionViewCell.swift
//  OrderFood
//
//  Created by ThanhThuy on 12/08/2022.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewFood: UIView!
    
    @IBOutlet weak var imageFood: UIImageView!
    
    @IBOutlet weak var priceFood: UILabel!
    @IBOutlet weak var nameFood: UILabel!
    
    
    @IBOutlet weak var addToCart: UIImageView!
}
