@testable import App
import XCTVapor
import Spec

final class TagTests: AppTestCase {
    
    func testList() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        try app
            .describe(#function)
            .get("tags")
            .header("accept", "application/json")
            .expect(.ok)
            .expect(.json)
            .expect([Tag.List].self) { tags in
                XCTAssertEqual(tags.count, 2)
            }
            .test()
    }
    
    func testCreate() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        try app
            .describe(#function)
            .post("tags")
            .bearerToken(try getUserToken(app).value)
            .header("accept", "application/json")
            .body(Tag.Create(name: "Yellow"))
            .expect(.ok)
            .expect(.json)
            .expect(Tag.Detail.self)
            .test()
        
        try app
            .describe(#function)
            .get("tags")
            .header("accept", "application/json")
            .expect(.ok)
            .expect(.json)
            .expect([Tag.List].self) { tags in
                XCTAssertEqual(tags.count, 3)
            }
            .test()
    }
    
    func testUpdate() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        guard let tagId = try await TagModel.query(on: app.db).first()?.requireID() else {
            return XCTFail("Missing tag")
        }
        try app
            .describe(#function)
            .put("tags/\(tagId.uuidString)")
            .bearerToken(try getUserToken(app).value)
            .header("accept", "application/json")
            .body(Tag.Update(name: "Updated"))
            .expect(.ok)
            .expect(.json)
            .expect(Tag.Detail.self) { tag in
                XCTAssertEqual(tag.name, "Updated")
            }
            .test()
    }
    
    func testPatch() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        guard let tagId = try await TagModel.query(on: app.db).first()?.requireID() else {
            return XCTFail("Missing tag")
        }
        try app
            .describe(#function)
            .patch("tags/\(tagId.uuidString)")
            .bearerToken(try getUserToken(app).value)
            .header("accept", "application/json")
            .body(Tag.Patch(name: "Patched"))
            .expect(.ok)
            .expect(.json)
            .expect(Tag.Detail.self) { tag in
                XCTAssertEqual(tag.name, "Patched")
            }
            .test()
    }
    
    func testDelete() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        guard let tagId = try await TagModel.query(on: app.db).first()?.requireID() else {
            return XCTFail("Missing tag")
        }
        try app
            .describe(#function)
            .delete("tags/\(tagId.uuidString)")
            .bearerToken(try getUserToken(app).value)
            .expect(.noContent)
            .test()
        
        try app
            .describe(#function)
            .get("tags")
            .header("accept", "application/json")
            .expect(.ok)
            .expect(.json)
            .expect([Tag.List].self) { tags in
                XCTAssertEqual(tags.count, 1)
            }
            .test()
        
        let postTagCount = try await PostTagsModel.query(on: app.db).count()
        XCTAssertEqual(postTagCount, 1)
    }
}
