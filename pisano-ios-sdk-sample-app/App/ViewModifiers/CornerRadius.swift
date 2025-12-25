//
//  CornerRadius.swift
//  feedback
//
//  Created by Abdulkerim Şahin on 11.05.2022.
//

import SwiftUI

private struct CornerRadiusShape: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let beizerPath = UIBezierPath(roundedRect: rect,
                            byRoundingCorners: corners,
                            cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(beizerPath.cgPath)
    }
}

private struct CornerRadiusModifier: ViewModifier {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        self.modifier(CornerRadiusModifier(radius: radius, corners: corners))
    }
}
