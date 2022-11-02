import Vapor

enum Tag {

    struct List: Content {
        let id: UUID
        let name: String
    }
    
    struct Detail: Content {
        let id: UUID
        let name: String
    }
    
    struct Create: Content {
        let name: String
    }
    
    struct Update: Content {
        let name: String
    }
    
    struct Patch: Content {
        let name: String?
    }
}
