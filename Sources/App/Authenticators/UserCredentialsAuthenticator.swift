//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 10. 27..
//

import Fluent
import Vapor

struct UserCredentialsAuthenticator: AsyncCredentialsAuthenticator {

    typealias Credentials = User.Login

    func authenticate(credentials: Credentials, for req: Request) async throws {
        guard
            let user = try await UserModel.query(on: req.db).filter(\.$email == credentials.email).first(),
            try Bcrypt.verify(credentials.password, created: user.password)
        else {
            return
        }
        req.auth.login(ApiUser(id: try user.requireID()))
    }
}
