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

class EventShareSecondController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
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
    
    
    
    @IBAction func ShareButtonClicked(_ sender: Any) {
        
        if(eventTitleTextField.text == ""){
            makeAlert(title: "HATA", message: "'Etkinlik Başlığı' boş bırakılamaz.")
            
        }else if(explanationTextView.text == "Açıklama" || explanationTextView.text == ""){
            makeAlert(title: "HATA", message: "'Açıklama' boş bırakılamaz.")
            
        }else{
            let storage = Storage.storage()
            let storageReferance = storage.reference()
            let eventsFolder = storageReferance.child("Events")
            
            var dataArr : [Data] = []
            for image in imagesArr{
                if let data = image.image?.jpegData(compressionQuality: 0.5){
                    dataArr.append(data)
                }
            }
            
            
            var imageUrlArr: [String] = []
            let dispatchGroup = DispatchGroup()
            for data in dataArr{
                
                dispatchGroup.enter()
                let uuid = UUID().uuidString
                let imageReferance = eventsFolder.child("\(uuid).jpg")
                
                imageReferance.putData(data, metadata: nil){metaData, error in
                    
                    if(error != nil){
                        self.makeAlert(title: "ERROR!", message: error?.localizedDescription ?? "An error occured")
                        dispatchGroup.leave()
                    }else{
                        imageReferance.downloadURL{url, error in
                            if let url = url {
                                let imageUrl = url.absoluteString
                                imageUrlArr.append(imageUrl)
                            }
                            dispatchGroup.leave()
                        }
                    }
                }
            }
            
            
            let selectedGirlCountIndex = self.girlCountPickerView.selectedRow(inComponent: 0)
            let selectedBoyCountIndex = self.boyCountPickerView.selectedRow(inComponent: 0)
            let numberOfGirls = selectedGirlCountIndex == 0 ? -1 : selectedGirlCountIndex-1
            let numberOfBoys = selectedBoyCountIndex == 0 ? -1 : selectedBoyCountIndex-1
            
            dispatchGroup.notify(queue: .main) {
                let firestoreDatabase = Firestore.firestore()
                var firestoreReference : DocumentReference? = nil
                
                let event = Event(
                    date : Date(),
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
                    "isApprovalRequired" : event.isApprovalRequired
                ]
                
                
                
                firestoreDatabase.collection("Events").document(event.id).setData(firestoreEvent) { error in
                    if let error = error {
                        self.makeAlert(title: "ERROR!", message: error.localizedDescription)
                    } else {
                        self.approvalSwitch.isOn = false
                        self.eventTitleTextField.text = ""
                        self.explanationTextView.text = ""
                        self.tabBarController?.selectedIndex = 0
                    }
                }
                
            }
            
            
        }
        
        
    }
    
    
    
    
    
}
