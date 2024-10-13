//
//  UserManager.swift
//  KonumLA
//
//  Created by Eray İnal on 11.10.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class UserManager{
    
    static let shared = UserManager()
    
    var nameAndSurname : String?
    var profileImageUrl : String?
    
    private init(){
        
    }
    
    func fetchUserData(completion: @escaping (Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        let firestoreDatabase = Firestore.firestore()
        let firestoreReference = firestoreDatabase.collection("Users").document(currentUid)
        
        firestoreReference.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.nameAndSurname = data?["nameAndSurname"] as? String
                self.profileImageUrl = data?["profileImageUrl"] as? String
                completion(true)
            } else {
                print("Error fetching user data: \(error?.localizedDescription ?? "No error info")")
                completion(false)
            }
        }
    }
    
    
    
    
    
    
    
    
}
