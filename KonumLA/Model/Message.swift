//
//  Message.swift
//  KonumLA
//
//  Created by Eray İnal on 21.07.2024.
//

import Foundation


struct Message{
    
    let id: String
    let fromUser: User
    let toUser: User
    var text: String
    let date: Date
    
    
    init(id: String, fromUser: User, toUser: User, text: String, date: Date) {
        self.id = id
        self.fromUser = fromUser
        self.toUser = toUser
        self.text = text
        self.date = date
    }
    
}
