//
//  LoginVC.swift
//  iOS_Sample_Application
//
//  Created by Ragy Bahgat on 3/22/19.
//  Copyright © 2019 Ragy Bahgat. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tableViewTapped() {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    @IBAction func loginUser(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Loggin In")
        
        if emailTextField.text! == "" || passwordTextField.text! == "" {
            
            SVProgressHUD.dismiss()
            
            displayAlert(alertControllerTitle: "Missing Entries", alertControllerMessage: "Please enter all information", alertActionTitle: "OK")
            return
        }
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                SVProgressHUD.dismiss()
                
                self.displayAlert(alertControllerTitle: "Login Failed", alertControllerMessage: "Please check your entries for invalid data", alertActionTitle: "ok")
                print(error!)
                
            }else {
                print("Success")
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                
                SVProgressHUD.showSuccess(withStatus: "Logged in")
                SVProgressHUD.dismiss(withDelay: 2)
                self.performSegue(withIdentifier: "goToUsers", sender: self)
            }
        }
    }
    
    func displayAlert(alertControllerTitle: String, alertControllerMessage: String, alertActionTitle: String){
        let alertController = UIAlertController(title: alertControllerTitle, message: alertControllerMessage, preferredStyle: .alert)
        let alertAcion = UIAlertAction(title: alertActionTitle, style: .cancel, handler: nil)
        alertController.addAction(alertAcion)
        present(alertController, animated: true, completion: nil)
    }
}
