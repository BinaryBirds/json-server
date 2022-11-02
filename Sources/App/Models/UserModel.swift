import Fluent
import Vapor

final class UserModel: Model {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "image_url")
    var imageUrl: String?
    
    @Field(key: "name")
    var name: String?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String

    init() { }

    init(id: UUID? = nil, imageUrl: String?, name: String?, email: String, password: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.name = name
        self.email = email
        self.password = password
    }
}
