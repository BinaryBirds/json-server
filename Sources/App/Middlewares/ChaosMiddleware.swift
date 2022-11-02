import Vapor

fileprivate extension String {

    static func generateContent(_ words: Int = 64) -> String {
        (0...words).map { _ in String.generateToken(.random(in: 3...10)) }.joined(separator: " ")
    }
}

struct ChaosMiddleware: AsyncMiddleware {

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let _ = try? req.query.get(String.self, at: "chaos") else {
            return try await next.respond(to: req)
        }
        // we might return the original response... or not, small chance... :)
        if Int.random(in: 1...10) < 2 {
            return try await next.respond(to: req)
        }
        
        // shake up things with a random response code...
        let codes = [
            100, 101, 102, 200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302, 303, 304, 305, 307, 308, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 421, 422, 423, 424, 426, 428, 429, 431, 451, 500, 501, 502, 503, 504, 505, 506, 507, 508, 510, 511,
        ]
        let statusCode = HTTPResponseStatus.init(statusCode: codes.randomElement()!)
        
        let contentTypes = [
            "application/json",
            "application/zip",
            "text/css",
            "text/html",
            "text/plain",
            "image/png",
            "image/jpeg",
        ]

        var headers = HTTPHeaders()
        headers.replaceOrAdd(name: "Content-Type", value: "\(contentTypes.randomElement()!); charset=utf-8")

        enum RandomBodies: CaseIterable {
            case emoji
            case string
            case int
            case double
            case boolean
            case dictionary
            case array
            case original
            case empty
        }
        
        // random values
        let i = Int.random(in: Int.min...Int.max)
        let d = Double.random(in: -1...1)
        let b = Bool.random()
        let s = String.generateToken(Int.random(in: 1...32))

        let body: Response.Body
        switch RandomBodies.allCases.randomElement()! {
        case .emoji:
            body = .init(string: ["😅", "🙈", "😈", "🖤", "🤘"].randomElement()!)
        case .string:
            body = .init(string: .generateContent(Int.random(in: 1...64)))
        case .int:
            body = .init(string: "\(i)")
        case .double:
            body = .init(string: "\(d)")
        case .boolean:
            body = .init(string: "\(b)")
        case .dictionary:
            let k1 = String.generateToken(Int.random(in: 1...32))
            let k2 = String.generateToken(Int.random(in: 1...32))
            let k3 = String.generateToken(Int.random(in: 1...32))
            let k4 = String.generateToken(Int.random(in: 1...32))
            body = .init(string: "[\"\(k1)\": \(i), \"\(k2)\": \(b), \"\(k3)\": \(s), \"\(k4)\": \(d)")
        case .array:
            body = .init(string: "[\(i), \(b), \"\(s)\", \(d)]")
        case .original:
            body = try await next.respond(to: req).body
        case .empty:
            body = .empty
        }

        return .init(status: statusCode,
                     version: req.version,
                     headers: headers,
                     body: body)
    }
}

