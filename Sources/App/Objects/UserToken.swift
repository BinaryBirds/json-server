import Vapor

enum UserToken {

    struct Detail: Content {
        let id: UUID
        let value: String
        let user: User.Detail
    }
    
}
