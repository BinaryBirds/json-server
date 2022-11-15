//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 12..
//

import Foundation

extension Endpoint {
    
    @EndpointBuilder
    static var postEndpoints: [Endpoint] {
        Endpoint(
            name: "List posts",
            method: .get,
            path: "/posts/",
            info: "List all the available posts and optionally filter them.",
            request: .init(
                queryParams: [
                    .init(
                        name: "tagIds",
                        type: .array,
                        isRequired: false,
                        info: "Array of tag identifiers. (e.g. ?tagIds[]=UUID1&tagIds[]=UUID2)"
                    ),
                    .init(
                        name: "search",
                        type: .string,
                        isRequired: false,
                        info: "Search string that uses the post title and excerpt to look up posts."
                    ),
                    .init(
                        name: "from",
                        type: .string,
                        isRequired: false,
                        info: "Lists post from a given start date. (e.g. ?from=2022-10-28T20:05:51Z)"
                    ),
                    .init(
                        name: "to",
                        type: .string,
                        isRequired: false,
                        info: "Lists post until a given end date.  (e.g. ?to=2022-10-29T20:05:51Z)"
                    ),
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
                        isRequired: true
                    ),
                ],
                body: [
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
                    .init(value: .ok, info: "Succesful log in"),
                    .init(value: .movedPermanently, info: "Moved"),
                    .init(value: .notFound, info: "Not found"),
                    .init(value: .internalServerError, info: "ERRROR"),
                ],
                headers: [
                    .init(key: "Content-Type", value: "application/json", info: "JSON", isRequired: false),
                    .init(key: "Accept", value: "application/json", info: "JSON", isRequired: false),
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
        
        Endpoint(
            name: "Get post details",
            method: .get,
            path: "/posts/[id]",
            info: "Get the details of a single post object using an identifier.",
            request: .init(
                queryParams: [
                    
                ],
                headers: [
                    .init(key: "Content-Type", value: "application/json", info: "JSON", isRequired: false),
                    .init(key: "Accept", value: "application/json", info: "JSON", isRequired: false),
                ],
                body: [
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
                    .init(value: .ok, info: "Succesful log in"),
                    .init(value: .movedPermanently, info: "Moved"),
                    .init(value: .notFound, info: "Not found"),
                    .init(value: .internalServerError, info: "ERRROR"),
                ],
                headers: [
                    .init(key: "Content-Type", value: "application/json", info: "JSON", isRequired: false),
                ],
                body: [
                    .init(name: "UserLoginResponse", info: "response object", parameters: [
                        .init(name: "id", type: .uuid, isRequired: true, info: "User identifier"),
                        .init(name: "name", type: .string, isRequired: true, info: "User name"),
                        .init(name: "user", type: .object, isRequired: true, info: "User"),
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
        
        Endpoint(
            name: "Create a new post",
            method: .post,
            path: "/posts/[id]",
            info: "Create a new post",
            request: .init(
                queryParams: [
                    .init(name: "foo", type: .string, isRequired: true, info: "foo info")
                ],
                headers: [
                    .init(key: "Authorization", value: "Bearer [TOKEN]", info: "Bearer token", isRequired: true),
                    .init(key: "Content-Type", value: "application/json", info: "JSON", isRequired: false),
                    .init(key: "Accept", value: "application/json", info: "JSON", isRequired: false),
                ],
                body: [
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
                    .init(value: .ok, info: "Succesful log in"),
                    .init(value: .movedPermanently, info: "Moved"),
                    .init(value: .notFound, info: "Not found"),
                    .init(value: .internalServerError, info: "ERRROR"),
                ],
                headers: [
                    .init(key: "Authorization", value: "Bearer [TOKEN]", info: "Bearer token", isRequired: true),
                    .init(key: "Content-Type", value: "application/json", info: "JSON", isRequired: false),
                    .init(key: "Accept", value: "application/json", info: "JSON", isRequired: false),
                ],
                body: [
                    .init(name: "UserLoginResponse", info: "response object", parameters: [
                        .init(name: "id", type: .uuid, isRequired: true, info: "User identifier"),
                        .init(name: "name", type: .string, isRequired: true, info: "User name"),
                        .init(name: "user", type: .object, isRequired: true, info: "User"),
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
        
        Endpoint(
            name: "Update post",
            method: .put,
            path: "/post/[id]",
            info: "List all the available posts",
            request: .init(
                queryParams: [
                    .init(name: "foo", type: .string, isRequired: true, info: "foo info")
                ],
                headers: [
                    .init(key: "Authorization", value: "Bearer [TOKEN]", info: "Bearer token", isRequired: true),
                    .init(key: "Content-Type", value: "application/json", info: "JSON", isRequired: false),
                    .init(key: "Accept", value: "application/json", info: "JSON", isRequired: false),
                ],
                body: [
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
                    .init(value: .ok, info: "Succesful log in"),
                    .init(value: .movedPermanently, info: "Moved"),
                    .init(value: .notFound, info: "Not found"),
                    .init(value: .internalServerError, info: "ERRROR"),
                ],
                headers: [
                    .init(key: "Content-Type", value: "application/json", info: "JSON", isRequired: false),
                ],
                body: [
                    .init(name: "UserLoginResponse", info: "response object", parameters: [
                        .init(name: "id", type: .uuid, isRequired: true, info: "User identifier"),
                        .init(name: "name", type: .string, isRequired: true, info: "User name"),
                        .init(name: "user", type: .object, isRequired: true, info: "User"),
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
        
        Endpoint(
            name: "Patch post",
            method: .patch,
            path: "/post/[id]",
            info: "List all the available posts",
            request: .init(
                queryParams: [
                    .init(name: "foo", type: .string, isRequired: true, info: "foo info")
                ],
                headers: [
                    .init(key: "Authorization", value: "Bearer [TOKEN]", info: "Bearer token", isRequired: true),
                    .init(key: "Content-Type", value: "application/json", info: "JSON", isRequired: false),
                    .init(key: "Accept", value: "application/json", info: "JSON", isRequired: false),
                ],
                body: [
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
                    .init(value: .ok, info: "Succesful log in"),
                    .init(value: .movedPermanently, info: "Moved"),
                    .init(value: .notFound, info: "Not found"),
                    .init(value: .internalServerError, info: "ERRROR"),
                ],
                headers: [
                    .init(key: "Content-Type", value: "application/json", info: "JSON", isRequired: false),
                ],
                body: [
                    .init(name: "UserLoginResponse", info: "response object", parameters: [
                        .init(name: "id", type: .uuid, isRequired: true, info: "User identifier"),
                        .init(name: "name", type: .string, isRequired: true, info: "User name"),
                        .init(name: "user", type: .object, isRequired: true, info: "User"),
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
        
        Endpoint(
            name: "Delete post",
            method: .delete,
            path: "/posts/[id]",
            info: "List all the available posts",
            request: .init(
                queryParams: [
                    .init(name: "foo", type: .string, isRequired: true, info: "foo info")
                ],
                headers: [
                    .init(key: "Authorization", value: "Bearer [TOKEN]", info: "Bearer token", isRequired: true),
                    .init(key: "Content-Type", value: "application/json", info: "JSON", isRequired: false),
                    .init(key: "Accept", value: "application/json", info: "JSON", isRequired: false),
                ],
                body: [
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
                    .init(value: .ok, info: "Succesful log in"),
                    .init(value: .movedPermanently, info: "Moved"),
                    .init(value: .notFound, info: "Not found"),
                    .init(value: .internalServerError, info: "ERRROR"),
                ],
                headers: [
                    .init(key: "Content-Type", value: "application/json", info: "JSON", isRequired: false),
                ],
                body: [
                    .init(name: "UserLoginResponse", info: "response object", parameters: [
                        .init(name: "id", type: .uuid, isRequired: true, info: "User identifier"),
                        .init(name: "name", type: .string, isRequired: true, info: "User name"),
                        .init(name: "user", type: .object, isRequired: true, info: "User"),
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
