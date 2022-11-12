import Fluent
import Vapor
import SwiftHtml

struct WebController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        
        routes.get(use: main)
    }

    func main(req: Request) async throws -> Response {
        let root = IndexTemplate.build(Endpoint.api)
        let doc = Document(.html) { root }
        let html = DocumentRenderer(minify: true).render(doc)
        return .init(
            status: .ok,
            headers: [
                "content-type": "text/html",
            ],
            body: .init(string: html)
        )
    }
}
