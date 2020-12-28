//
//  CircleImage.swift
//  LoginTest
//
//  Created by Nic Spiegelhauer on 28/12/2020.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("landscape")
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 7)
    }
}
