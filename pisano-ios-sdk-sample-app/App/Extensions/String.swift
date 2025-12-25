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
    public static var externalId: LocalizedStringKey = "external_id"
    public static var name: LocalizedStringKey = "name"
    public static var invalidInput: LocalizedStringKey = "invalid_input"
    public static var createFlow: LocalizedStringKey = "create_flow"
    public static var back: LocalizedStringKey = "back"
    public static var actionStatus: LocalizedStringKey = "action_status"
    public static var submitted: LocalizedStringKey = "submitted"
    public static var clicked: LocalizedStringKey = "clicked"
    public static var share: LocalizedStringKey = "share"
    public static var start: LocalizedStringKey = "start"
    public static var done: LocalizedStringKey = "done"
    public static var owner: LocalizedStringKey = "owner"
    public static var participant: LocalizedStringKey = "participant"
    public static var newFlow: LocalizedStringKey = "new_flow"
    public static var gettingStarted: LocalizedStringKey = "getting_started"
    public static var flows: LocalizedStringKey = "flows"
    public static var clear: LocalizedStringKey = "clear"
    public static var title: LocalizedStringKey = "custom_title"
    public static var `default`: LocalizedStringKey = "default"
    public static var bottomSheet: LocalizedStringKey = "bottom_sheet"
    public static var font: LocalizedStringKey = "font"
}

extension String {
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func isEmailValid() -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@",
                                    "^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$")
        return predicate.evaluate(with: self)
    }
}
