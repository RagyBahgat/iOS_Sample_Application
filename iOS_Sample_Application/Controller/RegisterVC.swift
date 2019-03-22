//
//  RegisterLoginVC.swift
//  iOS_Sample_Application
//
//  Created by Ragy Bahgat on 3/21/19.
//  Copyright © 2019 Ragy Bahgat. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterVC: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func tableViewTapped() {
        firstNameTextField.endEditing(true)
        lastNameTextField.endEditing(true)
        ageTextField.endEditing(true)
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "Registering")
        
        if emailTextField.text! == "" || passwordTextField.text! == "" || firstNameTextField.text! == "" || lastNameTextField.text == "" || ageTextField.text! == "" {
            SVProgressHUD.dismiss()
            displayAlert(alertControllerTitle: "Missing Entries", alertControllerMessage: "Please enter all information", alertActionTitle: "OK")
            return
        }else if Int(ageTextField.text!) == nil{
            SVProgressHUD.dismiss()
            displayAlert(alertControllerTitle: "Invalide age", alertControllerMessage: "Please check age entry", alertActionTitle: "OK")
            return
        }
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (daraResult, error) in
            
            if error != nil {
                SVProgressHUD.dismiss()
                self.displayAlert(alertControllerTitle: "Registration Failed", alertControllerMessage: "Please check your entries for invalid data", alertActionTitle: "ok")
                print(error!)
            }else{
                print("Registration Successful")
                
                let rootRef = Database.database().reference().root.child("Users")
                
                let userValues: [String: Any] = ["Email": self.emailTextField.text!, "First Name": self.firstNameTextField.text!, "Last Name": self.lastNameTextField.text!, "Age": Int(self.ageTextField.text!)!]
                
                rootRef.child((Auth.auth().currentUser?.uid)!).setValue(userValues, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                })
                print("success")
                
                self.firstNameTextField.text = ""
                self.lastNameTextField.text = ""
                self.ageTextField.text = ""
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                SVProgressHUD.showSuccess(withStatus: "User Successfully Registered")
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
