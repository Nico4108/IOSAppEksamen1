//
//  Home.swift
//  LoginTest
//
//  Created by Nic Spiegelhauer on 04/12/2020.
//

import SwiftUI

struct Home : View {
    
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                if self.status{
                    
                    ListView()
                }
                else{
                    
                    ZStack{
                        // isActive bliver sat til true ved parsing $show værdi og
                        // viser derefter SignUp()
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                            
                            Text("")
                        }
                        .hidden()
                        
                        Login(show: self.$show)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            // Bliver aktiviret når viewet vises
            .onAppear {
                
                // lytter efter "broadcast" om "status" er true eller false
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    
                    // sætter self.status til at være true/false og logger ind eller ej.
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}
