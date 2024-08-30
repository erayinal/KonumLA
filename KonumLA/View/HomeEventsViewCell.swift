//
//  HomeEventsViewCell.swift
//  KonumLA
//
//  Created by Eray İnal on 11.08.2024.
//

import UIKit

class HomeEventsViewCell: UITableViewCell {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
    @IBOutlet weak var saveImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    
    
    let unsavedButtonImage = UIImage(named: "saved_button_default")
    let savedButtonImage = UIImage(named: "saved_button_dark")
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        saveImageView.isUserInteractionEnabled = true
        let saveTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeEventsViewCell.saveImageTapped))
        saveImageView.addGestureRecognizer(saveTapGestureRecognizer)
        
        shareImageView.isUserInteractionEnabled = true
        let shareTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeEventsViewCell.shareImageTapped))
        shareImageView.addGestureRecognizer(shareTapGestureRecognizer)
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc func saveImageTapped(){
        print("tapped")
        if(saveImageView.image == unsavedButtonImage){
            saveImageView.image = savedButtonImage
        }else{
            saveImageView.image = unsavedButtonImage
        }
        
    }
    
    
    @objc func shareImageTapped(){
        
    }
    
    

}





