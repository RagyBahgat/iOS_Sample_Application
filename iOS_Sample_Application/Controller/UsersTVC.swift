//
//  UsersTVC.swift
//  iOS_Sample_Application
//
//  Created by Ragy Bahgat on 3/21/19.
//  Copyright © 2019 Ragy Bahgat. All rights reserved.
//

import UIKit
import Firebase

class UsersTVC: UITableViewController {
    
    var users = [User]()
    var userToSend: User?
    var currentUser: User?
    let usersRef = Database.database().reference().root.child("Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        let logOutBarButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector (self.logOutUser(sender:)))
        let displayCurrentUserBarButton = UIBarButtonItem(title: "My Profile", style: .plain, target: self, action: #selector(self.displayCurrentUserDetails(sender:)))
        self.navigationItem.leftBarButtonItem = logOutBarButton
        self.navigationItem.rightBarButtonItem = displayCurrentUserBarButton
        
        checkUserLoggedIn()
        loadUsers()
    }
    
    func checkUserLoggedIn() {
        if let uid = Auth.auth().currentUser?.uid {
            usersRef.child(uid).observeSingleEvent(of: .value) { (snapshot) in
                if let values = snapshot.value as? [String: Any] {
                    self.navigationItem.title = values["First Name"] as? String
                    self.currentUser = User(firstName: values["First Name"] as! String, lastName: values["Last Name"] as! String, age: values["Age"] as! Int, email: values["Email"] as! String)
                }
            }
        }
    }
    
    func loadUsers() {
        usersRef.observe(.childAdded) { (snapshot) in
            if let values = snapshot.value as? [String: Any] {
                let user = User(firstName: values["First Name"] as! String, lastName: values["Last Name"] as! String, age: values["Age"] as! Int, email: values["Email"] as! String)
                if self.currentUser != user {
                    self.users.append(user)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func logOutUser(sender: UIBarButtonItem){
        do{
            try Auth.auth().signOut()
            self.navigationController?.popViewController(animated: true)
        }catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @objc func displayCurrentUserDetails(sender: UIBarButtonItem){
        userToSend = currentUser
        performSegue(withIdentifier: "goToUserDetails", sender: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let nameLabel = cell.viewWithTag(1000) as! UILabel
        nameLabel.text = ("\(users[indexPath.row].firstName) \(users[indexPath.row].lastName)")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userToSend = users[indexPath.row]
        performSegue(withIdentifier: "goToUserDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUserDetails" {
            let destination = segue.destination as! UserDetailsVC
            destination.user = userToSend
        }
    }
}
