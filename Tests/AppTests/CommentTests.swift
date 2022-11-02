@testable import App
import XCTVapor
import Fluent
import Spec

final class CommentTests: AppTestCase {
    
    func testList() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        guard let postId = try await getDefaultPostId(app.db) else {
            return XCTFail("Missing post")
        }

        try app
            .describe(#function)
            .get("posts/\(postId.uuidString)/comments/")
            .header("accept", "application/json")
            .expect(.ok)
            .expect(.json)
            .expect([Comment.List].self) { comments in
                XCTAssertEqual(comments.count, 2)
            }
            .test()
    }
    
    func testCreate() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        guard let postId = try await getDefaultPostId(app.db) else {
            return XCTFail("Missing post")
        }
        
        try app
            .describe(#function)
            .post("posts/\(postId.uuidString)/comments")
            .bearerToken(try getUserToken(app).value)
            .header("accept", "application/json")
            .body(Comment.Create(content: "Lorem amet sit dolor"))
            .expect(.ok)
            .expect(.json)
            .expect(Comment.Detail.self)
            .test()
        
        try app
            .describe(#function)
            .get("posts/\(postId.uuidString)/comments")
            .header("accept", "application/json")
            .expect(.ok)
            .expect(.json)
            .expect([Comment.List].self) { comments in
                XCTAssertEqual(comments.count, 3)
            }
            .test()
    }
    
    func testDelete() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        let token = try getUserToken(app)
        guard let comment = try await CommentModel.query(on: app.db).filter(\.$userId == token.user.id).first() else {
            return XCTFail("Missing comment")
        }
        let commentId = try comment.requireID()

        try app
            .describe(#function)
            .delete("posts/\(comment.postId.uuidString)/comments/\(commentId.uuidString)")
            .bearerToken(token.value)
            .header("accept", "application/json")
            .expect(.ok)
            .expect(.json)
            .expect(Comment.Detail.self) { comment in
                XCTAssertEqual(comment.content, "DELETED")
            }
            .test()
    }
    
    func testInvalidDelete() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        let token = try getUserToken(app)
        guard let comment = try await CommentModel.query(on: app.db).filter(\.$userId != token.user.id).first() else {
            return XCTFail("Missing comment")
        }
        let commentId = try comment.requireID()

        try app
            .describe(#function)
            .delete("posts/\(comment.postId.uuidString)/comments/\(commentId.uuidString)")
            .bearerToken(token.value)
            .header("accept", "application/json")
            .expect(.forbidden)
            .test()
    }
}
