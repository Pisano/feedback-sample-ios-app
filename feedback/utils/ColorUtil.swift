//
//  ColorUtil.swift
//  feedback
//
//  Created by YasinCetin on 29.04.2022.
//

import Foundation
import SwiftUI

class ColorUtil:ObservableObject {
    let splashColorOne = Color(0xFFE5F1FF)
    let splashColorTwo = Color(0xFFF1E9FF)
    let splashColorThree = Color(0xFFFFE5F4)
    let splashColorFour = Color(0xFFFFEEEE)
    let splashColorFive = Color(0xFFE5FFFF)
    let splashColorSix = Color(0xFFFFFEE5)
    
    var list:[Color] = [Color(0xFFE5F1FF),
                        Color(0xFFF1E9FF),
                        Color(0xFFFFE5F4),
                        Color(0xFFFFEEEE),
                        Color(0xFFE5FFFF),
                        Color(0xFFFFFEE5)]
    
    @Published var index:Int = 0
    @Published var selection:String = ""
    
    func changeBackgroundColor(isFinish:Bool) {
        @Binding var selection: String?
        
        print("value:")
        if(index == 5) {
            if(isFinish) {
                self.selection = "homeView"
                return
            }
            
            self.index = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            self.index = index + 1
           print("index değişiyor...")
            print(index)
            changeBackgroundColor(isFinish: isFinish)
        }
    }
}

extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
