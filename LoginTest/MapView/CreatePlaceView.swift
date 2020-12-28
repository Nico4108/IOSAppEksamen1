//
//  CreatePlaceView.swift
//  LoginTest
//
//  Created by Nic Spiegelhauer on 13/12/2020.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseStorage

struct CreatePlaceView: View {
    
    // Tager coordinaterne med over fra MapViewDetailView
    @State var centerCoordinate = CLLocationCoordinate2D()
    
    @ObservedObject var repo = Repo() // 2-way binding
    @State var placeinput: String = ""
    @State var descpinput: String = ""
    @State var lat: String = ""
    @State var lon: String = ""
    
    @State var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    @State var shown = false
    
    var body: some View {
        
        NavigationView {
            
            VStack{
                
                TextField("Type name here", text: $placeinput)
                    .padding()
                TextField("Type decription here", text: $descpinput)
                    .padding()
                
                Button(action: {
                    
                    self.shown.toggle()
                    
                }) {
                    Image(systemName: "camera.fill")
                        .padding()
                }
                
                
                Button(action: {
                    // Tilføjer til database
                    
                    // Tager bruger Id og sætter det på document id feltet.
                    let user = Auth.auth().currentUser
                    let userid = user?.uid
                    self.repo.addPlace(place: Place(id: UUID(), name: self.placeinput, description: self.descpinput, latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude, userId: userid!))
                    
                    // Sætter showAlert til true
                    self.showAlert.toggle()
                    print("Button pressed!!")
                    
                }) {
                    Image(systemName: "plus.circle.fill")
                        .padding()
                }
                .sheet(isPresented: $shown){
                    imagePicker(shown: self.$shown)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("New place"), message: Text("You have added a new place"), dismissButton: .default(Text("Okay")){
                    // Gør så den går tilbage til mappet.
                    presentationMode.wrappedValue.dismiss()
                })
            }
            
        }
    }
}

struct imagePicker: UIViewControllerRepresentable {
    
    func makeCoordinator() -> imagePicker.Coordinator {
        return imagePicker.Coordinator(parent1: self)
    }
    @Binding var shown: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) ->
    UIImagePickerController{
        let imagePick = UIImagePickerController()
        imagePick.sourceType = .photoLibrary
        imagePick.delegate = context.coordinator
        return imagePick
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<imagePicker>) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        var parent: imagePicker!
        
        init(parent1: imagePicker) {
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.shown.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any], place: Place) {
            let image = info[.originalImage] as! UIImage
            let storage = Storage.storage()
            //place.id.uuidString
            storage.reference().child("temp").putData(image.jpegData(compressionQuality: 0.35)!, metadata: nil){
                (_, err) in
                if err != nil{
                    print((err?.localizedDescription)!)
                    return
                }
                print("Success")
            }
        }
    }
}
