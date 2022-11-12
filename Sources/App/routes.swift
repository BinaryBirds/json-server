import Fluent
import Vapor

func routes(_ app: Application) throws {

    let apiCollections: [RouteCollection] = [
        TagController(),
        PostController(),
        CommentController(),
        FileController(),
        UserController(),
    ]
    let apiRoutes = app.routes.grouped("api").grouped("v1")
    for collection in apiCollections {
        try apiRoutes.register(collection: collection)
    }
    try app.routes.register(collection: WebController())
}
