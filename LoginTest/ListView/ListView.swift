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
    @State var placeinput: String = ""
    @State var descpinput: String = ""
    @State var lat: String = ""
    @State var lon: String = ""
    
    //@State var coordinate: Coordinates?
    
    var body: some View {
        
        NavigationView {
            VStack{
                VStack{
                    TextField("Type name here", text: $placeinput)
                        .padding()
                    TextField("Type decription here", text: $descpinput)
                        .padding()
                    TextField("Type lat here", text: $lat)
                        .padding()
                    TextField("Type lon here", text: $lon)
                        .padding()
                    
                    Button(action: {
                        self.repo.addPlace(place: Place(id: UUID(), name: self.placeinput, description: self.descpinput, latitude: Double(self.lat)!, longitude: Double(self.lon)!))
                        print("Button pressed!!")
                        
                    }){
                        Image(systemName: "plus.circle.fill")
                            .padding()
                    }
                }
                VStack{
                    List{
                        ForEach(self.repo.places){ place in
                            NavigationLink(destination: DetailView(repo: self.repo, text: place.name, currentPlace: place)){
                                VStack {
                                    Text(place.name)
                                    
                                }
                            }
                        }
                    }
                }
                Button(action: {
                    
                    try! Auth.auth().signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    
                }) {
                    
                    Text("Log out")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(Color.red)
                .cornerRadius(10)
                .padding(.top, 25)
            }.onAppear()
        }
    }
    
}
