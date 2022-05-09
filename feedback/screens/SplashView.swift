//
//  SplashView.swift
//  feedback
//
//  Created by YasinCetin on 29.04.2022.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var colorUtil = ColorUtil()
    @Binding var selection: String?
    
    var body: some View {
        
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Image("PisanoLogo")
                    .padding()
                Spacer()
            }
            
            Spacer()
        }
        .background(colorUtil.list[colorUtil.index])
        .onAppear{
            colorUtil.changeBackgroundColor(isFinish: true)
        
        }
        
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView( selection: .constant(nil))
    }
}
