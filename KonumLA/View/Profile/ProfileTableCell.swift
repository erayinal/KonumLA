//
//  ProfileTableCell.swift
//  KonumLA
//
//  Created by Eray İnal on 25.07.2024.
//

import UIKit

class ProfileTableCell: UITableViewCell {
    
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLabelText: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

}
