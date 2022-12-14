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
                    .contentTypeBody,
                    .accept,
                ],
                body: [
                    .userLoginRequest,
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
                    .ok,
                    .init(value: .unauthorized, info: "Indicates a failed login attempt."),
                ],
                headers: [
                    .contentTypeResponse,
                ],
                body: [
                    .token,
                    .user,
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
                    .authorization,
                    .accept,
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
                    .ok,
                    .unauthorized,
                ],
                headers: [
                    .contentTypeResponse,
                ],
                body: [
                    .user,
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
        
        Endpoint(
            name: "Update user",
            method: .put,
            path: "/user/me/",
            info: "Update user profile details",
            request: .init(
                queryParams: [
                ],
                headers: [
                    .authorization,
                    .accept,
                ],
                body: [
                    .userInput(),
                ],
                example: ###"""
                curl -X PUT http://localhost:8080/api/v1/user/me/ \
                     -H "Authorization: Bearer [TOKEN]" \
                     -H "Content-Type: application/json" \
                     -H "Accept: application/json" \
                     --data-raw '
                     {
                         "imageUrl": "https://placekitten.com/256/256",
                         "name": "John Doe",
                         "email": "root@localhost.com",
                         "password": "ChangeMe1"
                     }
                     '
                """###
            ),
            response: .init(
                statusCodes: [
                    .ok,
                    .badRequest,
                    .unauthorized,
                ],
                headers: [
                    .contentTypeResponse,
                ],
                body: [
                    .user,
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
        
        Endpoint(
            name: "Patch user",
            method: .patch,
            path: "/user/me/",
            info: "Patch user profile details",
            request: .init(
                queryParams: [
                ],
                headers: [
                    .authorization,
                    .accept,
                ],
                body: [
                    .userInput(isPatch: true),
                ],
                example: ###"""
                curl -X PATCH http://localhost:8080/api/v1/user/me/ \
                     -H "Authorization: Bearer [TOKEN]" \
                     -H "Content-Type: application/json" \
                     -H "Accept: application/json" \
                     --data-raw '
                     {
                         "imageUrl": "https://placekitten.com/256/256",
                         "name": "John Doe",
                         "email": "root@localhost.com",
                         "password": "ChangeMe1"
                     }
                     '
                """###
            ),
            response: .init(
                statusCodes: [
                    .ok,
                    .badRequest,
                    .unauthorized,
                ],
                headers: [
                    .contentTypeResponse,
                ],
                body: [
                    .user,
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

    }
}
