//
//  CartViewController.swift
//  OrderFood
//
//  Created by ThanhThuy on 15/08/2022.
//

import UIKit
import SQLite

class CartViewController: UIViewController {
    @IBOutlet weak var totalCart: UILabel!
    @IBOutlet weak var cartCollectionView: UICollectionView!
    
    var listCart = [listFood]()
    var totalAll = 0
    let fomat  = Fomat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartCollectionView.dataSource = self
        cartCollectionView.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        listCart = entityFood.getListRow()!
        self.cartCollectionView.reloadData()
        totalFood()
    }
 
}
extension CartViewController : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCart.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
            let cartCell =  cartCollectionView.dequeueReusableCell(withReuseIdentifier: "CartCell", for: indexPath) as! CartCollectionViewCell
            let url = URL(string: listCart[indexPath.row].imageFood)
            let price = fomat.formatNumberMoney(price: listCart[indexPath.row].price)
            cartCell.imageCart.downloadImage(from: url!)
            cartCell.nameFoodCart.text = listCart[indexPath.row].nameFood
            cartCell.priceCart.text = price
            cartCell.amountCart.text = String(listCart[indexPath.row].amount)
            cartCell.layer.cornerRadius = 15
            
            
            let tapGestureRecognizerPlus = UITapGestureRecognizer(target: self, action: #selector(plusTapped(sender:)))
            cartCell.plusCart.isUserInteractionEnabled = true
            cartCell.plusCart.tag = indexPath.row
            cartCell.plusCart.addGestureRecognizer(tapGestureRecognizerPlus)
            
            let tapGestureRecognizerMinus = UITapGestureRecognizer(target: self, action: #selector(minusTapped(sender:)))
            cartCell.minusCart.isUserInteractionEnabled = true
            cartCell.minusCart.tag = indexPath.row
            cartCell.minusCart.addGestureRecognizer(tapGestureRecognizerMinus)
                                
            return cartCell
            
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let withSize = collectionView.frame.size.width
      
        return CGSize(width: withSize, height: 90)
    }
    
    @objc func plusTapped(sender : UITapGestureRecognizer) {
        let index = IndexPath(row: sender.view!.tag, section: 0)
        print("ban da click plus \(listCart[index.row].nameFood)")
        print("ban da click plus \(listCart[index.row].amount)")
        listCart[index.row].amount  = (listCart[index.row].amount + 1)
        self.cartCollectionView.reloadItems(at: [index])
        entityFood.updateFoodAmount(amountUpdate:  listCart[index.row].amount, idUpdate:  listCart[index.row].id)
        
        totalAll = totalAll + listCart[index.row].price
        totalCart.text = fomat.formatNumberMoney(price: totalAll)

    }
    
    @objc func minusTapped(sender : UITapGestureRecognizer) {
        let index = IndexPath(row: sender.view!.tag, section: 0)
        listCart[index.row].amount  = (listCart[index.row].amount - 1)
        self.cartCollectionView.reloadItems(at: [index])
        entityFood.updateFoodAmount(amountUpdate:  listCart[index.row].amount, idUpdate:  listCart[index.row].id)
        totalAll = totalAll - listCart[index.row].price
        totalCart.text = fomat.formatNumberMoney(price: totalAll)
       
//        if listCart[index.row].amount < 1 {
//            entityFood.deleteFood(idFood: listCart[index.row].id)
//            var list = [listFood]()
//            list = entityFood.getListRow()!
//            listCart = list
//        }
//        self.cartCollectionView.reloadData()

        print("index \(index.row)")
        

        

    
    }
    func totalFood() {
        totalAll = 0
        listCart = entityFood.getListRow()!
        listCart.forEach { (food) in
            totalAll += food.amount * food.price
        }
        totalCart.text = fomat.formatNumberMoney(price: totalAll)
    }
}




