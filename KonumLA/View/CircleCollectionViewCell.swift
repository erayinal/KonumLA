//
//  CircleCollectionViewCell.swift
//  KonumLA
//
//  Created by Eray İnal on 23.07.2024.
//

import UIKit

class CircleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CircleCollectionViewCell"
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 70.0/2.0
        //imageView.backgroundColor = .blue
        //imageView.layer.borderWidth = 2
        //imageView.layer.borderColor = UIColor.black.cgColor
        
        return imageView
    }()
    
    private let myLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 13) // Yazı tipi boyutu
        label.textColor = .black // Yazı rengi
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(myImageView)
        contentView.addSubview(myLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //myImageView.frame = contentView.bounds
        
        let imageSize = contentView.bounds.size.width
                myImageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
                myLabel.frame = CGRect(x: 0, y: imageSize, width: imageSize, height: 20)
    }
    
    public func configure(with name: String, title: String){
        myImageView.image = UIImage(named: name)
        myLabel.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.image = nil
        myLabel.text = nil
    }
    
    
}
