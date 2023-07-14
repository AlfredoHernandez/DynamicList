//
//  SwiftUIView.swift
//  
//
//  Created by Jesús Alfredo Hernández Alarcón on 13/07/23.
//

import SwiftUI

struct AdvertisementView: View {
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("This is a sample advertisement")
                .font(.title3)
                .bold()
            Text(text)
        }
    }
}

struct AdvertisementView_Previews: PreviewProvider {
    static var previews: some View {
        AdvertisementView(text: "Advertisment: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
    }
}
