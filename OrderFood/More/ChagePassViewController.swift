//
//  ChagePassViewController.swift
//  OrderFood
//
//  Created by ThanhThuy on 24/08/2022.
//

import UIKit
import FirebaseAuth

class ChagePassViewController: UIViewController {
    
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!
    
    
    @IBOutlet weak var showOlePass: UIImageView!
    @IBOutlet weak var showNewPass: UIImageView!
    @IBOutlet weak var showConfirmPass: UIImageView!
    
    var iconClickOlePass = true
    var iconClickNewPass = true
    var iconClickConfirmPass = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Lưu", style: .done, target: self, action: #selector(chagePassTapped(_sender:)))
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(showOlePasswordTapped(sender:)))
        showOlePass.isUserInteractionEnabled = true
        showOlePass.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(showNewPasswordTapped(sender:)))
        showNewPass.isUserInteractionEnabled = true
        showNewPass.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(showConfirmPasswordTapped(sender:)))
        showConfirmPass.isUserInteractionEnabled = true
        showConfirmPass.addGestureRecognizer(tapGestureRecognizer3)
        
        
        
        

    }
    @objc func chagePassTapped(_sender: Any) {
        let newPassword = txtNewPassword.text!
        let confirmPassword = txtConfirm.text!
        
        if newPassword == confirmPassword && !newPassword.isEmpty && !confirmPassword.isEmpty
        {
            Auth.auth().currentUser?.updatePassword(to: newPassword) { error in}
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .done, target: self, action:nil)
        } else
        {
            alertErrorController()
        }
        
    }
    @objc func showOlePasswordTapped (sender : UITapGestureRecognizer) {
        if iconClickOlePass
        {
            iconClickOlePass = false
            showOlePass.image = UIImage(named: "view")
            txtOldPassword.isSecureTextEntry = false
        } else
        {
            iconClickOlePass = true
            showOlePass.image = UIImage(named: "private")
            txtOldPassword.isSecureTextEntry = true
        }

    }
    @objc func showNewPasswordTapped (sender : UITapGestureRecognizer) {
        if iconClickNewPass
        {
            iconClickNewPass = false
            showNewPass.image = UIImage(named: "view")
            txtNewPassword.isSecureTextEntry = false
        } else
        {
            iconClickNewPass = true
            showNewPass.image = UIImage(named: "private")
            txtNewPassword.isSecureTextEntry = true
        }

    }
    @objc func showConfirmPasswordTapped (sender : UITapGestureRecognizer) {
        if iconClickConfirmPass
        {
            iconClickConfirmPass = false
            showConfirmPass.image = UIImage(named: "view")
            txtConfirm.isSecureTextEntry = false
        } else
        {
            iconClickConfirmPass = true
            showConfirmPass.image = UIImage(named: "private")
            txtConfirm.isSecureTextEntry = true
        }

    }
    func alertErrorController() {
        let alertController =  UIAlertController(title: "Lỗi", message: "Mật khẩu không khớp vui lòng nhập lại", preferredStyle: .alert)
        
        let confirmBtn = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(confirmBtn)
        self.present(alertController, animated: true, completion: nil)
    }
    
    

 

}
