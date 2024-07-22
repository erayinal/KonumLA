//
//  SignUpController.swift
//  KonumLA
//
//  Created by Eray İnal on 22.07.2024.
//

import UIKit

class SignUpController: UIViewController {
    
    @IBOutlet weak var loginLabel: UILabel!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpController.loginLabelTapped))
        loginLabel.addGestureRecognizer(tapGesture)
        loginLabel.isUserInteractionEnabled = true
    }
    
    
    
    @objc func loginLabelTapped(){
        performSegue(withIdentifier: "toLoginPage", sender: nil)
    }

    

}
