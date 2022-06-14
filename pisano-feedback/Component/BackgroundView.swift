//
//  BackgroundView.swift
//  feedback
//
//  Created by Abdulkerim Şahin on 11.05.2022.
//

import SwiftUI

struct BackgroundView: View {
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Color.splashColors[currentIndex]
            .animation(.easeInOut)
            .edgesIgnoringSafeArea(.all)
            .onReceive(timer) { value in
                let splashColors = Color.splashColors
                currentIndex += 1
                if currentIndex == splashColors.count {
                    currentIndex = 0
                }
            }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
