//
//  ProfilePageController.swift
//  KonumLA
//
//  Created by Eray İnal on 25.07.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfilePageController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    let settingsArr:[ProfileSettingsModel] = [
    ProfileSettingsModel(imageName: "ProfileTableImage", title: "Profil"),
    ProfileSettingsModel(imageName: "sharedEventsImage", title: "Paylaşımlarım"),
    ProfileSettingsModel(imageName: "SettingsTableImage", title: "Ayarlar"),
    ProfileSettingsModel(imageName: "ChangePasswordTableImage", title: "Şifreyi Değiştir"),
    ProfileSettingsModel(imageName: "SupportTableImage", title: "Yardım ve Destek")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        //Profil resmi yuvarlak:
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        profileImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        
        updateUserData()
    }
    
    
    func updateUserData() {
        if let name = UserManager.shared.nameAndSurname {
            nameTextLabel.text = name
        }
        if let profileImageUrlString = UserManager.shared.profileImageUrl,
           let profileImageUrl = URL(string: profileImageUrlString) {
            
            URLSession.shared.dataTask(with: profileImageUrl) { (data, response, error) in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        self.profileImageView.image = UIImage(data: data)
                    }
                } else {
                    print("Error loading image: \(error?.localizedDescription ?? "No error info")")
                }
            }.resume()
        }
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
            case "Paylaşımlarım":
                if let sharedEventsVC = storyboard?.instantiateViewController(withIdentifier: "SharedEventsViewController") {
                    navigationController?.pushViewController(sharedEventsVC, animated: true)
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
    
    
    
    @objc func imageViewTapped(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        profileImageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        uploadImageToFirebase()
    }
    
    
    
    func uploadImageToFirebase() {
        guard let image = profileImageView.image else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        // Unique bir dosya adı oluşturmak için UUID kullanıyoruz
        let userFolder = storageReference.child("Users/\(Auth.auth().currentUser!.uid)/profileImage.jpg")
        
        // Resmi Firebase'e yükle
        userFolder.putData(imageData, metadata: nil) { metadata, error in
            guard error == nil else {
                print("Failed to upload image: \(String(describing: error?.localizedDescription))")
                return
            }
            // Başarıyla yüklendiğinde, indirilebilir URL'yi al
            userFolder.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("Failed to get download URL: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                // URL'yi Firestore'a kaydet
                self.saveProfileImageURLToFirestore(url: downloadURL)
            }
        }
    }
        
    
    func saveProfileImageURLToFirestore(url: URL) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let firestoreDatabase = Firestore.firestore()
        let firestoreReference = firestoreDatabase.collection("Users").document(currentUid)
        
        firestoreReference.updateData(["profileImageUrl": url.absoluteString]) { error in
            if let error = error {
                print("Error saving profile image URL: \(error.localizedDescription)")
            } else {
                print("Profile image URL successfully saved to Firestore")
            }
        }
    }
    
    
    

    

}
