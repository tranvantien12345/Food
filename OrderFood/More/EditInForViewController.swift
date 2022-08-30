//
//  EditInForViewController.swift
//  OrderFood
//
//  Created by ThanhThuy on 24/08/2022.
//

import UIKit
import FirebaseAuth


class EditInForViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtName: UITextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Lưu", style: .done, target: self, action: #selector(editInforTapped(_sender:)))
        getInfor()
    }
    
    func getInfor() {
        let handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.txtEmail.text = user.email
                self.txtName.text = user.displayName
                self.txtEmail.isUserInteractionEnabled = false
                self.txtEmail.alpha = 0.5
            }
        }
        
    }
    @objc func editInforTapped(_sender: Any) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .done, target: self, action:nil)
        updataName()
    }
    
    @objc func updataName() {
        let name = txtName.text!
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { error in
        }
        
        
    }
    
    

}
