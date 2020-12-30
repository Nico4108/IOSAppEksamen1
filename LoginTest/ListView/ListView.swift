//
//  ListView.swift
//  LoginTest
//
//  Created by Nic Spiegelhauer on 04/12/2020.
//

import SwiftUI
import MapKit
import Firebase

struct ListView: View {
    
    @ObservedObject var repo = Repo() // 2-way binding
    var locationManager = LocationManager()
 
    var body: some View {
        
        NavigationView {
            VStack{
                VStack{
                    List{
                        ForEach(self.repo.places){ place in
                            NavigationLink(destination: DetailView(repo: self.repo, text: place.name, currentPlace: place)){
                                VStack {
                                    HStack {
                                        //places.image
                                            //.resizable()
                                            //.frame(width: 50, height: 50)
                                    Text(place.name)
                                    }
                                }
                            }
                        }
                    }
                }
                
                NavigationLink(destination: MapViewDetailView()) {
                    Text("Map")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .navigationBarTitle("Your places")
                }
                .background(Color.red)
                .cornerRadius(10)
                
                Button(action: {
                    
                    try! Auth.auth().signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    
                }) {
                    
                    Text("Log out")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(Color.red)
                .cornerRadius(10)
                .padding()
            }.onAppear()
        }
    }
    
}
