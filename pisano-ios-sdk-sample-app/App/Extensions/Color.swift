import SwiftUI

extension Color {
    public static var splashColors: [Color] {
        var colors = [Color]()
        (0..<6).forEach { index in
            colors.append(Color("Color-\(index)"))
        }
        return colors
    }
    
    public static var darkGray : Color { Color("DarkGray") }
    public static var lightGray: Color { Color("Gray") }
    public static var tint: Color { Color("Tint") }
    public static var text: Color { Color("Text") }
}
