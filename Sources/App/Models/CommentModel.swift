import Fluent
import Vapor

final class CommentModel: Model {

    static let schema = "comments"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "date")
    var date: Date
    
    @Field(key: "content")
    var content: String

    @Field(key: "post_id")
    var postId: UUID
    
    @Field(key: "user_id")
    var userId: UUID

    init() { }

    init(id: UUID? = nil, date: Date, content: String, postId: UUID, userId: UUID) {
        self.id = id
        self.date = date
        self.content = content
        self.postId = postId
        self.userId = userId
    }
}
