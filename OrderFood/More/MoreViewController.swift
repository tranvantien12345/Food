//
//  MoreViewController.swift
//  OrderFood
//
//  Created by ThanhThuy on 20/08/2022.
//

import UIKit
import FirebaseAuth

class MoreViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var selectCamera: UIImageView!
    @IBOutlet weak var editInformation: UIView!
    @IBOutlet weak var chagePassword: UIView!
    @IBOutlet weak var logOut: UIView!
    
    @IBOutlet weak var nameInfor: UILabel!
    @IBOutlet weak var emailInfor: UILabel!
    
    var image: UIImage!
    
    let user = Auth.auth().currentUser


    override func viewDidLoad() {
        super.viewDidLoad()
        openLibrary()
        saveAvatar()
        moveEditInfor()
        moveChagePass()
        tappedLogOut()
    }
    override func viewDidAppear(_ animated: Bool) {
        getInformation()
    }
    func openLibrary() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTappedLibrary(sender:)))
        selectCamera.isUserInteractionEnabled = true
        selectCamera.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTappedLibrary(sender : UITapGestureRecognizer) {
       print("bạn đã click vào ảnh")
        
        let AlertController = UIAlertController(title: "Chụp ảnh", message: "Chọn ảnh từ", preferredStyle: .actionSheet)
        AlertController.dismiss(animated: true)
        let cameraBtn = UIAlertAction(title: "Camera", style: .default) { [weak self] (_) in
            print("Camera")
            self?.showImagePiker(selected: .camera)
        }
        let libraryBtn = UIAlertAction(title: "Chọn ảnh từ thư viện", style: .default) { [weak self] (_) in
            print("chọn ảnh từ thư viện")
            self?.showImagePiker(selected: .photoLibrary)
        }
        let CancelBtn = UIAlertAction(title: "Hủy", style: .default) { [weak self] (_) in
            AlertController.dismiss(animated: true)
        }
        AlertController.addAction(cameraBtn)
        AlertController.addAction(libraryBtn)
        AlertController.addAction(CancelBtn)
        self.present(AlertController, animated: true, completion: nil)
    }
    
    func showImagePiker(selected : UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(selected) else {
            print("chọn ảnh thất bại")
            return
        }
        let ImagePickerController = UIImagePickerController()
        ImagePickerController.delegate = self
        ImagePickerController.sourceType = selected
        ImagePickerController.allowsEditing = false
        self.present(ImagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] else {
            return
        }
        image = selectedImage as? UIImage
        selectCamera.image = image
        guard let data = image.jpegData(compressionQuality: 0.1) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        UserDefaults.standard.set(encoded, forKey: "KEY_IMAGE")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
    func saveAvatar() {
        guard let data = UserDefaults.standard.data(forKey: "KEY_IMAGE") else { return }
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        let imageSave = UIImage(data: decoded)
        selectCamera.image = imageSave
    }
    func moveEditInfor() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(inForTapped(sender:)))
        editInformation.isUserInteractionEnabled = true
        editInformation.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func inForTapped (sender : UITapGestureRecognizer) {
        let intent = storyboard?.instantiateViewController(withIdentifier: "editInfor") as! EditInForViewController
        self.navigationController?.pushViewController(intent, animated: true)
    }
    
    func moveChagePass() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chagePassTapped(sender:)))
        chagePassword.isUserInteractionEnabled = true
        chagePassword.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func chagePassTapped (sender : UITapGestureRecognizer) {
        let intent = storyboard?.instantiateViewController(withIdentifier: "chagePass") as! ChagePassViewController
        self.navigationController?.pushViewController(intent, animated: true)
    }
    
    func getInformation() {
        if let user = user {
          let email = user.email
            emailInfor.text = email
            nameInfor.text = user.displayName ?? ""            
        }
    }
   
    func tappedLogOut() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(logOutTapped(sender:)))
        logOut.isUserInteractionEnabled = true
        logOut.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func logOutTapped (sender : UITapGestureRecognizer) {

        
        logOutAlertController()
    }

    func logOutAlertController() {
        let alertController =  UIAlertController(title: "Đăng xuất", message: "Bạn có muốn thoát ứng dụng", preferredStyle: .actionSheet)
        
        let confirmBtn = UIAlertAction(title: "Xác nhận", style: .default) { [weak self] (_) in
            print("xác nhận")
            let firebaseAuth = Auth.auth()
             do {
               try firebaseAuth.signOut()
             } catch let signOutError as NSError {
               print("Error signing out: %@", signOutError)
             }
            self!.performSegue(withIdentifier: "login", sender: nil)
            
        }
        let cancelBtn = UIAlertAction(title: "Hủy", style: .default) { [weak self] (_) in
            print("hủy")
            alertController.dismiss(animated: true)
        }
        let CancelBtn = UIAlertAction(title: "Hủy", style: .default) { [weak self] (_) in
        }
        alertController.addAction(confirmBtn)
        alertController.addAction(CancelBtn)
        self.present(alertController, animated: true, completion: nil)
        
    }
}
