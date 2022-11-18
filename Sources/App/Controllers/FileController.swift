import Vapor

struct FileController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes
            .grouped(UserTokenAuthenticator())
            .grouped(ApiUser.guardMiddleware())
            .on(.POST, "files", body: .collect(maxSize: "10mb"), use: upload)
    }

    /**
     ```sh
     curl -X POST "http://localhost:8080/api/v1/files/?key=test.jpg" \
         -H "Authorization: Bearer [TOKEN]" \
         --data-binary @"/Users/tib/test.jpg"
     ```
     */
    func upload(req: Request) async throws -> String {
        let key = try req.query.get(String.self, at: "key")
        
        let baseUrl = URL(fileURLWithPath: req.application.directory.publicDirectory)
        let uploadsUrl = baseUrl.appendingPathComponent("uploads")
        let fileUrl = uploadsUrl.appendingPathComponent(key)

        try? FileManager.default.createDirectory(
            at: uploadsUrl,
            withIntermediateDirectories: false,
            attributes: [.posixPermissions: 0o744]
        )
        
        return try await req.body.collect()
            .unwrap(or: Abort(.noContent))
            .flatMap { req.fileio.writeFile($0, at: fileUrl.path) }
            .map { "http://localhost:8080/uploads/" + key }
            .get()
    }
}
