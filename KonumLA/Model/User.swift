//
//  User.swift
//  KonumLA
//
//  Created by Eray İnal on 21.07.2024.
//

import Foundation

struct User {
    
    let uid: String
    let username: String
    var profileImageURL: String
    let bio: String
    var postCount: Int
    
}




import FirebaseAuth

class AuthService{
    
    static let shared = AuthService()
        
        
        
}
