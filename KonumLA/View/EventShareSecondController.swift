//
//  EventShareSecondController.swift
//  KonumLA
//
//  Created by Eray İnal on 9.09.2024.
//

import UIKit

class EventShareSecondController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var girlCountPickerView: UIPickerView!
    @IBOutlet weak var boyCountPickerView: UIPickerView!
    
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
    let countArr : [Int] = Array(1...100)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        girlCountPickerView.delegate = self
        girlCountPickerView.dataSource = self
        boyCountPickerView.delegate = self
        boyCountPickerView.dataSource = self
        
        explanationTextView.delegate = self
        locationTextView.delegate = self
        setupPlaceholders()
        
        eventTitleTextField.layer.borderWidth = 1.0 // Çizgi kalınlığı
        eventTitleTextField.layer.borderColor = UIColor.gray.cgColor // Çizgi rengi
        eventTitleTextField.layer.cornerRadius = 5.0
        
        explanationTextView.layer.borderWidth = 1.0
        explanationTextView.layer.borderColor = UIColor.gray.cgColor
        explanationTextView.layer.cornerRadius = 5.0
        
        locationTextView.layer.borderWidth = 1.0
        locationTextView.layer.borderColor = UIColor.gray.cgColor
        locationTextView.layer.cornerRadius = 5.0

        
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
            return "\(countArr[row])"
        }else{
            return nil
        }
    }
    
    
    
    //Placeholder
    func setupPlaceholders() {
        explanationTextView.text = "Açıklama"
        explanationTextView.textColor = UIColor.lightGray
        
        locationTextView.text = "Konum"
        locationTextView.textColor = UIColor.lightGray
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
            } else if textView == locationTextView {
                textView.text = "Konum"
            }
            textView.textColor = UIColor.lightGray
        }
    }
    

    

}
