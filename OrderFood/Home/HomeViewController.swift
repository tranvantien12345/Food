//
//  HomeViewController.swift
//  OrderFood
//
//  Created by ThanhThuy on 04/08/2022.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate{
    
    @IBOutlet weak var slideCollection: UICollectionView!
    @IBOutlet weak var ShopCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    var locationManager : CLLocationManager!
    var location :UILabel!
    
    var currentCellIndex = 0
    var imgSlider = ["lau","nuong","anvat"]
    var timer : Timer?
    
    let arr : [String] = ["cơm", "Bún/Phở","Đồ uống","Ăn nhanh","Ăn vặt", "Lẩu", "Đặc sản", "Healthy"]
    let ImageArr : [String] = ["rice", "bun","douong","annhanh","anvat-1","donuong", "dacsann", "healthy"]
    
    var shopData = [Shop]()

    override func viewDidLoad() {
        super.viewDidLoad()

        pageController.numberOfPages = imgSlider.count
        
        slideCollection.dataSource = self
        slideCollection.delegate = self
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        ShopCollectionView.dataSource = self
        ShopCollectionView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        getLocation()

        setupNavBar()
        setTimer()
        fechData()
    }

    func fechData () {
        
        let linkUrl = "https://gokisoft.com/api/fake/1128/shop/list"
        let url = URL(string: linkUrl)
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            guard let data = data, error == nil else {
                print("error ")
                return
            }
            //print(data)
            print("thanh cong")
            do{
                self.shopData = try JSONDecoder().decode([Shop].self, from: data)
                print(self.shopData.count)
            }catch {
                print("lỗi json \(error)")
            }
            DispatchQueue.main.async {
                self.ShopCollectionView.reloadData()
                print(self.shopData.count)

            }
        })
        task.resume()
        
    }

    func setTimer (){
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(slideToNext), userInfo:  nil, repeats: true)
    }
    
    @objc func slideToNext (){
        if currentCellIndex < imgSlider.count - 1
        {
            currentCellIndex = currentCellIndex + 1
        }else {
             currentCellIndex = 0
        }
        pageController.currentPage = currentCellIndex
        slideCollection.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .right, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.slideCollection {
            return imgSlider.count
        }else if collectionView == self.categoryCollectionView {
            return ImageArr.count
        }else if collectionView == self.ShopCollectionView {
            return shopData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.slideCollection {
            let cell = slideCollection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SlideCollectionViewCell
            cell.imageSlide.image = UIImage(named: imgSlider[indexPath.row])
             return cell
        }else if collectionView == self.categoryCollectionView {
            let cellCategory = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryViewCell
            cellCategory.imageCategory.image = UIImage(named: ImageArr[indexPath.row])
            cellCategory.nameCategory.text = arr[indexPath.row]
            return cellCategory
        }else if collectionView  == self.ShopCollectionView {
            let cellShop = ShopCollectionView.dequeueReusableCell(withReuseIdentifier: "ShopCell", for: indexPath) as! ShopCollectionViewCell
            let url = URL(string: shopData[indexPath.row].imageShop)
            cellShop.imgShop.downloadImage(from: url!)
            cellShop.txtNameShop.text = shopData[indexPath.row].nameShop
            cellShop.txtVote.text = String(shopData[indexPath.row].vote)
            cellShop.txtLocation.text = String(shopData[indexPath.row].location) + " km"
            return cellShop
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.slideCollection {
            return CGSize(width:  slideCollection.frame.width, height: slideCollection.frame.height)
        }else if collectionView == self.categoryCollectionView {
            let size = (collectionView.frame.size.width )/4
            let sizeHight = (collectionView.frame.size.height )/2
            return CGSize(width: size, height: sizeHight)
        }else if collectionView == self.ShopCollectionView {
            return CGSize(width:  374, height: 120)
        }
        return CGSize()

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoryCollectionView {
            print("position Category:   \(indexPath)")

        }else if collectionView == self.ShopCollectionView {
            print("position shop:   \(indexPath)")
            let intent = storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
            intent.shopDetail = shopData[indexPath.row]
            self.navigationController?.pushViewController(intent, animated: true)
        }

    }
    private func setupNavBar() {
        let viewTitle = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        let lableText = UILabel(frame: CGRect(x: 10, y: 0, width: 70, height: 20))
        lableText.text = "Giao đến"
        lableText.font = lableText.font.withSize(13)
        lableText.textColor = UIColor(red: 0.95, green: 0.47, blue: 0.47, alpha: 1.00)
        viewTitle.addSubview(lableText)
        
        location = UILabel(frame: CGRect(x: 10, y: 24, width: viewTitle.frame.width, height: 20))
        location.font = location.font.withSize(16)
        location.textColor = UIColor(red: 0.95, green: 0.47, blue: 0.47, alpha: 1.00)

        viewTitle.addSubview(location)
        navigationItem.titleView = viewTitle
        
    }
    
    func getLocation () {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("Location Enable")
            locationManager.startUpdatingLocation()
        }else {
            print("Location not enable")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as! CLLocation
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error ) in
            if error != nil {
                print("error reverseGeocodeLocation")
            }
        let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                let locatily = placemark.locality!
                let admin = placemark.administrativeArea!
                let country = placemark.country!
                self.location.text = "\(locatily), \(admin), \(country)"
            }
            
        }
    }
}



