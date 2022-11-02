import Fluent
import Vapor

final class PostTagsModel: Model {
    static let schema = "post_tags"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "post_id")
    var postId: UUID
    
    @Field(key: "tag_id")
    var tagId: UUID

    init() { }

    init(id: UUID? = nil, postId: UUID, tagId: UUID) {
        self.id = id
        self.postId = postId
        self.tagId = tagId
    }
}
