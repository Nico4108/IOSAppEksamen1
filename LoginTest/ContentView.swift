//
//  ContentView.swift
//  LoginTest
//
//  Created by Nic Spiegelhauer on 04/12/2020.
//

import SwiftUI
import Firebase
import MapKit
  
  struct ContentView: View {
    
      var body: some View {
          
        Home()
        //ListView()
      }
  }
  
  struct Homescreen : View {
      
      var body: some View{
          
          VStack{
              
              Text("Logged successfully")
                  .font(.title)
                  .fontWeight(.bold)
                  .foregroundColor(Color.black.opacity(0.7))
              
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
          }
      }
  }
