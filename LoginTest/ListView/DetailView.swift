//
//  DetailView.swift
//  LoginTest
//
//  Created by Nic Spiegelhauer on 04/12/2020.
//

import SwiftUI

struct DetailView: View {
    
    var repo: Repo
    @State var text:String //(@State)værdien bliver pushet til guien, når værdien ændresig opdatere guien også
    //var currentID:UUID
    var currentPlace:Place
    
    var body: some View {
        
        VStack {
            
            Text(currentPlace.name)
            Text(currentPlace.description)
            
            //Text(currentPlace.longitude)
        }
    }
}
