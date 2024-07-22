//
//  Post.swift
//  KonumLA
//
//  Created by Eray İnal on 21.07.2024.
//

import Foundation

struct Post{
    
    let id: String
    let user: User
    let imageUrl: String
    let caption: String
    let creationDate: Date
    
    init(id: String, user: User, imageUrl: String, caption: String) {
        self.id = id
        self.user = user
        self.imageUrl = imageUrl
        self.caption = caption
        self.creationDate = Date()
    }
    
}
