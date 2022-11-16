import Fluent
import Vapor

struct TagController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let baseRoutes = routes
            .grouped("tags")

        let safeRoutes = baseRoutes
            .grouped(UserTokenAuthenticator())
            .grouped(ApiUser.guardMiddleware())

        baseRoutes.get(use: list)
        baseRoutes.grouped(":tagId").get(use: detail)
        
        safeRoutes.post(use: create)
        safeRoutes.group(":tagId") { routes in
            routes.put(use: update)
            routes.patch(use: patch)
            routes.delete(use: delete)
        }
    }

    // MARK: - helpers
    
    private func find(_ req: Request) async throws -> TagModel {
        guard
            let id = req.parameters.get("tagId"),
            let uuid = UUID(uuidString: id),
            let model = try await TagModel.find(uuid, on: req.db)
        else {
            throw Abort(.notFound)
        }
        return model
    }
    
    // MARK: - api functions
    
    /**
     ```sh
     curl -X GET http://localhost:8080/tags \
         -H "Accept: application/json" \
         |jq
     ```
     */
    func list(req: Request) async throws -> [Tag.List] {
        try await TagModel.query(on: req.db).all().map {
            .init(id: try $0.requireID(), name: $0.name)
        }
    }
    
    /**
     ```sh
     curl -X GET http://localhost:8080/tags/[id]/ \
         -H "Accept: application/json" \
         |jq
     ```
     */
    func detail(req: Request) async throws -> Tag.Detail {
        let model = try await find(req)
        let id = try model.requireID()
        return .init(id: id, name: model.name)
    }

    /**
     ```sh
     curl -X POST http://localhost:8080/tags \
         -H "Authorization: Bearer TOKEN" \
         -H "Content-Type: application/json" \
         -H "Accept: application/json" \
         --data-raw '
         {
             "name": "Yellow"
         }
         '|jq
     ```
     */
    func create(req: Request) async throws -> Tag.Detail {
        let input = try req.content.decode(Tag.Create.self)
        let model = TagModel(name: input.name)
        try await model.create(on: req.db)
        return .init(id: try model.requireID(), name: model.name)
    }

    /**
     ```sh
     curl -X PUT http://localhost:8080/tags/IDENTIFIER \
         -H "Authorization: Bearer TOKEN" \
         -H "Content-Type: application/json" \
         -H "Accept: application/json" \
         --data-raw '
         {
             "name": "Orange"
         }
         '|jq
     ```
     */
    func update(req: Request) async throws -> Tag.Detail {
        let model = try await find(req)
        let input = try req.content.decode(Tag.Update.self)
        model.name = input.name
        try await model.update(on: req.db)
        return .init(id: try model.requireID(), name: model.name)
    }
    
    /**
     ```sh
     curl -X PATCH http://localhost:8080/tags/IDENTIFIER \
         -H "Authorization: Bearer TOKEN" \
         -H "Content-Type: application/json" \
         -H "Accept: application/json" \
         --data-raw '
         {
             "name": "Orange"
         }
         '|jq
     ```
     */
    func patch(req: Request) async throws -> Tag.Detail {
        let model = try await find(req)
        let input = try req.content.decode(Tag.Patch.self)
        model.name = input.name ?? model.name
        try await model.update(on: req.db)
        return .init(id: try model.requireID(), name: model.name)
    }
    
    /**
     ```sh
     curl -i -X DELETE http://localhost:8080/tags/IDENTIFIER/ \
         -H "Authorization: Bearer TOKEN"
     ```
     */
    func delete(req: Request) async throws -> HTTPStatus {
        let model = try await find(req)
        let id = try model.requireID()

        try await req.db.transaction { db in
            try await PostTagsModel.query(on: db).filter(\.$tagId == id).delete()
            try await model.delete(on: db)
        }
        return .noContent
    }
}
