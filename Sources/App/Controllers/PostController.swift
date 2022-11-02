import Fluent
import Vapor

struct PostController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let baseRoutes = routes
            .grouped("posts")

        let safeRoutes = baseRoutes
            .grouped(UserTokenAuthenticator())
            .grouped(ApiUser.guardMiddleware())

        baseRoutes.get(use: list)

        /// NOTE: I know, I should definitely reuse "postId"...
        baseRoutes.grouped(":postId").get(use: detail)

        safeRoutes.post(use: create)
        safeRoutes.group(":postId") { routes in
            routes.put(use: update)
            routes.patch(use: patch)
            routes.delete(use: delete)
        }
    }
    
    // MARK: - helpers
    
    private func find(_ req: Request) async throws -> PostModel {
        guard
            let id = req.parameters.get("postId"),
            let uuid = UUID(uuidString: id),
            let model = try await PostModel.find(uuid, on: req.db)
        else {
            throw Abort(.notFound)
        }
        return model
    }
    
    private func updateTags(_ req: Request, model: PostModel, tagIds: [UUID]?) async throws -> [Tag.List] {
        let id = try model.requireID()
        var tags: [Tag.List] = []
        if let tagIds = tagIds, !tagIds.isEmpty {
            let tagModels = try await TagModel.query(on: req.db).filter(\.$id ~~ tagIds).all()
            tags = try tagModels.map { .init(id: try $0.requireID(), name: $0.name) }

            /// NOTE: this could be optimized...
            try await req.db.transaction { db in
                try await PostTagsModel.query(on: db).filter(\.$postId == id).delete()
                try await tagModels.map { PostTagsModel(postId: id, tagId: try $0.requireID()) }.create(on: db)
            }
        }
        return tags
    }
    
    // MARK: - api functions

    /**
     ```sh
     curl -X GET http://localhost:8080/posts \
         -H "Accept: application/json" \
         |json
     ```
     */
    func list(req: Request) async throws -> Page<Post.List> {
        
        // tagIds[]=UUID&tagIds[]=UUID
        var postIds: [UUID] = []
        if let tagIds = try? req.query.get([UUID].self, at: "tagIds"), !tagIds.isEmpty {
            postIds = try await PostTagsModel.query(on: req.db).filter(\.$tagId ~~ tagIds).all().map(\.postId)
        }
        
        var queryBuilder = PostModel.query(on: req.db)
        if !postIds.isEmpty {
           queryBuilder = queryBuilder.filter(\.$id ~~ postIds)
        }
        
        // search=lorem
        if let search = try? req.query.get(String.self, at: "search"), !search.isEmpty {
            queryBuilder = queryBuilder.group(.or) {
                $0.filter(\.$title ~~ search)
                $0.filter(\.$excerpt ~~ search)
            }
        }
        
        // from=2022-10-28T20:05:51Z
        if
            let rawFrom = try? req.query.get(String.self, at: "from"),
            let from = ISO8601DateFormatter().date(from: rawFrom)
        {
            queryBuilder = queryBuilder.filter(\.$date >= from)
        }

        // to=2022-10-29T20:05:51Z
        if
            let rawTo = try? req.query.get(String.self, at: "to"),
            let to = ISO8601DateFormatter().date(from: rawTo)
        {
            queryBuilder = queryBuilder.filter(\.$date <= to)
        }

        return try await queryBuilder.paginate(for: req).map {
            .init(
                id: try $0.requireID(),
                imageUrl: $0.imageUrl,
                title: $0.title,
                excerpt: $0.excerpt,
                date: $0.date
            )
        }
    }

    /**
     ```sh
     curl -X GET http://localhost:8080/posts \
         -H "Accept: application/json" \
         |json
     ```
     */
    func detail(req: Request) async throws -> Post.Detail {
        let model = try await find(req)
        let id = try model.requireID()
        let tagIds = try await PostTagsModel.query(on: req.db).filter(\.$postId == id).all().map(\.tagId)
        let tags = try await TagModel.query(on: req.db).filter(\.$id ~~ tagIds).all()
        
        return .init(
            id: id,
            imageUrl: model.imageUrl,
            title: model.title,
            excerpt: model.excerpt,
            date: model.date,
            content: model.content,
            tags: try tags.map { .init(id: try $0.requireID(), name: $0.name) }
        )
    }

    /**
     ```sh
     curl -X POST http://localhost:8080/posts \
         -H "Authorization: Bearer TOKEN" \
         -H "Content-Type: application/json" \
         -H "Accept: application/json" \
         --data-raw '
         {
             "imageUrl": "https://placekitten.com/640/360",
             "title": "Lorem ipsum",
             "excerpt": "Lorem ipsum",
             "date": "2022-10-27T20:05:51Z",
             "content": "Lorem ipsum dolor sit amet",
             "tagIds": []
         }
         '|json
     ```
     */
    func create(req: Request) async throws -> Post.Detail {
        let input = try req.content.decode(Post.Create.self)
        let model = PostModel(
            imageUrl: input.imageUrl,
            title: input.title,
            excerpt: input.excerpt,
            date: input.date,
            content: input.content
        )
        
        try await model.create(on: req.db)
        let tags = try await updateTags(req, model: model, tagIds: input.tagIds)

        return .init(
            id: try model.requireID(),
            imageUrl: model.imageUrl,
            title: model.title,
            excerpt: model.excerpt,
            date: model.date,
            content: model.content,
            tags: tags
        )
    }

    /**
     ```sh
     curl -X PUT http://localhost:8080/posts/IDENTIFIER/ \
         -H "Authorization: Bearer TOKEN" \
         -H "Content-Type: application/json" \
         -H "Accept: application/json" \
         --data-raw '
         {
             "imageUrl": "https://placekitten.com/640/360",
             "title": "Lorem ipsum",
             "excerpt": "Lorem ipsum",
             "date": "2022-10-27T20:05:51Z",
             "content": "Lorem ipsum dolor sit amet",
             "tagIds": []
         }
         '|json
     ```
     */
    func update(req: Request) async throws -> Post.Detail {
        let model = try await find(req)
        let input = try req.content.decode(Post.Update.self)
        model.imageUrl = input.imageUrl
        model.title = input.title
        model.excerpt = input.excerpt
        model.date = input.date
        model.content = input.content
        
        try await model.update(on: req.db)
        let tags = try await updateTags(req, model: model, tagIds: input.tagIds)

        return .init(
            id: try model.requireID(),
            imageUrl: model.imageUrl,
            title: model.title,
            excerpt: model.excerpt,
            date: model.date,
            content: model.content,
            tags: tags
        )
    }
    
    /**
     ```sh
     curl -X PATCH http://localhost:8080/posts/IDENTIFIER/ \
         -H "Authorization: Bearer TOKEN" \
         -H "Content-Type: application/json" \
         -H "Accept: application/json" \
         --data-raw '
         {
             "imageUrl": "https://placekitten.com/640/360",
             "title": "Lorem ipsum",
             "excerpt": "Lorem ipsum",
             "date": "2022-10-27T20:05:51Z",
             "content": "Lorem ipsum dolor sit amet",
             "tagIds": []
         }
         '|json
     ```
     */
    func patch(req: Request) async throws -> Post.Detail {
        let model = try await find(req)
        let input = try req.content.decode(Post.Patch.self)
        model.imageUrl = input.imageUrl ?? model.imageUrl
        model.title = input.title ?? model.title
        model.excerpt = input.excerpt ?? model.excerpt
        model.date = input.date ?? model.date
        model.content = input.content ?? model.content
        
        try await model.update(on: req.db)
        let tags = try await updateTags(req, model: model, tagIds: input.tagIds)

        return .init(
            id: try model.requireID(),
            imageUrl: model.imageUrl,
            title: model.title,
            excerpt: model.excerpt,
            date: model.date,
            content: model.content,
            tags: tags
        )
    }

    /**
     ```sh
     curl -i -X DELETE http://localhost:8080/posts/IDENTIFIER/ \
         -H "Authorization: Bearer TOKEN"
     ```
     */
    func delete(req: Request) async throws -> HTTPStatus {
        let model = try await find(req)
        let id = try model.requireID()

        try await req.db.transaction { db in
            try await CommentModel.query(on: db).filter(\.$postId == id).delete()
            try await PostTagsModel.query(on: db).filter(\.$postId == id).delete()
            try await model.delete(on: db)
        }
        return .noContent
    }
}
