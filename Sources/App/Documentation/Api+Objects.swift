//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 15..
//

import Foundation

extension Endpoint.Object {
    
    static var userLoginRequest: Endpoint.Object {
        .init(
            name: "UserLoginRequest",
            info: "A simple JSON object with an email and password values.",
            parameters: [
                .init(
                    name: "email",
                    type: .string,
                    isRequired: true,
                    info: "Valid email address of the user account."
                ),
                .init(
                    name: "password",
                    type: .string,
                    isRequired: true,
                    info: "Login password for the given user account."
                ),
            ]
        )
    }

    static var token: Endpoint.Object {
        .init(
            name: "UserLoginResponse",
            info: "The response object, containing the authorization token value.",
            parameters: [
                .init(
                    name: "id",
                    type: .uuid,
                    isRequired: true,
                    info: "Unique identifier of the authorization token."),
                .init(
                    name: "value",
                    type: .string,
                    isRequired: true,
                    info: "The authorization token, this sould be used as a Bearer value."),
                .init(
                    name: "user",
                    type: .object,
                    isRequired: true,
                    info: "Detailed information about the user account."),
            ]
        )
    }

    static var user: Endpoint.Object {
        .init(
            name: "User",
            info: "The user account detail object.",
            parameters: [
                .init(
                    name: "id",
                    type: .uuid,
                    isRequired: true,
                    info: "Unique user identifier."
                ),
                .init(
                    name: "email",
                    type: .string,
                    isRequired: true,
                    info: "Email address of the user account."
                ),
                .init(
                    name: "name",
                    type: .string,
                    isRequired: false,
                    info: "Name of the user."
                ),
                .init(
                    name: "imageUrl",
                    type: .string,
                    isRequired: false,
                    info: "Profile picture URL for the given user account."
                ),
            ]
        )
    }
}
