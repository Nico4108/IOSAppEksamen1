//
//  MapView.swift
//  LoginTest
//
//  Created by Nic Spiegelhauer on 13/12/2020.
//

import Foundation
import SwiftUI
import MapKit
import Firebase
import FirebaseStorage

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate:CLLocationCoordinate2D
    @State var annotations: [MKPointAnnotation]
    @ObservedObject var repo = Repo() // 2-way binding
    
    var collection = Firestore.firestore().collection("places") // giver reference til denne collection
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        //map.mapType = .satellite
        //map.showsTraffic = true
        map.delegate = context.coordinator
        map.showsUserLocation = true
        
        collection.addSnapshotListener { (snapshot, error) in
            if error == nil {
                if let snap = snapshot {
                    self.repo.places.removeAll() // tøm listen først
                    let user = Auth.auth().currentUser
                    let userid = user?.uid
                    for document in snap.documents{
                        if userid == document.data()["userId"] as? String,
                           let name = document.data()["name"] as? String,
                           let description = document.data()["description"] as? String,
                           let lat = document.data()["latitude"] as? CLLocationDegrees,
                           let lon = document.data()["longitude"] as? CLLocationDegrees
                        {
                            let annotaion = MKPointAnnotation(__coordinate: (CLLocationCoordinate2DMake(lat, lon)), title: name, subtitle: description)
                            self.annotations.append(annotaion)
                        }
                    }
                }
            }
        }
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        if annotations.count != uiView.annotations.count {
            uiView.addAnnotations(annotations)
            // uiView.showAnnotations(annotations, animated: false)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    //Cordinator er en bro mellem data
    class Coordinator: NSObject, MKMapViewDelegate {
        
        // Laver en instance så vi kan kalde variable fra mapview
        var parent:MapView
        
        init(_ parent:MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            // gem ny lokation for centrum af map:
            parent.centerCoordinate = mapView.centerCoordinate
            // Starter appen på din lokation(her London da det er hvor simulatoren er sat til)
            //mapView.userTrackingMode = .followWithHeading
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // this is our unique identifier for view reuse
            let identifier = "Annotation"
            // attempt to find a cell we can recycle
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                // we didn't find one; make a new one
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                // allow this to show pop up information
                annotationView?.canShowCallout = true
                
                // attach an information button to the view
                //annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                // we have a view to reuse, so give it the new annotation
                annotationView?.annotation = annotation
            }
            
            // set userlocation pin til custom icon
            if annotation.isEqual(mapView.userLocation){
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User Location")
                
                let image = UIImage(named: "pinn")
                let resizedSize = CGSize(width: 50, height: 50)

                UIGraphicsBeginImageContext(resizedSize)
                image?.draw(in: CGRect(origin: .zero, size: resizedSize))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                annotationView.image = resizedImage
                annotationView.canShowCallout = true
                
                return annotationView
            }
            
            // whether it's a new view or a recycled one, send it back
            return annotationView
        }
    }
}
