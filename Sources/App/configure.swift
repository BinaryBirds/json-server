import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {

    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [
            .accept,
            .authorization,
            .contentType,
            .origin,
            .xRequestedWith,
            .userAgent,
            .accessControlAllowOrigin
        ]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    app.middleware.use(cors, at: .beginning)
    
    app.middleware.use(SleepMiddleware())
    app.middleware.use(ChaosMiddleware())
    

    // serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // setup database
    if app.environment == .testing {
        app.databases.use(.sqlite(.memory), as: .sqlite)
        app.logger.logLevel = .error
    }
    else {
        app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    }

    app.migrations.add(SchemaMigrations())
    app.migrations.add(SampleMigrations())
    try app.autoMigrate().wait()
    
    // setup routes
    try routes(app)
}
