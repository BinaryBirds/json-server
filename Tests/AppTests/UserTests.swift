@testable import App
import XCTVapor
import Spec

final class UserTests: AppTestCase {
    
    func testValidLogin() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        try app
            .describe("Login request should return a valid token.")
            .post("api/v1/user/login")
            .header("accept", "application/json")
            .body(User.Login(email: "root@localhost.com", password: "ChangeMe1"))
            .expect(.ok)
            .expect(.json)
            .expect(UserToken.Detail.self)
            .test()
    }
    
    func testInvalidLogin() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        try app
            .describe("Invalid login request should return with an unauthorized status code.")
            .post("api/v1/user/login")
            .header("accept", "application/json")
            .body(User.Login(email: "root@localhost.com", password: "InvalidPassword"))
            .expect(.unauthorized)
            .test()
    }
    
    func testUserProfileWithAuthToken() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let token = try getUserToken(app)
        
        try app
            .describe("Authorized profile request should return with the user data.")
            .get("api/v1/user/me")
            .header("accept", "application/json")
            .bearerToken(token.value)
            .expect(.ok)
            .expect(.json)
            .expect(User.Detail.self)
            .test()
    }
    
    func testUserProfileWithInvalidAuthToken() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app
            .describe(#function)
            .get("api/v1/user/me")
            .header("accept", "application/json")
            .bearerToken("invalid-token")
            .expect(.unauthorized)
            .test()
    }
    
    func testUserProfileUpdate() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let token = try getUserToken(app)
        
        try app
            .describe("Authorized profile request should return with the user data.")
            .put("api/v1/user/me")
            .bearerToken(token.value)
            .header("accept", "application/json")
            .body(User.Update(
                imageUrl: nil,
                name: nil,
                email: "updated@localhost.com",
                password: "ChangeMe1"
            ))
            .expect(.ok)
            .expect(.json)
            .expect(User.Detail.self) { user in
                XCTAssertEqual(user.imageUrl, nil)
                XCTAssertEqual(user.name, nil)
                XCTAssertEqual(user.email, "root@localhost.com")
            }
            .test()
    }
    
    func testUserProfilePatch() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let token = try getUserToken(app)
        
        try app
            .describe("Authorized profile request should return with the user data.")
            .patch("api/v1/user/me")
            .bearerToken(token.value)
            .header("accept", "application/json")
            .body(User.Patch(name: "Jane"))
            .expect(.ok)
            .expect(.json)
            .expect(User.Detail.self) { user in
                XCTAssertEqual(user.name, "Jane")
            }
            .test()
    }
}
