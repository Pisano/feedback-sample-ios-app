//
//  Config.swift
//  pisano-feedback
//
//  Created by Abdulkerim Şahin on 30.06.2022.
//

import Foundation

struct Config: Codable {
    let appId: String
    let accessKey: String
    let apiUrl: String
    let feedbackUrl: String = ""
    var eventUrl: String = ""
}
