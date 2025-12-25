import Foundation

struct Config: Codable {
    let accessKey: String
    let apiUrl: String
    let appId: String
    var eventUrl: String = ""
    let feedbackUrl: String
}
