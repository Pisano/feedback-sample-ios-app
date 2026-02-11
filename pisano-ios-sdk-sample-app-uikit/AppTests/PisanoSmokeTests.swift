import XCTest
import PisanoFeedback

final class PisanoSmokeTests: XCTestCase {
    private func value(_ key: String) -> String {
        // Prefer PisanoSecrets.plist if the host app bundles it
        if let url = Bundle.main.url(forResource: "PisanoSecrets", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let obj = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
           let dict = obj as? [String: Any],
           let s = dict[key] as? String {
            let v = s.trimmingCharacters(in: .whitespacesAndNewlines)
            if !v.isEmpty { return v }
        }

        // Fallback: Info.plist
        return (Bundle.main.object(forInfoDictionaryKey: key) as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    func test_boot_healthCheck_and_track_reaches_api() throws {
        let appId = value("PISANO_APP_ID")
        let accessKey = value("PISANO_ACCESS_KEY")
        let code = value("PISANO_CODE")
        let apiUrl = value("PISANO_API_URL")
        let feedbackUrl = value("PISANO_FEEDBACK_URL")
        let eventUrl = value("PISANO_EVENT_URL")

        guard !appId.isEmpty, !accessKey.isEmpty, !code.isEmpty, !apiUrl.isEmpty, !feedbackUrl.isEmpty else {
            throw XCTSkip("Set PISANO_APP_ID / PISANO_ACCESS_KEY / PISANO_CODE / PISANO_API_URL / PISANO_FEEDBACK_URL in the host app Info.plist to run this smoke test.")
        }

        let bootExp = expectation(description: "Pisano.boot completes")
        Pisano.boot(appId: appId,
                    accessKey: accessKey,
                    code: code,
                    apiUrl: apiUrl,
                    feedbackUrl: feedbackUrl,
                    eventUrl: eventUrl.isEmpty ? nil : eventUrl) { status in
            XCTAssertNotEqual(status, .initFailed)
            bootExp.fulfill()
        }
        wait(for: [bootExp], timeout: 30)

        let hcExp = expectation(description: "Pisano.healthCheck returns")
        Pisano.healthCheck { ok in
            XCTAssertTrue(ok)
            hcExp.fulfill()
        }
        wait(for: [hcExp], timeout: 30)
    }
}


