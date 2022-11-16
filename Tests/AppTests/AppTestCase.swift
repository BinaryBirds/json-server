@testable import App
import XCTVapor
import Fluent
import Spec

open class AppTestCase: XCTestCase {
    
    func getDefaultPostId(_ db: Database) async throws -> UUID? {
        try await PostModel.query(on: db).filter(\.$title == "Lorem ipsum").first()?.requireID()
    }

    func getUserToken(_ app: Application) throws -> UserToken.Detail {
        var response: UserToken.Detail?
 
        try app
            .describe("Login request should return a valid token.")
            .post("api/v1/user/login")
            .header("accept", "application/json")
            .body(User.Login(email: "root@localhost.com", password: "ChangeMe1"))
            .expect(.ok)
            .expect(.json)
            .expect(UserToken.Detail.self) { response = $0 }
            .test()

        return try XCTUnwrap(response)
    }
}
