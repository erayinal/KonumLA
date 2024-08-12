//
//  ProfileChangePasswordController.swift
//  KonumLA
//
//  Created by Eray İnal on 25.07.2024.
//

import UIKit
import FirebaseAuth

class ProfileChangePasswordController: UIViewController {
    
    
    @IBOutlet weak var currentPassTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var newPassAgainTextField: UITextField!
        
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var newPassImage: UIImageView!
    @IBOutlet weak var newPassAgainImage: UIImageView!
    
    let userVM = UserViewModel()
    
        
        enum PasswordIcon: String {
            case show = "showPasswordIcon"
            case hide = "hidePasswordIcon"
            
            var image: UIImage? {
                return UIImage(named: self.rawValue)
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            
            self.title = "Change Password"
            
            currentImage.image = PasswordIcon.hide.image
            newPassImage.image = PasswordIcon.hide.image
            newPassAgainImage.image = PasswordIcon.hide.image
            
            setupTapGestures()
        }
        
        private func setupTapGestures() {
            let imageViews = [currentImage, newPassImage, newPassAgainImage]
            imageViews.forEach { imageView in
                imageView?.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility(_:)))
                imageView?.addGestureRecognizer(tapGesture)
            }
        }
        
        @objc private func togglePasswordVisibility(_ sender: UITapGestureRecognizer) {
            guard let tappedImageView = sender.view as? UIImageView else { return }
            
            let textField: UITextField
            let imageView: UIImageView
            
            switch tappedImageView {
            case currentImage:
                textField = currentPassTextField
                imageView = currentImage
            case newPassImage:
                textField = newPassTextField
                imageView = newPassImage
            case newPassAgainImage:
                textField = newPassAgainTextField
                imageView = newPassAgainImage
            default:
                return
            }
            
            textField.isSecureTextEntry.toggle()
            let icon = textField.isSecureTextEntry ? PasswordIcon.hide : PasswordIcon.show
            imageView.image = icon.image
        }
    
    
    
    @IBAction func changePasswordClicked(_ sender: Any) {
        
        guard let currentPassword = currentPassTextField.text, !currentPassword.isEmpty,
                  let newPassword = newPassTextField.text, !newPassword.isEmpty,
                  let newPasswordAgain = newPassAgainTextField.text, !newPasswordAgain.isEmpty
        else {
                self.makeAlert(title: "Boş alan olmamalı", message: "Tüm alanlar doldurulmalıdır")
                return
        }

        guard newPassword == newPasswordAgain else {
            // Hata mesajı göster: Yeni şifreler eşleşmiyor
            makeAlert(title: "Şifreler Eşleşmiyor", message: "Yeni şifre ve şifre tekrarı birbirinden farklı")
            return
        }

        let user = Auth.auth().currentUser
            let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: currentPassword)

        user?.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                // Hata mesajı göster: Mevcut şifre yanlış
                self.makeAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            user?.updatePassword(to: newPassword) { error in
                if let error = error {
                    // Hata mesajı göster: Şifre güncellenemedi
                    self.makeAlert(title: "Şifre Değiştirilemedi", message: error.localizedDescription)
                    return
                }
                
                print("Password successfully updated")
                
                // Sol üst köşedeki 'Back' butonunu tetikle
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
        
    }
    
    
    


}
