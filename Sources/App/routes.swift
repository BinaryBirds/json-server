import Fluent
import Vapor

func routes(_ app: Application) throws {

    app.get { req async in
        "It works!"
    }

    try app.register(collection: TagController())
    try app.register(collection: PostController())
    try app.register(collection: CommentController())
    try app.register(collection: UserController())
    try app.register(collection: FileController())
}
