//
//  DetailView.swift
//  LoginTest
//
//  Created by Nic Spiegelhauer on 04/12/2020.
//

import SwiftUI
import MapKit

struct DetailView: View {
    
    @State var centerCoordinate = CLLocationCoordinate2D()
    @State var annotations = [MKPointAnnotation]()
    
    var repo: Repo
    @State var currentPlace:Place //(@State)værdien bliver pushet til guien, når værdien ændresig opdatere guien også
    
    @State var ispresented = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack{
        
            MapView(centerCoordinate: $centerCoordinate, annotations: annotations)
                // fylder hele skærmen
                .ignoresSafeArea(edges: .top)
                .frame(height: 200)
            
            CircleImage(currentPlaceimageID: $currentPlace.id)
                .offset(y: -130)
                .padding(.bottom, -130)
            
            VStack {
                
                Text(currentPlace.name)
                    .font(.title)
                    .padding(-10)
                Text(currentPlace.description)
                    .font(.subheadline)
                    .padding()
            }
            .alert(isPresented: $ispresented) {
                Alert(title: Text("You are deleting a place"), message: Text("Are you sure you want to delete this place?"), primaryButton: .destructive(Text("Delete")) {
                    // Sletter place i database
                    self.repo.deletePlace(id: self.currentPlace.id.uuidString)
                    // Går tilbage til ListView
                    presentationMode.wrappedValue.dismiss()
                }, secondaryButton: .cancel())
            }
            .padding()
            
            Spacer()
        }
        .navigationBarItems(trailing: Button(action:{
            self.ispresented.toggle()
        }){
            Image(systemName: "trash.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.red)
        })
        
    }
}
