//
//  User.swift
//  KonumLA
//
//  Created by Eray İnal on 21.07.2024.
//

import Foundation
import FirebaseAuth

struct User {
    
    let uid: String
    let username: String
    var profileImageURL: String
    let bio: String
    var postCount: Int
    
    
    
    
}




class AuthService{
    
    static let shared = AuthService()
        
        
        
}
