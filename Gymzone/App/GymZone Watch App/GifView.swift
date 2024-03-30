//
//  GifView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 20/04/23.
//

import SwiftUI

//  

struct Gif: View {
    @State private var currentIndex = 0
    let images: [String]
    let width: CGFloat
    let heigth: CGFloat
    
        var body: some View {
            Image(images[currentIndex])
                .resizable()
                .scaledToFill()
                .frame(width: width, height: heigth, alignment: .center)
                .clipped()
                .onReceive(Timer.publish(every: 0.07, on: .main, in: .common).autoconnect()) { _ in
                    currentIndex = (currentIndex + 1) % images.count
                }
        }
}

struct Gif_Previews: PreviewProvider {
    static var previews: some View {
        Gif(images: ["AF01", "AF02", "AF03", "AF04", "AF05", "AF06", "AF07", "AF08", "AF09", "AF10", "AF11", "AF12", "AF13", "AF14", "AF15", "AF16", "AF17", "AF18", "AF19", "AF20", "AF21", "AF22", "AF23", "AF24", "AF25", "AF26", "AF27", "AF28", "AF29", "AF30", "AF31", "AF32", "AF33", "AF34", "AF35", "AF36", "AF37", "AF38", "AF39", "AF40", "AF41", "AF42", "AF43", "AF44", "AF45", "AF46", "AF47", "AF48", "AF49", "AF50", "AF51", "AF52", "AF53"],width: 100,heigth: 100)
    }
}

