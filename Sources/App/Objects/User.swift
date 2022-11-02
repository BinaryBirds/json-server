import Vapor

enum User {

    struct Login: Content {
        let email: String
        let password: String
    }

    struct List: Content {
        let id: UUID
        let imageUrl: String?
        let name: String?
        let email: String
    }
    
    struct Detail: Content {
        let id: UUID
        let imageUrl: String?
        let name: String?
        let email: String
    }
    
    struct Create: Content {
        let imageUrl: String?
        let name: String?
        let email: String
        let password: String
    }
    
    struct Update: Content {
        let imageUrl: String?
        let name: String?
        let email: String
        let password: String
    }
    
    struct Patch: Content {

        let imageUrl: String?
        let name: String?
        let email: String?
        let password: String?

        init(
            imageUrl: String? = nil,
            name: String? = nil,
            email: String? = nil,
            password: String? = nil
        ) {
            self.imageUrl = imageUrl
            self.name = name
            self.email = email
            self.password = password
        }
    }
}
