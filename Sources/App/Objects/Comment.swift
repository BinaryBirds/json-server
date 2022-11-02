import Vapor

enum Comment {

    struct List: Content {
        let id: UUID
        let date: Date
        let content: String
        let user: User.List
    }
    
    struct Detail: Content {
        let id: UUID
        let date: Date
        let content: String
        let postId: UUID
        let userId: UUID
    }
    
    struct Create: Content {
        let content: String
    }
    
    struct Update: Content {
        let content: String
    }
    
    struct Patch: Content {
        let content: String?
    }
}
