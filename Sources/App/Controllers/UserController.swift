import Fluent
import Vapor

struct UserController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let baseRoutes = routes.grouped("user")

        baseRoutes
            .grouped(UserCredentialsAuthenticator())
            .grouped("login")
            .post(use: login)
        
        let profileRoutes = baseRoutes
            .grouped(UserTokenAuthenticator())
            .grouped(ApiUser.guardMiddleware())
            .grouped("me")

        profileRoutes.get(use: me)
        profileRoutes.patch(use: patch)
        profileRoutes.put(use: update)
    }

    // MARK: - api functions
    
    /**
     ```sh
     curl -X POST http://localhost:8080/user/login \
         -H "Content-Type: application/json" \
         -H "Accept: application/json" \
         --data-raw '
         {
             "email": "root@localhost.com",
             "password": "ChangeMe1"
         }
         '|jq
     ```
     */
    func login(req: Request) async throws -> UserToken.Detail {
        guard
            let id = req.auth.get(ApiUser.self)?.id,
            let user = try await UserModel.query(on: req.db).filter(\.$id == id).first()
        else {
            throw Abort(.unauthorized)
        }
        let token = UserTokenModel(value: .generateToken(), userId: try user.requireID())
        try await token.create(on: req.db)

        return .init(
            id: try token.requireID(),
            value: token.value,
            user: .init(
                id: try user.requireID(),
                imageUrl: user.imageUrl,
                name: user.name,
                email: user.email
            )
        )
    }
    
    /**
     ```sh
     curl -X GET http://localhost:8080/user/me \
         -H "Authorization: Bearer TOKEN" \
         -H "Accept: application/json" \
         |jq
     ```
     */
    func me(req: Request) async throws -> User.Detail {
        guard
            let id = req.auth.get(ApiUser.self)?.id,
            let model = try await UserModel.query(on: req.db).filter(\.$id == id).first()
        else {
            throw Abort(.unauthorized)
        }
        return .init(
            id: try model.requireID(),
            imageUrl: model.imageUrl,
            name: model.name,
            email: model.email
        )
    }
    
    /**
     ```sh
     curl -X PUT http://localhost:8080/user/me \
         -H "Authorization: Bearer TOKEN" \
         -H "Content-Type: application/json" \
         -H "Accept: application/json" \
         --data-raw '
         {
             "imageUrl": "https://placekitten.com/256/256",
             "name": "John Doe",
             "email": "root@localhost.com",
             "password": "ChangeMe1"
         }
         '|jq
     ```
     */
    func update(req: Request) async throws -> User.Detail {
        guard
            let id = req.auth.get(ApiUser.self)?.id,
            let model = try await UserModel.query(on: req.db).filter(\.$id == id).first()
        else {
            throw Abort(.unauthorized)
        }
        let input = try req.content.decode(User.Update.self)
        
        model.imageUrl = input.imageUrl
        model.name = input.name
        model.email = input.email
        model.password = try Bcrypt.hash(input.password)

        try await model.update(on: req.db)
        
        return .init(
            id: try model.requireID(),
            imageUrl: model.imageUrl,
            name: model.name,
            email: model.email
        )
    }
    
    /**
     ```sh
     curl -X PATCH http://localhost:8080/user/me \
         -H "Authorization: Bearer TOKEN" \
         -H "Content-Type: application/json" \
         -H "Accept: application/json" \
         --data-raw '
         {
             "imageUrl": "https://placekitten.com/256/256",
             "name": "John Doe",
             "email": "root@localhost.com",
             "password": "ChangeMe1"
         }
         '|jq
     ```
     */
    func patch(req: Request) async throws -> User.Detail {
        guard
            let id = req.auth.get(ApiUser.self)?.id,
            let model = try await UserModel.query(on: req.db).filter(\.$id == id).first()
        else {
            throw Abort(.unauthorized)
        }
        let input = try req.content.decode(User.Patch.self)
        
        model.imageUrl = input.imageUrl ?? model.imageUrl
        model.name = input.name ?? model.name
        model.email = input.email ?? model.email
        if let password = input.password {
            model.password = try Bcrypt.hash(password)
        }

        try await model.update(on: req.db)
        
        return .init(
            id: try model.requireID(),
            imageUrl: model.imageUrl,
            name: model.name,
            email: model.email
        )
    }
}
