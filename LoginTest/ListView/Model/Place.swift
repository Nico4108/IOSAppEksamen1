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
    var userId : String
    var name : String
    var description : String
    var latitude : Double
    var longitude : Double
    
    /*var imageName: String
        var image: Image {
            Image(imageName)
        }*/
    
    var coordinates: CLLocationCoordinate2D {
        return .init(latitude: latitude, longitude: longitude)
    }
    
    init(id: UUID, name: String, description: String, latitude: Double, longitude: Double, userId: String) {
        self.id = id
        self.userId = userId
        self.name = name
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
