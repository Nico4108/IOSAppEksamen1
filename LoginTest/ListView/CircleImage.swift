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
    
    var body: some View {
        //Image(uiImage: download_image!)
        Image("landscape")
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 7)
    }
    
    /*func download_Image() {
        Storage.storage().reference().child("temp1").getData(maxSize: 2 * 1024 * 1024){
            (imageData, err) in
            if let err = err {
                print("an error has occurred - \(err.localizedDescription)")
            } else {
                if let imageData = imageData {
                    self.download_image = UIImage(data: imageData)
                } else {
                    print("couldn't unwrap image data image")
                }
                
            }
        }
    }*/
    
}
