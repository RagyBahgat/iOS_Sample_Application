//
//  UserDetailsVC.swift
//  iOS_Sample_Application
//
//  Created by Ragy Bahgat on 3/21/19.
//  Copyright © 2019 Ragy Bahgat. All rights reserved.
//

import UIKit

class UserDetailsVC: UIViewController {
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameLabel.text = user?.firstName
        lastNameLabel.text = user?.lastName
        ageLabel.text = String(describing: (user?.age)!)
        emailLabel.text = user?.email
        
    }


}
