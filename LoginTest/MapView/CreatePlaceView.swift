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
    
    // ImagePicker
    @State var showActionSheet = false
    @State var showImagePicker = false
    
    // Default starter på camera hvis ikke andet.
    @State var sourceType:UIImagePickerController.SourceType = .camera
    
    @State var upload_image:UIImage?
    
    var body: some View {
        
        NavigationView {
            
            VStack{
                ZStack{
                    // Imagepicker
                    if upload_image != nil {
                        Image(uiImage: upload_image!)
                            .resizable()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 7)
                            .scaledToFit()
                    } else {
                        Image("insertphoto2")
                            .resizable()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 7)
                            .scaledToFit()
                    }
                    
                    
                    // Vælg Image button
                    Button(action: {
                        
                        self.showActionSheet = true
                        
                    }) {
                        Image(systemName: "camera.fill")
                            .padding()
                            .foregroundColor(.red)
                            .font(.headline)
                            .frame(width: 150, height: 150)
                            .padding(.top)
                    }.actionSheet(isPresented: $showActionSheet){
                        ActionSheet(title: Text("Add a picture to your post"), message: nil, buttons: [
                            //Button1
                            .default(Text("Camera"), action: {
                                self.showImagePicker = true
                                self.sourceType = .camera
                            }),
                            //Button2
                            .default(Text("Photo Library"), action: {
                                self.showImagePicker = true
                                self.sourceType = .photoLibrary
                            }),
                            //Button3
                            .cancel()
                            
                        ])
                    }
                    .sheet(isPresented: $showImagePicker){
                        imagePicker(image: self.$upload_image, showImagePicker: self.$showImagePicker, sourceType: self.sourceType)
                        
                    }
                }
                
                TextField("Type name here", text: $placeinput)
                    .autocapitalization(.none)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(Color.red, lineWidth: 2))
                    .padding(.top)
                    .padding()
                
                TextField("Type decription here", text: $descpinput)
                    .autocapitalization(.none)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(Color.red, lineWidth: 2))
                    .padding()
                
                
                // Tilføjer til database
                Button(action: {
                    
                    // Tager bruger Id og sætter det på document id feltet.
                    let user = Auth.auth().currentUser
                    let userid = user?.uid
                    let uuid = UUID()
                    self.repo.addPlace(place: Place(id: uuid, name: self.placeinput, description: self.descpinput, latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude, userId: userid!))
                    
                    if let thisImage = self.upload_image {
                        uploadImage(image: thisImage, id: uuid)
                    } else {
                        print("Somthing went wrong - No image present")
                    }
                    
                    // Sætter showAlert til true
                    self.showAlert.toggle()
                    print("Button pressed!!")
                    
                }) {
                    Image(systemName: "plus.circle.fill")
                        .padding(.bottom)
                        .foregroundColor(.red)
                        .font(.largeTitle)
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
// Funktion til at uploade et billed til firebase
func uploadImage(image:UIImage, id: UUID){
    
    if let imageData = image.jpegData(compressionQuality: 1){
        // Billede database
        let storage = Storage.storage()
        storage.reference().child(id.uuidString).putData(imageData, metadata: nil){
            (_, err) in
            if let err = err {
                print("an error has occurred - \(err.localizedDescription)")
            } else {
                print("image uploaded successfully")
            }
        }
    } else {
        print("coldn't unwrap/case image to data")
    }
}

// ImagePicker til at få billede på.
// Default fotoalbum
struct imagePicker:UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var showImagePicker: Bool
    
    // find ud af hvad typealias er??
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = imagePickerCoordinator
    
    var sourceType:UIImagePickerController.SourceType = .camera
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> imagePicker.Coordinator {
        return imagePickerCoordinator(image: $image, showImagePicker: $showImagePicker)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<imagePicker>) {}
    
}

// Er en class da den skal override det eksisterende billede der er valgt
// hvis et nyt billede er valgt.
class imagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var image: UIImage?
    @Binding var showImagePicker: Bool
    
    init(image:Binding<UIImage?>, showImagePicker: Binding<Bool>) {
        _image = image
        _showImagePicker = showImagePicker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = uiimage
            showImagePicker = false
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        showImagePicker = false
    }
}
