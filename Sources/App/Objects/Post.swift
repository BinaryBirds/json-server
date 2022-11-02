import Vapor

enum Post {

    struct List: Content {
        let id: UUID
        let imageUrl: String
        let title: String
        let excerpt: String
        let date: Date
    }
    
    struct Detail: Content {
        let id: UUID
        let imageUrl: String
        let title: String
        let excerpt: String
        let date: Date
        let content: String
        let tags: [Tag.List]
    }
    
    struct Create: Content {
        let imageUrl: String
        let title: String
        let excerpt: String
        let date: Date
        let content: String
        let tagIds: [UUID]?
    }
    
    struct Update: Content {
        let imageUrl: String
        let title: String
        let excerpt: String
        let date: Date
        let content: String
        let tagIds: [UUID]?
    }
    
    struct Patch: Content {
                
        let imageUrl: String?
        let title: String?
        let excerpt: String?
        let date: Date?
        let content: String?
        let tagIds: [UUID]?
        
        init(
            imageUrl: String? = nil,
            title: String? = nil,
            excerpt: String? = nil,
            date: Date? = nil,
            content: String? = nil,
            tagIds: [UUID]? = nil
        ) {
            self.imageUrl = imageUrl
            self.title = title
            self.excerpt = excerpt
            self.date = date
            self.content = content
            self.tagIds = tagIds
        }

    }
}
