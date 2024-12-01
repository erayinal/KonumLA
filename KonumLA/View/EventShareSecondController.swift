//
//  EventShareSecondController.swift
//  KonumLA
//
//  Created by Eray İnal on 9.09.2024.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

class EventShareSecondController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var address: String?
    
    var selectedCategory: String {
        let selectedRow = categoryPickerView.selectedRow(inComponent: 0)
        return categoriesArr[selectedRow]
    }
    
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    var imagesArr : [UIImageView] = []
    
    
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var girlCountPickerView: UIPickerView!
    @IBOutlet weak var boyCountPickerView: UIPickerView!
    @IBOutlet weak var approvalSwitch: UISwitch!
    
    
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var explanationTextView: UITextView!
    @IBOutlet weak var locationTextView: UITextView!
    
    
    
    var homePageCont: HomePageController?
    let categoriesArr: [String] = [
        "Sanat",
        "Müzik",
        "Aşçılık",
        "Teknoloji",
        "Eğlence",
        "Kutlama",
        "Neşe",
        "Spor",
        "Gezi",
        "Parti"]
    let countArr: [String] = ["Belirtme"] + Array(0...100).map { "\($0)" }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imagesArr = [imageView1, imageView2, imageView3, imageView4]
        
        for elem in imagesArr{
            elem.layer.cornerRadius = 15.0
        }
        
        setupImageViewGestures()
        
        
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        girlCountPickerView.delegate = self
        girlCountPickerView.dataSource = self
        boyCountPickerView.delegate = self
        boyCountPickerView.dataSource = self
        
        explanationTextView.delegate = self
        locationTextView.delegate = self
        setupPlaceholders()
        
        eventTitleTextField.layer.borderWidth = 1.0
        eventTitleTextField.layer.borderColor = UIColor.orange.cgColor
        eventTitleTextField.layer.cornerRadius = 5.0
        
        explanationTextView.layer.borderWidth = 1.0
        explanationTextView.layer.borderColor = UIColor.orange.cgColor
        explanationTextView.layer.cornerRadius = 5.0
        
        locationTextView.layer.borderWidth = 1.0
        locationTextView.layer.borderColor = UIColor.orange.cgColor
        locationTextView.layer.cornerRadius = 5.0
        locationTextView.text = address
        
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == categoryPickerView){
            return categoriesArr.count
        }else if(pickerView == boyCountPickerView || pickerView == girlCountPickerView){
            return countArr.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == categoryPickerView){
            return categoriesArr[row]
        }else if(pickerView == girlCountPickerView || pickerView == boyCountPickerView){
            return countArr[row]
        }else{
            return nil
        }
    }
    
    
    
    //Placeholder
    func setupPlaceholders() {
        explanationTextView.text = "Açıklama"
        explanationTextView.textColor = UIColor.lightGray
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == explanationTextView {
                textView.text = "Açıklama"
            }
            textView.textColor = UIColor.lightGray
        }
    }
    
    let defaultImage = UIImage(named: "addEventImages5")

    
    @IBAction func ShareButtonClicked(_ sender: Any) {
        if eventTitleTextField.text == "" {
            makeAlert(title: "HATA", message: "'Etkinlik Başlığı' boş bırakılamaz.")
        } else if explanationTextView.text == "Açıklama" || explanationTextView.text == "" {
            makeAlert(title: "HATA", message: "'Açıklama' boş bırakılamaz.")
        } else if let imageData = imageView1.image?.pngData(), let defaultImageData = defaultImage?.pngData(), imageData == defaultImageData{
            makeAlert(title: "HATA", message: "'En az 1 resim eklemelisiniz.'")
        } else {
            let storage = Storage.storage()
            let storageReference = storage.reference()
            let eventsFolder = storageReference.child("Events")
            
            let defaultImage = UIImage(named: "addEventImages5")
            
            
            var dataArr: [Data] = []
            if let imageData = imageView1.image?.jpegData(compressionQuality: 0.5) {
                dataArr.append(imageData) // İlk resim
            }
            for imageView in imagesArr[1...] {
                if let imageData = imageView.image?.jpegData(compressionQuality: 0.5),
                   let defaultImageData = defaultImage?.pngData(),
                   imageView.image?.pngData() != defaultImageData {
                    dataArr.append(imageData)
                }
            }
            
            var imageUrlArr: [String] = []
            let dispatchGroup = DispatchGroup()
            for data in dataArr {
                dispatchGroup.enter()
                let uuid = UUID().uuidString
                let imageReference = eventsFolder.child("\(uuid).jpg")
                
                imageReference.putData(data, metadata: nil) { _, error in
                    if error != nil {
                        self.makeAlert(title: "ERROR!", message: error?.localizedDescription ?? "An error occurred")
                        dispatchGroup.leave()
                    } else {
                        imageReference.downloadURL { url, _ in
                            if let url = url {
                                imageUrlArr.append(url.absoluteString)
                            }
                            dispatchGroup.leave()
                        }
                    }
                }
            }
            
            let selectedGirlCountIndex = girlCountPickerView.selectedRow(inComponent: 0)
            let selectedBoyCountIndex = boyCountPickerView.selectedRow(inComponent: 0)
            let numberOfGirls = selectedGirlCountIndex == 0 ? -1 : selectedGirlCountIndex - 1
            let numberOfBoys = selectedBoyCountIndex == 0 ? -1 : selectedBoyCountIndex - 1
            
            dispatchGroup.notify(queue: .main) {
                let firestoreDatabase = Firestore.firestore()
                var firestoreReference: DocumentReference? = nil
                
                let event = Event(
                    date: Date(),
                    id: UUID().uuidString,
                    uid: Auth.auth().currentUser?.uid ?? "",
                    imageUrlArr: imageUrlArr,
                    eventDescription: self.explanationTextView.text ?? "",
                    startDate: self.startDatePicker.date,
                    endDate: self.endDatePicker.date,
                    caption: self.eventTitleTextField.text ?? "",
                    category: self.selectedCategory,
                    latitude: "\(self.latitude!)",
                    longitude: "\(self.longitude!)",
                    numberOfGirls: numberOfGirls,
                    numberOfBoys: numberOfBoys,
                    isApprovalRequired: self.approvalSwitch.isOn
                )
                
                let firestoreEvent: [String: Any] = [
                    "date": FieldValue.serverTimestamp(),
                    "id": event.id,
                    "uid": event.uid,
                    "imageUrlArr": event.imageUrlArr,
                    "eventDescription": event.eventDescription,
                    "startDate": event.startDate,
                    "endDate": event.endDate,
                    "caption": event.caption,
                    "category": event.category,
                    "latitude": event.latitude,
                    "longitude": event.longitude,
                    "numberOfGirls": numberOfGirls,
                    "numberOfBoys": numberOfBoys,
                    "isApprovalRequired": event.isApprovalRequired
                ]
                
                firestoreDatabase.collection("Events").document(event.id).setData(firestoreEvent) { error in
                    if let error = error {
                        self.makeAlert(title: "ERROR!", message: error.localizedDescription)
                    } else {
                        self.approvalSwitch.isOn = false
                        self.eventTitleTextField.text = ""
                        self.explanationTextView.text = ""
            
                    }
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 0
    }

    
    
    
    func setupImageViewGestures() {
        let imageViews = [imageView1, imageView2, imageView3, imageView4]

        for (index, imageView) in imageViews.enumerated() {
            imageView?.isUserInteractionEnabled = true // Kullanıcı etkileşimini etkinleştiriyoruz
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView?.addGestureRecognizer(tapGesture)
            imageView?.tag = index // Her imageView'a bir tag atıyoruz
        }
    }
    
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }

        // Hangi imageView'ın tıklandığını belirlemek için tag kullanıyoruz
        //print("Tapped imageView tag: \(tappedImageView.tag)")

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else {
            print("No edited image found.")
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        let defaultImage = UIImage(named: "addEventImages5")

        for imageView in imagesArr {
            if let imageData = imageView.image?.pngData(), let defaultImageData = defaultImage?.pngData(), imageData == defaultImageData {
                imageView.image = selectedImage
                break
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    
    
    
    
    
}
