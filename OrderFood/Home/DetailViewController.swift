//
//  ViewController.swift
//  OrderFood
//
//  Created by ThanhThuy on 09/08/2022.
//

import UIKit
import Foundation
import SQLite
class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var scrollDetail: UIScrollView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageTop: NSLayoutConstraint!
    
    @IBOutlet weak var shadownView: UIView!
    @IBOutlet weak var nameShop: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var vote: UILabel!
    @IBOutlet weak var foodCollectionVIew: UICollectionView!
    @IBOutlet weak var viewFood: UIView!
    
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    private var originalHeight: CGFloat = 300
    var shopDetail: Shop!
    var foodList = [listFood]()
    let fomat = Fomat()
    let dataBase = SQLDataBase.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.95, green: 0.47, blue: 0.47, alpha: 1.00)]
        scrollDetail.delegate = self
        scrollDetail.contentInsetAdjustmentBehavior = .never
        
        foodList = shopDetail.listFood
        
        foodCollectionVIew.dataSource = self
        foodCollectionVIew.delegate = self
        
        dataBase.createTable()
        
        setInforShop()
        setShadownView()
    }
//    override func viewDidLayoutSubviews() {
//        chageCollectionHeight()
//    }
//    
//    func chageCollectionHeight()  {
//        self.collectionHeight.constant = self.foodCollectionVIew.contentSize.height
//    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollDetail.contentOffset.y)
        let offset = scrollDetail.contentOffset.y
              let defaultTop = CGFloat(0)
              var currentTop = defaultTop
              
              if scrollView == self.scrollDetail {
                  if offset <= 0 { // User scroll down
                      currentTop = offset
                      imageHeight.constant = originalHeight - offset
                      navigationItem.title = nil
                  } else {
                      imageHeight.constant = originalHeight
                      navigationItem.title = shopDetail.nameShop

                  }
                  imageTop.constant = currentTop

              }
    }
    func setInforShop () {
        let url = URL(string: shopDetail.imageShop)
        imageDetail.downloadImage(from: url!)
        nameShop.text =  shopDetail.nameShop
        location.text = String(shopDetail.location) + " km"
        vote.text = String(shopDetail.vote)
 
    }
    func setShadownView (){
        shadownView.layer.cornerRadius = 10
        //shadownView.layer.borderColor = UIColor.black.cgColor
        shadownView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadownView.layer.shadowRadius = 10.0
        shadownView.layer.shadowOpacity = 0.7

    }

}
extension DetailViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let foodCell = foodCollectionVIew.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodCollectionViewCell
        
        let url = URL(string: foodList[indexPath.row].imageFood)
        foodCell.imageFood.downloadImage(from: url!)
        foodCell.nameFood.text = foodList[indexPath.row].nameFood
        let price = fomat.formatNumberMoney(price: foodList[indexPath.row].price)
        foodCell.priceFood.text = price
        foodCell.layer.cornerRadius = 20
        foodCell.roundCorners([.topLeft, .topRight], radius: 20)
        foodCell.layer.shadowOffset = CGSize(width: 10, height: 20)
        foodCell.layer.shadowRadius = 10.0
        foodCell.layer.shadowOpacity = 1.8
        foodCell.layer.borderWidth = 1
        foodCell.layer.borderColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.00).cgColor
        // +======================
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        foodCell.addToCart.isUserInteractionEnabled = true
        foodCell.addToCart.tag = indexPath.row
        foodCell.addToCart.addGestureRecognizer(tapGestureRecognizer)
       

         return foodCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 10)/2
        return CGSize(width: size, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(foodList[indexPath.row].nameFood)
    }
    
    @objc func imageTapped(sender : UITapGestureRecognizer) {
        let index = IndexPath(row: sender.view!.tag, section: 0)
        print("ban da click \(foodList[index.row].nameFood)")
        let id = foodList[index.row].id
        let amount = foodList[index.row].amount
        let listCheck = entityFood.checkFood(idFood: id)
        if listCheck!.count == 0 || listCheck!.isEmpty {
            entityFood.insertRow(foodList[index.row])
        } else {
            entityFood.updateFoodAmount(amountUpdate: listCheck![0].amount + 1 , idUpdate: id)
        }
        entityFood.getListRow()
    }
}
