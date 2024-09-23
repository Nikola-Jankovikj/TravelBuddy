//
//  ImageSliderView.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 23.9.24.
//

import SwiftUI
import UIKit

struct ImageSliderView: View {
    @Binding var imageData: [Data?]
    var width: CGFloat
    
    var body: some View {
        TabView {
            ForEach(imageData.compactMap { $0 }, id: \.self) { data in
                if let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: width)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(maxWidth: width, maxHeight: width * 1.5)
    }
}
