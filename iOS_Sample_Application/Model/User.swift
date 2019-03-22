//
//  User.swift
//  iOS_Sample_Application
//
//  Created by Ragy Bahgat on 3/21/19.
//  Copyright © 2019 Ragy Bahgat. All rights reserved.
//

import UIKit

class User: Equatable {
    
    var firstName: String
    var lastName: String
    var age: Int
    var email: String
    
    init(firstName: String, lastName: String, age: Int, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.email = email
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        if lhs.firstName == rhs.firstName , lhs.lastName == rhs.lastName, lhs.age == rhs.age, lhs.email == rhs.email {
            return true
        }
        return false
    }
}
