//
//  ViewController.swift
//  OrderFood
//
//  Created by ThanhThuy on 28/07/2022.
//

import UIKit
import SQLite
import FirebaseAuth

class ViewController: UIViewController {
    
        
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewRigister: UIView!
    @IBOutlet weak var viewTheme: UIView!

    @IBOutlet weak var btnLoginTab: UIButton!
    @IBOutlet weak var btnRigisterTab: UIButton!
    
    @IBOutlet weak var btnLoginOutlet: UIButton!
    @IBOutlet weak var btnRigisterOutlet: UIButton!
    
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtEmailRegister: UITextField!
    
    @IBOutlet weak var txtPassRegister: UITextField!
    
    @IBOutlet weak var confirmPass: UITextField!
    
    
    
    @IBOutlet weak var imageBanner: UIImageView!


    
    var foodListTien = [listFood]()


    override func viewDidLoad() {
        super.viewDidLoad()
        created()
        checkLogin()


            
    
        let gradientLayout = CAGradientLayer()
        gradientLayout.frame = view.bounds
        gradientLayout.colors = [
            UIColor(red: 0.95, green: 0.47, blue: 0.47, alpha: 1.00).cgColor,
            UIColor(red: 1.00, green: 0.98, blue: 0.98, alpha: 1.00).cgColor ,
                ]
        view.layer.insertSublayer(gradientLayout, at: 0)
        
        viewTheme.layer.cornerRadius = 30
        viewTheme.layer.borderColor = UIColor.black.cgColor
        viewTheme.layer.borderWidth = 1

        btnLoginTab.layer.borderWidth = 1
        btnLoginTab.layer.borderColor = UIColor.black.cgColor
        btnLoginTab.layer.cornerRadius = 20
        btnLoginTab.layer.backgroundColor = UIColor(red: 0.95, green: 0.47, blue: 0.47, alpha: 1.00).cgColor

        btnRigisterTab.layer.borderWidth = 1
        btnRigisterTab.layer.borderColor = UIColor.black.cgColor
        btnRigisterTab.layer.cornerRadius = 20
        
        btnLoginOutlet.layer.cornerRadius = 20
        btnLoginOutlet.layer.shadowRadius = 5.0
        btnLoginOutlet.layer.shadowOpacity = 0.35
        btnLoginOutlet.layer.shadowOffset = CGSize(width: 0, height: 3)
        btnRigisterOutlet.layer.cornerRadius = 20
        btnRigisterOutlet.layer.shadowRadius = 5.0
        btnRigisterOutlet.layer.shadowOpacity = 0.35
        btnRigisterOutlet.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        viewRigister.isHidden = true

    }
    
    @IBAction func listenerLogin(_ sender: Any) {
        viewLogin.isHidden = false
        viewRigister.isHidden = true
        
        
        btnRigisterTab.layer.backgroundColor = UIColor.white.cgColor
        btnLoginTab.layer.backgroundColor = UIColor(red: 0.95, green: 0.47, blue: 0.47, alpha: 1.00).cgColor
 
    }
    @IBAction func listenerRigister(_ sender: Any) {
        viewLogin.isHidden = true
        viewRigister.isHidden = false
       
        
        btnLoginTab.layer.backgroundColor = UIColor.white.cgColor
        btnRigisterTab.layer.backgroundColor = UIColor(red: 0.95, green: 0.47, blue: 0.47, alpha: 1.00).cgColor
    }
    func created () {
        let database  = SQLDataBase.sharedInstance
        database.createTable()
    }
    

    @IBAction func Login(_ sender: Any) {
        
        guard let email = txtEmail.text, let pass = txtPassword.text else {
            print("lỗi")
            return
        }
        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
            guard let user = authResult?.user, error == nil else {
                print("lỗi")
                return
            }
            print("Thành công")
            self!.performSegue(withIdentifier: "home", sender: nil)

        }

    }
    
    @IBAction func Rigister(_ sender: Any) {
        guard let email = txtEmailRegister.text, let password = txtPassRegister.text else {
            return
        }
        Auth.auth().createUser(withEmail: email, password:password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                print("lỗi đăngkys")
                return
            }
                print("created success")
        }
    }
    
    
    func checkLogin() {

        let handle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("đã login")
                self.performSegue(withIdentifier: "home", sender: nil)
                
            }else {
                print("chưa login")
                return
            }

        }
    }
}

