@testable import App
import XCTVapor
import Spec

final class AppTests: AppTestCase {
    
    func testItWorks() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app
            .describe("It should work!")
            .get("")
            .expect(.ok)
            .expect(.html)
            .test()
    }

}
