//
//  CustomTextField.swift
//  feedback
//
//  Created by Abdulkerim Şahin on 11.05.2022.
//

import SwiftUI

struct CustomTextField: View {
    let title: LocalizedStringKey
    let placeholder: LocalizedStringKey?
    var icon: Image?
    let type: InputType
    let isRequired: Bool
    
    @Binding var text: String
    @Binding var isValid: Bool
    @State private var isEditing: Bool = false
    
    enum InputType {
        case plain, email, phone
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .plain:
                return .default
            case .email:
                return .emailAddress
            case .phone:
                return .phonePad
            }
        }
        
        var regexRequired: Bool {
            switch self {
            case .email, .phone:
                return true
            default:
                return false
            }
        }
        
        func isValid(text: String) -> Bool {
            if !self.regexRequired { return true }
            
            switch self {
            case .email:
                return text.isEmailValid()
            case .phone:
                return true
            default:
                return true
            }
        }
        
        func invalidText(isRequired: Bool,
                         text: String) -> LocalizedStringKey {
            if isRequired && text.isEmpty {
                return .requiredField
            } else {
                if regexRequired {
                    return .invalidInput
                } else {
                    return ""
                }
            }
        }
    }
    
    init(title: LocalizedStringKey,
         placeholder: LocalizedStringKey? = nil,
         icon: Image? = nil,
         type: InputType = .plain,
         isRequired: Bool = false,
         text: Binding<String>,
         isValid: Binding<Bool> = .constant(true)) {
        self.title = title
        self.placeholder = placeholder
        self.icon = icon
        self.type = type
        self.isRequired = isRequired
        _text = text
        _isValid = isValid
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let icon = icon {
                    icon
                        .padding(.leading)
                        .foregroundColor(isEditing ? .tint : .darkGray)
                }
                
                TextField(isEditing ? placeholder ?? title : title,
                          text: $text, onEditingChanged: { changed in
                    isEditing = changed
                    if !text.isEmpty {
                        isValid = type.isValid(text: text)
                    } else {
                        isValid = !isRequired
                    }
                })
                .keyboardType(type.keyboardType)
                .padding(.vertical)
                .font(.body)
                .foregroundColor(.black)
            }
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isEditing ? Color.tint : Color.lightGray, lineWidth: 1)
                )
            .overlay(
                Text(title)
                    .foregroundColor(isEditing ? .tint : .darkGray)
                    .font(.subheadline)
                    .padding(.horizontal, 5)
                    .background(
                        Rectangle()
                        .fill(.white)
                    )
                    .offset(x: 10, y: -8)
                    .opacity(isEditing ? 1 : 0)
                , alignment: .topLeading
            )
            
            if !isValid {
                Text(type.invalidText(isRequired: isRequired,
                                      text: text))
                .font(.footnote)
                .padding(.leading)
                .foregroundColor(.red)
                .opacity(isValid ? 0 : 1)
            }
        }
        .padding(.bottom)
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(title: "Test",
                        placeholder: "placeholder",
                        icon: Image(systemName: "lock.fill"),
                        type: .email,
                        text: .constant(""))
    }
}
