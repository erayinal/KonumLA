//
//  SignUpController.swift
//  KonumLA
//
//  Created by Eray İnal on 22.07.2024.
//

import UIKit
import FirebaseAuth

class SignUpController: UIViewController {
    
    @IBOutlet weak var loginLabel: UILabel! //Giriş Yap metni
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
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
                        self.performSegue(withIdentifier: "fromSignupToHomeVC", sender: nil)
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
