import Fluent

struct SchemaMigrations: AsyncMigration {

    func prepare(on database: Database) async throws {

        try await database.schema(UserTokenModel.schema)
            .id()
            .field("value", .string, .required)
            .field("user_id", .uuid, .required)
            .unique(on: "value")
            .create()
        
        try await database.schema(UserModel.schema)
            .id()
            .field("image_url", .string)
            .field("name", .string)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .unique(on: "email")
            .create()
        
        try await database.schema(PostModel.schema)
            .id()
            .field("image_url", .string, .required)
            .field("title", .string, .required)
            .field("excerpt", .string, .required)
            .field("date", .datetime, .required)
            .field("content", .string, .required)
            .create()
        
        try await database.schema(CommentModel.schema)
            .id()
            .field("date", .date, .required)
            .field("content", .string, .required)
            .field("post_id", .uuid, .required)
            .field("user_id", .uuid, .required)
            .create()

        try await database.schema(TagModel.schema)
            .id()
            .field("name", .string, .required)
            .create()
        
        try await database.schema(PostTagsModel.schema)
            .id()
            .field("post_id", .uuid, .required)
            .field("tag_id", .uuid, .required)
            .unique(on: "post_id", "tag_id")
            .create()
    }


    // MARK: - revert
    
    func revert(on database: Database) async throws {
        let schemas = [
            PostTagsModel.schema,
            TagModel.schema,
            CommentModel.schema,
            PostModel.schema,
            UserTokenModel.schema,
            UserModel.schema,
        ]
        for schema in schemas {
            try await database.schema(schema).delete()
        }
        
    }
}
