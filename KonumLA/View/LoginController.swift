//
//  LoginController.swift
//  KonumLA
//
//  Created by Eray İnal on 21.07.2024.
//

import UIKit

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
    

    

}
