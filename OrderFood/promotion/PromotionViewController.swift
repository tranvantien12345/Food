//
//  PromotionViewController.swift
//  OrderFood
//
//  Created by ThanhThuy on 25/08/2022.
//

import UIKit

class PromotionViewController: UIViewController {
    
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var promotionCollectionView: UICollectionView!
    @IBOutlet weak var promotionHeight: NSLayoutConstraint!
    
    
    let category : [String] = ["cơm", "Bún/Phở","Đồ uống","Ăn nhanh","Ăn vặt", "Lẩu"]
    var category1 : [String] = ["cơm", "Bún/Phở","Đồ uống","Ăn nhanh","Ăn vặt", "Lẩu"]
    let UrlRice = "https://gokisoft.com/api/fake/1128/promotion/rice"
    let UrlRiceNoodle = "https://gokisoft.com/api/fake/1128/promotion/ricenoodle"
    let UrlDrink = "https://gokisoft.com/api/fake/1128/promotion/drink"
    let UrlEatFast = "https://gokisoft.com/api/fake/1128/promotion/eatfast"
    let UrlSnack = "https://gokisoft.com/api/fake/1128/promotion/snacks"
    let UrlHotPot = "https://gokisoft.com/api/fake/1128/promotion/hotpot"
    
    var selectedIndex = Int ()
    
    var promotionList = [Shop]()
//    var listDataShop = [Shop]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        promotionCollectionView.dataSource = self
        promotionCollectionView.delegate = self
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
       // getDataPromotion()
        getListPromotion(linkUrl: UrlRice)

    }
    override func viewDidLayoutSubviews() {
        chageCollectionHeight()
    }
    
   
    
}

extension PromotionViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func chageCollectionHeight()  {
        self.promotionHeight.constant = self.promotionCollectionView.contentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollectionView {
            return category.count
        } else if collectionView == self.promotionCollectionView {
            return promotionList.count
        }
        return 0
        

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoryCollectionView {
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "promotionCategory", for: indexPath) as! PromotionCategoryCell
            cell.nameCategoryPromotion.text = category[indexPath.row]
            cell.layer.cornerRadius = 30
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.black.cgColor

            if selectedIndex == indexPath.row
                {
                    cell.backgroundColor = UIColor(red: 0.95, green: 0.47, blue: 0.47, alpha: 1.00)
                }
                else
                {
                    cell.backgroundColor = UIColor.white
                }
            return cell
        } else if collectionView == self.promotionCollectionView {
            let cellPromotion = promotionCollectionView.dequeueReusableCell(withReuseIdentifier: "promotion", for: indexPath) as! PromotionCell

//            cellPromotion.backgroundColor = UIColor.blue
            
            
            let url = URL(string: promotionList[indexPath.row].imageShop)
            cellPromotion.image.downloadImage(from: url!)
            cellPromotion.name.text = promotionList[indexPath.row].nameShop
            cellPromotion.vote.text = String(promotionList[indexPath.row].vote)
            cellPromotion.location.text = String(promotionList[indexPath.row].location) + " km"
            
            cellPromotion.layer.cornerRadius =  20
            cellPromotion.layer.borderWidth = 1
            cellPromotion.layer.borderColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.00).cgColor
            return cellPromotion
        }



        return UICollectionViewCell()

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        if collectionView == self.categoryCollectionView {
           // let withh = category[indexPath.row].size(with: UIFont).width + 10
            
            
            let withh =  NSAttributedString(string: category[indexPath.row])
            let height = 53.0
            let with = 100.0
            return CGSize(width: withh.size().width + 50.0, height: height)
        }
        else if collectionView == self.promotionCollectionView {
            let with = (collectionView.frame.size.width) / 2
            return CGSize(width: with, height: 245.0)
        }
        return CGSize()

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoryCollectionView {
            selectedIndex = indexPath.row
            self.categoryCollectionView.reloadData()
            if selectedIndex == 0 {
                getListPromotion(linkUrl: UrlRice)
            }
            if selectedIndex == 1 {
                getListPromotion(linkUrl: UrlRiceNoodle)
            }
            if selectedIndex == 2 {
                getListPromotion(linkUrl: UrlDrink)
            }
            if selectedIndex == 3 {
                getListPromotion(linkUrl: UrlEatFast)
            }
            if selectedIndex == 4 {
                getListPromotion(linkUrl: UrlSnack)
            }
            if selectedIndex == 5 {
                getListPromotion(linkUrl: UrlHotPot)
            }
            
            self.categoryCollectionView.reloadData()
        } else if collectionView == self.promotionCollectionView {
            let intent = storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
            intent.shopDetail = promotionList[indexPath.row]
            self.navigationController?.pushViewController(intent, animated: true)
        }
            
                }
    
    func getListPromotion(linkUrl : String) {
        let linkUrl = linkUrl
        let url = URL(string: linkUrl)
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            guard let data = data, error == nil else {
                print("error ")
                return
            }
            print("thanh cong")
            do{
                self.promotionList = try JSONDecoder().decode([Shop].self, from: data)
                
            }catch {
                print("lỗi json \(error)")
            }
            DispatchQueue.main.async {
                self.promotionCollectionView.reloadData()

            }
        })
        task.resume()
    }
    
    

}


