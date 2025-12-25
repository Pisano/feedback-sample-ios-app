//
//  Font.swift
//  pisano-feedback
//
//  Created by Abdulkerim Şahin on 1.11.2022.
//

import SwiftUI

extension UIFont {
    var value: String {
        switch self {
        case .preferredFont(forTextStyle: .largeTitle): return "Large Title"
        case .preferredFont(forTextStyle: .title1): return "Title 1"
        case .preferredFont(forTextStyle: .title2): return "Title 2"
        case .preferredFont(forTextStyle: .title3): return "Title 3"
        case .preferredFont(forTextStyle: .headline): return "Headline"
        case .preferredFont(forTextStyle: .subheadline): return "Subheadline"
        case .preferredFont(forTextStyle: .body): return "Body"
        case .preferredFont(forTextStyle: .callout): return "Callout"
        case .preferredFont(forTextStyle: .footnote): return "Footnote"
        case .preferredFont(forTextStyle: .caption1): return "Caption 1"
        case .preferredFont(forTextStyle: .caption2): return "Caption 2"
        default: return ""
        }
    }
}
