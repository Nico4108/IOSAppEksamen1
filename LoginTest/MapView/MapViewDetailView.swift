//
//  MapViewDetailView.swift
//  LoginTest
//
//  Created by Nic Spiegelhauer on 13/12/2020.
//

import SwiftUI
import MapKit

struct MapViewDetailView: View {
    
    @State var centerCoordinate = CLLocationCoordinate2D()
    @State var annotations = [MKPointAnnotation]()
    
    @State var showSheet = false
    
    var body: some View {
        
        ZStack{
            MapView(centerCoordinate: $centerCoordinate, annotations: annotations)
            
            Circle()
                .fill()
                .frame(width: 5, height: 5)
                .opacity(0.5)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        
                        // Sætter showSheet til at være true
                        self.showSheet.toggle()
                        
                        print("You pressed")
                        let newLocation = MKPointAnnotation()
                        newLocation.coordinate = self.centerCoordinate
                        self.annotations.append(newLocation)
                        
                    }) {
                        Image(systemName:"plus.circle.fill")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                    }
                    .sheet(isPresented: $showSheet, content: { CreatePlaceView(centerCoordinate: centerCoordinate) })
                    .padding()
                    
                }
            }
        }
        .navigationBarTitle("Map", displayMode: .inline)
        
    }
}

