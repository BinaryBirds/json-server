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
     curl -X POST "http://localhost:8080/files/?key=test.jpg" \
         -H "Authorization: Bearer TOKEN" \
         -H "Accept: application/json" \
         --data-binary @"/Users/tib/test.jpg"|json
     ```
     */
    func upload(req: Request) async throws -> String {
        let key = try req.query.get(String.self, at: "key")
        let path = req.application.directory.publicDirectory + key
        return try await req.body.collect()
            .unwrap(or: Abort(.noContent))
            .flatMap { req.fileio.writeFile($0, at: path) }
            .map { "http://localhost:8080/" + key }
            .get()
    }
}
