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
        
        // Henter place info til Pin
        collection.addSnapshotListener { (snapshot, error) in
            if error == nil {
                for place in repo.places {
                    let annotaion = MKPointAnnotation(__coordinate: (CLLocationCoordinate2DMake(place.latitude, place.longitude)), title: place.name, subtitle: place.description)
                        self.annotations.append(annotaion)
                        }
                    }
                }
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        if annotations.count != uiView.annotations.count {
            uiView.addAnnotations(annotations)
            //uiView.showAnnotations(annotations, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    // Cordinator er en bro mellem data
    // kommunikere ændringer fra dit View til andre dele af dit SwiftUI-interface
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
        
        private func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKMarkerAnnotationView? {
            // this is our unique identifier for view reuse
            let identifier = "Annotation"
            // attempt to find a cell we can recycle
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                // we didn't find one; make a new one
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                // allow this to show pop up information
                annotationView?.canShowCallout = true
                
            } else {
                // we have a view to reuse, so give it the new annotation
                annotationView?.annotation = annotation
            }
            
            // set userlocation
            if annotation.isEqual(mapView.userLocation){
                let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "User Location")
                
                annotationView.canShowCallout = true
                
                return annotationView
            }
            
            // whether it's a new view or a recycled one, send it back
            return annotationView as? MKMarkerAnnotationView
        }
    }
}
