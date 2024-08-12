//
//  ProfilePageController.swift
//  KonumLA
//
//  Created by Eray İnal on 25.07.2024.
//

import UIKit
import FirebaseAuth

class ProfilePageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    let settingsArr:[ProfileSettingsModel] = [
    ProfileSettingsModel(imageName: "ProfileTableImage", title: "Profil"),
    ProfileSettingsModel(imageName: "SettingsTableImage", title: "Ayarlar"),
    ProfileSettingsModel(imageName: "ChangePasswordTableImage", title: "Şifreyi Değiştir"),
    ProfileSettingsModel(imageName: "SupportTableImage", title: "Yardım ve Destek")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileTableView.delegate = self
        profileTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSettingsCell", for: indexPath) as! ProfileTableCell
        cell.selectionStyle = .none
        cell.myImageView.image = UIImage(named: settingsArr[indexPath.row].imageName)
        cell.myLabelText.text = settingsArr[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = settingsArr[indexPath.row]
            
        switch selectedItem.title {
            case "Profil":
                if let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") {
                    navigationController?.pushViewController(profileVC, animated: true)
                }
            case "Ayarlar":
                if let settingsVC = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") {
                    navigationController?.pushViewController(settingsVC, animated: true)
                }
            case "Şifreyi Değiştir":
                if let changePasswordVC = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") {
                    navigationController?.pushViewController(changePasswordVC, animated: true)
                }
            case "Yardım ve Destek":
                if let helpVC = storyboard?.instantiateViewController(withIdentifier: "HelpViewController") {
                    navigationController?.pushViewController(helpVC, animated: true)
                }
            default:
                break
            }
        }
    
    
    
    
    
    
    
    
    
    
    


    
    @IBAction func logOutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 0
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true) {
                self.navigationController?.popToRootViewController(animated: false)
            }
            
        } catch {
            print("Error logging out")
        }
    }
    
    
    

    

}
