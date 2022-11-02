import Fluent
import Vapor

final class UserTokenModel: Model {
    static let schema = "tokens"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: String
    
    @Field(key: "user_id")
    var userId: UUID

    init() { }

    init(id: UUID? = nil, value: String, userId: UUID) {
        self.id = id
        self.value = value
        self.userId = userId
    }
}
