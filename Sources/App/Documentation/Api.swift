//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 12..
//

import Foundation

extension Endpoint {
    
    @EndpointBuilder
    static var api: [Endpoint] {
        Endpoint(
            method: .post,
            path: "/user/login/",
            info: "Log in with a given account",
            request: .init(
                queryParams: [
                    .init(name: "foo", type: .string, isRequired: true, info: "foo info")
                ],
                headers: [
                    .init(key: "Content Type", value: "application/json", info: "JSON", isRequired: true),
                ],
                body: [
                    .init(name: "UserLoginRequest", info: "request object", parameters: [
                        .init(name: "email", type: .string, isRequired: true, info: "Email address"),
                        .init(name: "password", type: .string, isRequired: true, info: "Login password"),
                    ]),
                ],
                example: ###"""
                curl -X POST http://localhost:8080/user/login \
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
                    .init(value: .ok, info: "Succesful log in"),
                    .init(value: .movedPermanently, info: "Moved"),
                    .init(value: .notFound, info: "Not found"),
                    .init(value: .internalServerError, info: "ERRROR"),
                ],
                headers: [
                    .init(key: "Content Type", value: "application/json", info: "JSON", isRequired: true),
                ],
                body: [
                    .init(name: "UserLoginResponse", info: "response object", parameters: [
                        .init(name: "id", type: .uuid, isRequired: true, info: "User identifier"),
                        .init(name: "name", type: .string, isRequired: true, info: "User name"),
                        .init(name: "user", type: .string, isRequired: true, info: "User"),
                    ]),
                    .init(name: "User", info: "user object", parameters: [
                        .init(name: "id", type: .uuid, isRequired: true, info: "User identifier"),
                        .init(name: "name", type: .string, isRequired: true, info: "User name"),
                    ]),
                ],
                example: ###"""
                {
                    "id": "A9B52FF1-6E40-4C7B-BA9E-45AE30A88178",
                    "value": "WtjGPbMXgtO1ny5Q3TWbtmFpKQN5FrJTcriaIOsPnB9VVq8P7RPsZbUj92HeW6En",
                    "user": {
                        "email": "root@localhost.com",
                        "id": "73FDE1C3-089A-480E-A99A-1C67E030FC87",
                        "imageUrl": "https://placekitten.com/256/256",
                        "name": "Root User"
                    }
                }
                """###
            )
        )
        
        // MARK: -
        
        
        
        
        
        
        
    }
}
