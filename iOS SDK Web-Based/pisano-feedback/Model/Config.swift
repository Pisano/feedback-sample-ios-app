//
//  Config.swift
//  pisano-feedback
//
//  Created by Abdulkerim Şahin on 30.06.2022.
//

import Foundation

struct Config: Codable {
    let accessKey: String
    let apiUrl: String
    let appId: String
    var eventUrl: String = ""
    let feedbackUrl: String
}
