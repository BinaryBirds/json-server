import Vapor

struct SleepMiddleware: AsyncMiddleware {

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let seconds = try? req.query.get(Int.self, at: "sleep"), seconds >= 1, seconds <= 360 else {
            return try await next.respond(to: req)
        }
        try await Task.sleep(nanoseconds: 1_000_000_000 * UInt64(seconds))
        return try await next.respond(to: req)
    }
}
