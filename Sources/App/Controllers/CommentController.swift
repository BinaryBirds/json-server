import Fluent
import Vapor

struct CommentController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let baseRoutes = routes
            .grouped("posts")
            .grouped(":postId")
            .grouped("comments")

        let safeRoutes = baseRoutes
            .grouped(UserTokenAuthenticator())
            .grouped(ApiUser.guardMiddleware())
        
        baseRoutes.get(use: list)
        safeRoutes.post(use: create)
        safeRoutes.grouped(":commentId").delete(use: delete)
    }
    
    // MARK: - helpers
    
    private func find(_ req: Request) async throws -> CommentModel {
        guard
            let id = req.parameters.get("commentId"),
            let uuid = UUID(uuidString: id),
            let model = try await CommentModel.find(uuid, on: req.db)
        else {
            throw Abort(.notFound)
        }
        return model
    }
    
    // MARK: - api functions

    /**
     ```sh
     curl -X GET http://localhost:8080/posts/IDENTIFIER/comments/ \
         -H "Accept: application/json" \
         |json
     ```
     */
    func list(req: Request) async throws -> [Comment.List] {
        guard
            let id = req.parameters.get("postId"),
            let uuid = UUID(uuidString: id)
        else {
            throw Abort(.notFound)
        }
        let comments = try await CommentModel
            .query(on: req.db)
            .filter(\.$postId == uuid)
            .all()

        let users = try await UserModel
            .query(on: req.db)
            .filter(\.$id ~~ comments.map(\.userId))
            .all()
        
        var usersDict: [UUID: User.List] = [:]
        for user in users {
            usersDict[try user.requireID()] = .init(
                id: try user.requireID(),
                imageUrl: user.imageUrl,
                name: user.name,
                email: user.email
            )
        }

        return try comments.map {
            .init(
                id: try $0.requireID(),
                date: $0.date,
                content: $0.content,
                user: usersDict[$0.userId]!
            )
        }
    }

    /**
     ```sh
     curl -X POST http://localhost:8080/posts/IDENTIFIER/comments/ \
         -H "Authorization: Bearer TOKEN" \
         -H "Content-Type: application/json" \
         -H "Accept: application/json" \
         --data-raw '
         {
             "content": "Lorem ipsum dolor sit amet"
         }
         '|json
     ```
     */
    func create(req: Request) async throws -> Comment.Detail {
        guard
            let rawPostId = req.parameters.get("postId"),
            let postId = UUID(uuidString: rawPostId),
            let post = try await PostModel.query(on: req.db).filter(\.$id == postId).first()
        else {
            throw Abort(.notFound)
        }
        let input = try req.content.decode(Comment.Create.self)
        guard
            let id = req.auth.get(ApiUser.self)?.id,
            let user = try await UserModel.query(on: req.db).filter(\.$id == id).first()
        else {
            throw Abort(.badRequest)
        }
        
        let model = CommentModel(
            date: Date(),
            content: input.content,
            postId: try post.requireID(),
            userId: try user.requireID()
        )
        try await model.create(on: req.db)
        return .init(
            id: try model.requireID(),
            date: model.date,
            content: model.content,
            postId: model.postId,
            userId: model.userId
        )
    }

    /**
     ```sh
     curl -i -X DELETE http://localhost:8080/posts/IDENTIFIER/comments/IDENTIFIER/ \
         -H "Authorization: Bearer TOKEN" \
     ```
     */
    func delete(req: Request) async throws -> Comment.Detail {
        guard let id = req.auth.get(ApiUser.self)?.id else {
            throw Abort(.unauthorized)
        }
        let model = try await find(req)
        guard model.userId == id else {
            throw Abort(.forbidden)
        }
        model.content = "DELETED"
        try await model.update(on: req.db)
        return .init(
            id: try model.requireID(),
            date: model.date,
            content: model.content,
            postId: model.postId,
            userId: model.userId
        )
    }
}
