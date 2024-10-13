//
//  SignUpController.swift
//  KonumLA
//
//  Created by Eray İnal on 22.07.2024.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class SignUpController: UIViewController {
    
    @IBOutlet weak var loginLabel: UILabel! //Giriş Yap metni
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordConfirmText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpController.loginLabelTapped))
        loginLabel.addGestureRecognizer(tapGesture)
        loginLabel.isUserInteractionEnabled = true
    }
    
    
    @objc func loginLabelTapped(){
        performSegue(withIdentifier: "toLoginPageFromSignup", sender: nil)
    }

    
    @IBAction func signUpButton(_ sender: Any) {
        
        if(nameText.text != "" && passwordText.text != "" && emailText.text != "" && passwordText.text != "" && passwordConfirmText.text != ""){
            if(passwordText.text == passwordConfirmText.text){
                
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                    if(error != nil){
                        self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Eror")
                    }else{
                        
                        let firestoreDatabase = Firestore.firestore()
                        var firestoreReference : DocumentReference? = nil
                        
                        let user = User(
                            uid: Auth.auth().currentUser?.uid ?? "",
                            nameAndSurname: self.nameText.text!,
                            username: self.usernameText.text!,
                            gender: "",
                            profileImageURL: "",
                            bio: ""
                        )
                        
                        let firestoreUser : [String: Any] = [
                            "uid": user.uid,
                            "nameAndSurname" : user.nameAndSurname,
                            "username" : user.username,
                            "profileImageUrl" : user.profileImageURL,
                            "bio" : user.bio,
                            "gender" : user.gender,
                        ]
                        
                        firestoreDatabase.collection("Users").document(user.uid).setData(firestoreUser){error in
                            if let error = error {
                                self.makeAlert(title: "ERROR!", message: error.localizedDescription)
                            }else{
                                self.performSegue(withIdentifier: "fromSignupToHomeVC", sender: nil)
                            }
                        }
                        
                        
                    }
                }
            }else{
                self.makeAlert(title: "Giriş Hatası!", message: "Şifreler uyuşmuyor...")
            }
        }else{
            self.makeAlert(title: "Giriş Hatası!", message: "Tüm alanlar doldurulmalı...")
        }
        
    }
    

}
