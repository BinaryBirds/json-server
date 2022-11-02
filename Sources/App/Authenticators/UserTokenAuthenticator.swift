//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 10. 27..
//

import Vapor
import Fluent

struct UserTokenAuthenticator: AsyncBearerAuthenticator {

    func authenticate(bearer: BearerAuthorization, for req: Request) async throws {
        guard
            let token = try await UserTokenModel.query(on: req.db).filter(\.$value == bearer.token).first(),
            let user = try await UserModel.query(on: req.db).filter(\.$id == token.userId).first()
        else {
            return
        }
        req.auth.login(ApiUser(id: try user.requireID()))
    }
}
