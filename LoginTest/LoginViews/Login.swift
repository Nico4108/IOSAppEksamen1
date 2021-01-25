//
//  Login.swift
//  LoginTest
//
//  Created by Nic Spiegelhauer on 04/12/2020.
//

import SwiftUI
import Firebase

struct Login : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View{
        
        ZStack{
            
            ZStack(alignment: .topTrailing) {
                
                GeometryReader{_ in
                    
                    VStack{
                        
                        Image("papit")
                            .resizable()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 7)
                            .scaledToFit()
                            .padding(.top, 40)
                        
                        Text("Log in to your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
                        
                        TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                        .padding()
                          .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.red : self.color,lineWidth: 2))
                        .padding(.top, 15)
                        
                        HStack(spacing: 10){
                            
                            VStack{
                                
                                if self.visible{
                                    
                                    TextField("Password", text: self.$pass)
                                    .autocapitalization(.none)
                                }
                                else{
                                    
                                    SecureField("Password", text: self.$pass)
                                    .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                
                                self.visible.toggle()
                                
                            }) {
                                
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color.red : self.color,lineWidth: 2))
                        .padding(.top, 15)
                        
                        HStack{
                            
                            Spacer()
                            
                            Button(action: {
                                
                                self.reset()
                                
                            }) {
                                
                                Text("Forgot password")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.red)
                                    .padding(.bottom)
                            }
                        }
                        .padding(.top, 10)
                        
                        Button(action: {
                            
                            self.verify()
                            
                        }) {
                            
                            Text("Log in")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.bottom, 15)
                        
                    }
                    .padding(.horizontal, 15)
                }
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                    Text("Register")
                        .fontWeight(.bold)
                      .foregroundColor(Color.red)
                }
                .padding()
            }
            
            if self.alert{
                
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }
    
    func verify(){
        
        if self.email != "" && self.pass != ""{
            
            // Kalder Firebase indbygget SignIn funktion.
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                
                if err != nil{
                    
                    // Skriver en error som er indbygget fra firebase
                    self.error = err!.localizedDescription
                    print(error)
                    self.alert.toggle()
                    return
                }
                
                print("success")
                // Sætter appens tilstand til true så længe true er vi logget ind!
                // Se Home
                UserDefaults.standard.set(true, forKey: "status")
                // Broadcaster "status" og true 
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        }
        else{
            
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
    
    func reset(){
        
        if self.email != ""{
            
            // Firebase indbygget funktion som sender en reset kode email
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.error = "RESET"
                self.alert.toggle()
            }
        }
        else{
            
            self.error = "Email Id is empty"
            self.alert.toggle()
        }
    }
}
