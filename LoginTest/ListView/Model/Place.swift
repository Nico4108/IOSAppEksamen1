//
//  Place.swift
//  LoginTest
//
//  Created by Nic Spiegelhauer on 04/12/2020.
//

import Foundation
import SwiftUI
import CoreLocation

struct Place: Hashable, Codable, Identifiable{
    
    var id = UUID()
    var name : String
    var description : String
    var latitude : Double
    var longitude : Double
    //var coordinates: Coordinates
    
    init(id: UUID, name: String, description: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /*var LocationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }*/
    
}

/*struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}*/
