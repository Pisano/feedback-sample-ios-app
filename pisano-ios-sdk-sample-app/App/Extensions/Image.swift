//
//  Image.swift
//  feedback
//
//  Created by Abdulkerim Şahin on 11.05.2022.
//

import SwiftUI

extension Image {
    public static var logo: Image {
        Image("PisanoLogo")
    }
    
    public static var share: Image {
        Image(systemName: "square.and.arrow.up")
    }
    
    public static var preview: Image {
        Image(systemName: "eye")
    }
    
    public static var checkmark: Image {
        Image(systemName: "checkmark")
    }
}
