//
//  Network.swift
//  BikeList
//
//  Created by Matthew Willeke on 1/27/19.
//  Copyright © 2019 Matthew Willeke. All rights reserved.
//

import Foundation

struct Network {
    let id: String
    let companyName: String
    let city: String
    let country: String
    let latitude: Double
    let longitude: Double
    
    init(id: String, companyName: String, city: String, country: String, latitude: Double, longitude: Double) {
        self.id = id
        self.companyName = companyName
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
}
