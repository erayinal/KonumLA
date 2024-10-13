//
//  EventModel.swift
//  KonumLA
//
//  Created by Eray İnal on 23.07.2024.
//

import Foundation

struct Event{
    
    let id: String
    let uid: String
    var imageUrlArr: [String] = []
    var eventDescription: String
    var caption: String
    var category: String
    let startDate: Date
    let endDate: Date
    var numberOfGirls : Int
    var numberOfBoys : Int
    var isApprovalRequired: Bool
    
    var latitude: String
    var longitude: String
    
    init(id: String, uid: String, imageUrlArr: [String], eventDescription: String, startDate: Date, endDate: Date, caption: String, category: String, latitude: String, longitude: String, numberOfGirls: Int, numberOfBoys: Int, isApprovalRequired: Bool) {
        self.id = id
        self.uid = uid
        self.imageUrlArr = imageUrlArr
        self.eventDescription = eventDescription
        self.caption = caption
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
        self.latitude = latitude
        self.longitude = longitude
        self.numberOfGirls = numberOfGirls
        self.numberOfBoys = numberOfBoys
        self.isApprovalRequired = isApprovalRequired
    }
    
}

