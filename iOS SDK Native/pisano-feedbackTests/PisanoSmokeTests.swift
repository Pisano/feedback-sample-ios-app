import XCTest
import PisanoFeedback

final class PisanoSmokeTests: XCTestCase {
    private func info(_ key: String) -> String {
        // Hosted tests -> Bundle.main is the app bundle.
        (Bundle.main.object(forInfoDictionaryKey: key) as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    func test_boot_and_healthCheck_reaches_api() throws {
        let appId = info("PISANO_APP_ID")
        let accessKey = info("PISANO_ACCESS_KEY")
        let apiUrl = info("PISANO_API_URL")
        let feedbackUrl = info("PISANO_FEEDBACK_URL")
        let eventUrl = info("PISANO_EVENT_URL")

        guard !appId.isEmpty, !accessKey.isEmpty, !apiUrl.isEmpty, !feedbackUrl.isEmpty else {
            throw XCTSkip("Set PISANO_APP_ID / PISANO_ACCESS_KEY / PISANO_API_URL / PISANO_FEEDBACK_URL in the host app Info.plist to run this smoke test.")
        }

        let bootExp = expectation(description: "Pisano.boot completes")

        Pisano.boot(appId: appId,
                    accessKey: accessKey,
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


