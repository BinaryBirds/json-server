@testable import App
import XCTVapor
import Fluent
import Spec

final class PostTests: AppTestCase {
    
    func testList() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        try app
            .describe(#function)
            .get("posts")
            .header("accept", "application/json")
            .expect(.ok)
            .expect(.json)
            .expect(Page<Post.List>.self) { page in
                XCTAssertEqual(page.metadata.total, 27)
            }
            .test()
    }
    
    func testCreate() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        guard let tagId = try await TagModel.query(on: app.db).first()?.requireID() else {
            return XCTFail("Missing tag")
        }
        
        try app
            .describe(#function)
            .post("posts")
            .bearerToken(try getUserToken(app).value)
            .header("accept", "application/json")
            .body(Post.Create(
                imageUrl: "https://placekitten.com/640/360",
                title: "Ipsum sit amet",
                excerpt: "Lorem dolor sit ipsum",
                date: Date(),
                content: "Cras semper fringilla pharetra.",
                tagIds: [tagId]
            ))
            .expect(.ok)
            .expect(.json)
            .expect(Post.Detail.self) { post in
                XCTAssertEqual(post.tags.count, 1)
            }
            .test()
        
        try app
            .describe(#function)
            .get("posts")
            .header("accept", "application/json")
            .expect(.ok)
            .expect(.json)
            .expect(Page<Post.List>.self) { page in
                XCTAssertEqual(page.metadata.total, 28)
            }
            .test()
    }
    
    func testUpdate() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        guard let postId = try await PostModel.query(on: app.db).first()?.requireID() else {
            return XCTFail("Missing post")
        }
        guard let tagId = try await TagModel.query(on: app.db).first()?.requireID() else {
            return XCTFail("Missing tag")
        }
        
        try app
            .describe(#function)
            .put("posts/\(postId.uuidString)")
            .bearerToken(try getUserToken(app).value)
            .header("accept", "application/json")
            .body(Post.Create(
                imageUrl: "https://placekitten.com/640/360",
                title: "Updated",
                excerpt: "Lorem dolor sit ipsum",
                date: Date(),
                content: "Cras semper fringilla pharetra.",
                tagIds: [tagId]
            ))
            .expect(.ok)
            .expect(.json)
            .expect(Post.Detail.self) { post in
                XCTAssertEqual(post.title, "Updated")
                XCTAssertEqual(post.tags.count, 1)
            }
            .test()
    }
    
    func testPatch() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        guard let postId = try await PostModel.query(on: app.db).first()?.requireID() else {
            return XCTFail("Missing post")
        }
        
        try app
            .describe(#function)
            .patch("posts/\(postId.uuidString)")
            .bearerToken(try getUserToken(app).value)
            .header("accept", "application/json")
            .body(Post.Patch(title: "Patched"))
            .expect(.ok)
            .expect(.json)
            .expect(Post.Detail.self) { post in
                XCTAssertEqual(post.imageUrl, "https://placekitten.com/640/360")
                XCTAssertEqual(post.title, "Patched")
                XCTAssertEqual(post.excerpt, "Excerpt #1")
                XCTAssertEqual(post.content, "Content #1")
                XCTAssertEqual(post.tags.count, 0)
            }
            .test()
    }
    
    func testDelete() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        guard let postId = try await getDefaultPostId(app.db) else {
            return XCTFail("Missing post")
        }

        try app
            .describe(#function)
            .delete("posts/\(postId.uuidString)")
            .bearerToken(try getUserToken(app).value)
            .header("accept", "application/json")
            .expect(.noContent)
            .test()
        
        let postTagCount = try await PostTagsModel.query(on: app.db).count()
        let commentCount = try await CommentModel.query(on: app.db).count()
        XCTAssertEqual(postTagCount, 0)
        XCTAssertEqual(commentCount, 0)
    }
}
