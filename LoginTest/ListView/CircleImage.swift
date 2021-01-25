//
//  CircleImage.swift
//  LoginTest
//
//  Created by Nic Spiegelhauer on 28/12/2020.
//

import SwiftUI
import FirebaseStorage

struct CircleImage: View {
    
    @State var download_image:UIImage?
    
    @Binding var currentPlaceimageID: UUID
    
    var body: some View {

        VStack{
            if download_image != nil {
                Image(uiImage: download_image!)
                    .resizable()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 7)
                    .scaledToFit()
            } else {
                Loader()
            }
        }.onAppear(){
            // maxSize er max størelsen på billedet man henter ned.
            Storage.storage().reference().child(currentPlaceimageID.uuidString).getData(maxSize: 500000000){
                (imageData, err) in
                if let err = err {
                    print("an error has occurred - \(err.localizedDescription)")
                } else {
                    if let imageData = imageData {
                        self.download_image = UIImage(data: imageData)
                        
                        print("Image downloaded!")
                    } else {
                        print("couldn't unwrap image data image")
                    }
                }
            }
        }
    }
}

// Laver animationen til loading!!
struct Loader: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Loader>){
    
    }
    
}
