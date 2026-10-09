import SwiftUI

extension LocalizedStringKey {
    public static let getFeedback: LocalizedStringKey = "get_feedback"
    public static let requiredField: LocalizedStringKey = "this_field_is_required"
    public static let email: LocalizedStringKey = "email_address"
    public static let phone: LocalizedStringKey = "phone_number"
    public static let externalId: LocalizedStringKey = "external_id"
    public static let name: LocalizedStringKey = "name"
    public static let invalidInput: LocalizedStringKey = "invalid_input"
    public static let createFlow: LocalizedStringKey = "create_flow"
    public static let back: LocalizedStringKey = "back"
    public static let actionStatus: LocalizedStringKey = "action_status"
    public static let submitted: LocalizedStringKey = "submitted"
    public static let clicked: LocalizedStringKey = "clicked"
    public static let share: LocalizedStringKey = "share"
    public static let start: LocalizedStringKey = "start"
    public static let done: LocalizedStringKey = "done"
    public static let owner: LocalizedStringKey = "owner"
    public static let participant: LocalizedStringKey = "participant"
    public static let newFlow: LocalizedStringKey = "new_flow"
    public static let gettingStarted: LocalizedStringKey = "getting_started"
    public static let flows: LocalizedStringKey = "flows"
    public static let clear: LocalizedStringKey = "clear"
    public static let title: LocalizedStringKey = "custom_title"
    public static let `default`: LocalizedStringKey = "default"
    public static let bottomSheet: LocalizedStringKey = "bottom_sheet"
    public static let font: LocalizedStringKey = "font"
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
