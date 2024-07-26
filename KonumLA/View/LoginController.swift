//
//  LoginController.swift
//  KonumLA
//
//  Created by Eray İnal on 21.07.2024.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {
    
    @IBOutlet weak var emailTextLabel: UITextField!
    @IBOutlet weak var passwordTextLabel: UITextField!
    
    @IBOutlet weak var signUpLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginController.signUpLabelTapped))
        signUpLabel.addGestureRecognizer(tapGesture)
        signUpLabel.isUserInteractionEnabled = true
        
    }
    
    
    @objc func signUpLabelTapped(){
        performSegue(withIdentifier: "toSignUpPage", sender: nil)
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        if(emailTextLabel.text != "" && passwordTextLabel.text != ""){
            
            Auth.auth().signIn(withEmail: emailTextLabel.text!, password: passwordTextLabel.text!) { authData, error in
                if(error != nil){
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Eror")
                }
                else{
                    self.performSegue(withIdentifier: "fromLoginToHomeVC", sender: nil)
                }
            }
            
        }else{
            self.makeAlert(title: "Giriş Hatası!", message: "Tüm alanlar doldurulmalı...")
        }
    }
    

    

}
