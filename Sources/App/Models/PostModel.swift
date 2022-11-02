import Fluent
import Vapor

final class PostModel: Model {
    static let schema = "posts"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "image_url")
    var imageUrl: String
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "excerpt")
    var excerpt: String
    
    @Field(key: "date")
    var date: Date
    
    @Field(key: "content")
    var content: String

    init() { }

    init(id: UUID? = nil, imageUrl: String, title: String, excerpt: String, date: Date, content: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.title = title
        self.excerpt = excerpt
        self.date = date
        self.content = content
    }
}

