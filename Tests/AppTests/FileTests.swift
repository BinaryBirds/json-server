@testable import App
import XCTVapor
import Spec

final class FileTests: AppTestCase {
    
    func testUpload() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        try app
            .describe(#function)
            .post("api/v1/files?key=hello.txt")
            .bearerToken(try getUserToken(app).value)
            .header("accept", "application/json")
            .body("hello world")
            .expect(.ok)
            .expect(.plainText)
            .expect(String.self) { value in
                XCTAssertEqual(value, "http://localhost:8080/uploads/hello.txt")
            }
            .test()
    }
}
