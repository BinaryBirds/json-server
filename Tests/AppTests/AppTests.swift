@testable import App
import XCTVapor
import Spec

final class AppTests: AppTestCase {
    
    func testItWorks() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let expectation = "It works!"
        var response: String?
        
        try app
            .describe("It should work!")
            .get("")
            .expect(.ok)
            .expect(.plainText)
            .expect("content-length", [String(expectation.count)])
            .expect(String.self) { response = $0 }
            .test()
        
        XCTAssertEqual(response, expectation)
    }

}
