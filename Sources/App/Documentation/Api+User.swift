//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 12..
//

import Foundation

extension Endpoint {
        
    @EndpointBuilder
    static var userEndpoints: [Endpoint] {
        Endpoint(
            name: "User login",
            method: .post,
            path: "/user/login/",
            info: "Log in with a given user account credentials (email, password).",
            request: .init(
                queryParams: [
                    
                ],
                headers: [
                    .init(
                        key: "Content-Type",
                        value: "application/json",
                        info: "Standard content type header to indicate request body type.",
                        isRequired: true
                    ),
                    .init(
                        key: "Accept",
                        value: "application/json",
                        info: "Standard accept header to indicate that we only accept a JSON response.",
                        isRequired: false
                    ),
                ],
                body: [
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
                    ),
                ],
                example: ###"""
                curl -X POST http://localhost:8080/api/v1/user/login/ \
                    -H "Content-Type: application/json" \
                    -H "Accept: application/json" \
                    --data-raw '
                    {
                        "email": "root@localhost.com",
                        "password": "ChangeMe1"
                    }
                    '
                """###
            ),
            response: .init(
                statusCodes: [
                    .init(value: .ok, info: "Indicates a successful login attempt."),
                    .init(value: .unauthorized, info: "Indicates a failed login attempt."),
                ],
                headers: [
                    .init(
                        key: "Content-Type",
                        value: "application/json",
                        info: "Indicates that the response is a JSON object.",
                        isRequired: true
                    ),
                ],
                body: [
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
                    ),
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
                    ),
                ],
                example: ###"""
                {
                    "id": "A9B52FF1-6E40-4C7B-BA9E-45AE30A88178",
                    "value": "WtjGPbMXgtO1ny5Q3TWbtmFpKQN5FrJTcriaIOsPnB9VVq8P7RPsZbUj92HeW6En",
                    "user": {
                        "id": "73FDE1C3-089A-480E-A99A-1C67E030FC87",
                        "email": "root@localhost.com",
                        "name": "Root User",
                        "imageUrl": "https://placekitten.com/256/256"
                    }
                }
                """###
            )
        )
        
        // MARK: -
        
        Endpoint(
            name: "Get user profile details",
            method: .get,
            path: "/user/me/",
            info: "Show currently logged in user profile details",
            request: .init(
                queryParams: [
                ],
                headers: [
                    .init(
                        key: "Authorization",
                        value: "Bearer [TOKEN]",
                        info: "You have to provide a Bearer token using this header field to access this endpoint.",
                        isRequired: true
                    ),
                    .init(
                        key: "Accept",
                        value: "application/json",
                        info: "Standard accept header to indicate that we only accept a JSON response.",
                        isRequired: false
                    ),
                ],
                body: [
                ],
                example: ###"""
                curl -X GET http://localhost:8080/api/v1/user/me \
                     -H "Authorization: Bearer [TOKEN]" \
                     -H "Accept: application/json"
                """###
            ),
            response: .init(
                statusCodes: [
                    .init(value: .ok, info: "Indicates a successful response."),
                    .init(value: .unauthorized, info: "Indicates an unauthorized request attempt."),
                ],
                headers: [
                    .init(key: "Content Type", value: "application/json", info: "JSON", isRequired: true),
                ],
                body: [
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
                    ),
                ],
                example: ###"""
                {
                    "id": "73FDE1C3-089A-480E-A99A-1C67E030FC87",
                    "email": "root@localhost.com",
                    "name": "Root User",
                    "imageUrl": "https://placekitten.com/256/256"
                }
                """###
            )
        )
        
        // MARK: -
        
        
        
        
        
    }
}
