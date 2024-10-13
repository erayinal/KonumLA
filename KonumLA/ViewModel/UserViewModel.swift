//
//  UserViewModel.swift
//  KonumLA
//
//  Created by Eray İnal on 27.07.2024.
//

import Foundation
import FirebaseAuth

class UserViewModel {
    
    
    
    func checkUserPassword(password: String, completion: @escaping (Bool, Error?) -> Void) {
            guard let user = Auth.auth().currentUser else {
                // Kullanıcı oturum açmamış
                completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturum açmamış."]))
                return
            }
            
            guard let email = user.email else {
                // Kullanıcı e-postası bulunamadı
                completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı e-postası bulunamadı."]))
                return
            }
            
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            
            user.reauthenticate(with: credential) { authResult, error in
                if let error = error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        }
    
    
    
    func changeUserPassword(currentEmail: String, currentPassword: String, newPassword: String, completion: @escaping (Bool, Error?) -> Void) {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: currentPassword)
        
        user?.reauthenticate(with: credential, completion: { authResult, error in
            if let error = error {
                completion(false, error)
            } else {
                user?.updatePassword(to: newPassword, completion: { error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        completion(true, nil)
                    }
                })
            }
        })
    }
    
    
    
    func changeUserEmail(currentEmail: String, currentPassword: String, newEmail: String, completion: @escaping (Bool, Error?) -> Void) {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: currentPassword)
        
        user?.reauthenticate(with: credential, completion: { authResult, error in
            if let error = error {
                completion(false, error)
            } else {
                user?.updateEmail(to: newEmail, completion: { error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        completion(true, nil)
                    }
                })
            }
        })
    }
    
    
    
    
    
}
