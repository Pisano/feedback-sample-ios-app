//
//  String.swift
//  feedback
//
//  Created by Abdulkerim Şahin on 11.05.2022.
//

import SwiftUI

extension LocalizedStringKey {
    public static var getFeedback: LocalizedStringKey = "get_feedback"
    public static var requiredField: LocalizedStringKey = "this_field_is_required"
    public static var email: LocalizedStringKey = "email_address"
    public static var phone: LocalizedStringKey = "phone_number"
    public static var name: LocalizedStringKey = "name"
    public static var invalidInput: LocalizedStringKey = "invalid_input"
}

extension String {
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
