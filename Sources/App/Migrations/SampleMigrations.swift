import Fluent
import Vapor

struct SampleMigrations: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        let tag1 = TagModel(name: "Red")
        try await tag1.create(on: database)
        
        let tag2 = TagModel(name: "Orange")
        try await tag2.create(on: database)
        
        for i in 0...25 {
            let post = PostModel(
                imageUrl: "https://placekitten.com/640/360",
                title: "Post #\(i + 1)",
                excerpt: "Excerpt #\(i + 1)",
                date: Date().addingTimeInterval(Double(i) * -86_400),
                content: "Content #\(i + 1)"
            )
            try await post.create(on: database)
        }
        
        let post = PostModel(
            imageUrl: "https://placekitten.com/640/360",
            title: "Lorem ipsum",
            excerpt: "Pellentesque sit amet iaculis libero. Duis imperdiet mi quam, at rutrum ex suscipit at. ",
            date: Date(),
            content: """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus aliquam a dui ut vestibulum. Aliquam metus nisl, fermentum nec posuere sit amet, elementum id sem. Proin elementum tortor metus, a finibus purus vehicula non. Morbi aliquam ipsum vestibulum nisi tincidunt finibus. Curabitur egestas pellentesque elit dapibus tincidunt. Mauris ut tortor at turpis sollicitudin sodales. Nulla consectetur magna a pretium lobortis. Ut justo sapien, pellentesque sit amet blandit a, cursus sit amet mauris. In cursus nisl ac blandit convallis.
"""
        )
        try await post.create(on: database)

        let user1 = UserModel(
            imageUrl: "https://placekitten.com/256/256",
            name: "Root User",
            email: "root@localhost.com",
            password: try Bcrypt.hash("ChangeMe1")
        )
        
        let user2 = UserModel(
            imageUrl: "https://placekitten.com/256/256",
            name: "John Doe",
            email: "john@localhost.com",
            password: try Bcrypt.hash("Doe1")
        )
        
        try await user1.create(on: database)
        try await user2.create(on: database)
        
        try await [
            CommentModel(
                date: Date(),
                content: "Cras leo nibh, suscipit eu consectetur quis",
                postId: try post.requireID(),
                userId: try user1.requireID()
            ),
            CommentModel(
                date: Date(),
                content: "Proin facilisis massa risus",
                postId: try post.requireID(),
                userId: try user2.requireID()
            ),
        ].create(on: database)
        
        try await [
            PostTagsModel(
                postId: try post.requireID(),
                tagId: try tag1.requireID()
            ),
            PostTagsModel(
                postId: try post.requireID(),
                tagId: try tag2.requireID()
            ),
        ].create(on: database)
    }
    
    
    // MARK: - revert
    
    func revert(on database: Database) async throws {
        try await PostTagsModel.query(on: database).delete()
        try await TagModel.query(on: database).delete()
        try await CommentModel.query(on: database).delete()
        try await PostModel.query(on: database).delete()
        try await UserTokenModel.query(on: database).delete()
        try await UserModel.query(on: database).delete()
    }
}
