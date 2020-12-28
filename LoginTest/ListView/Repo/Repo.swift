//
//  Repo.swift
//  LoginTest
//
//  Created by Nic Spiegelhauer on 04/12/2020.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftUI

class Repo : ObservableObject {
    
    @Published var places = [Place]() // tom samling af Place Object
    private var collection = Firestore.firestore().collection("places") // giver reference til denne collection
    private var storage = Storage.storage() // giver rod-adgang til Storage
    
    init() {
        getPlaces()
    }
    
    func getPlaces(){
        collection.addSnapshotListener { (snapshot, error) in
            if error == nil {
                if let snap = snapshot {
                    self.places.removeAll() // tøm listen først
                    // Tager bruger Id og sætter det på document id feltet.
                    let user = Auth.auth().currentUser
                    let userid = user?.uid
                    for document in snap.documents{
                        if userid == document.data()["userId"] as? String,
                           let name = document.data()["name"] as? String,
                           //let imageName = document.data()["imageName"] as? String,
                           let id = UUID(uuidString: document.documentID),
                           let description = document.data()["description"] as? String,
                           let lat = document.data()["latitude"] as? Double,
                           let lon = document.data()["longitude"] as? Double
                        {
                            let place = Place(id: id, name: name, description: description, latitude: lat, longitude: lon, userId: userid!)
                            self.places.append(place)
                        }
                    }
                }
                
            } else {
                
                print("Error Loading collection from FB")
                
            }
        }
    }
    
    func addPlace(place:Place){
        collection.document(place.id.uuidString).setData(
            ["name": place.name, "description": place.description, "latitude": place.latitude, "longitude": place.longitude, "userId": place.userId]
        ){ error in
            if error == nil {
                print("Data gemt i cloud")
            }else {
                print("Cloud error \(error.debugDescription)")
            }
        }
    }
    
    func deletePlace(id:String) {
        collection.document(id).delete(){ error in
            if error == nil {
                print("Document \(id) slettet")
            }else {
                print("Cloud error \(error.debugDescription)")
            }
            
        }
    }
    
    
    
    
    
}
