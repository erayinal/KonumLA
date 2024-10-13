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
    var nameAndSurname: String
    var username: String
    let gender: String
    var profileImageURL: String?
    let bio: String
    
    var sharedEventArr: [String] = []
    var savedEventArr: [String] = []
    
    init(uid: String, nameAndSurname:String, username: String, gender: String, profileImageURL: String?, bio: String) {
        self.uid = uid
        self.nameAndSurname = nameAndSurname
        self.username = username
        self.gender = gender
        self.profileImageURL = profileImageURL
        self.bio = bio
    }
    
    
}




class AuthService{
    
    static let shared = AuthService()
        
}
