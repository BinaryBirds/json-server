//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 16..
//

import Foundation

extension Endpoint {
    
    @EndpointBuilder
    static var commentEndpoints: [Endpoint] {
        Endpoint(
            name: "List comments",
            method: .get,
            path: "/posts/[id]/comments/",
            info: "List all the comments for a given post.",
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
                curl -X GET http://localhost:8080/api/v1/posts/[id]/comments/ \
                     -H "Accept: application/json"
                """###
            ),
            response: .init(
                statusCodes: [
                    .ok,
                    .notFound,
                ],
                headers: [
                    .contentTypeResponse,
                ],
                body: [
                    .init(
                        name: "[CommentListItem]",
                        info: "Array of comment list items.",
                        parameters: [
                            .init(
                                name: "id",
                                type: .uuid,
                                isMandatory: true,
                                info: "Unique identifier of the comment object."
                            ),
                            .init(
                                name: "content",
                                type: .string,
                                isMandatory: true,
                                info: "Content of the comment message."
                            ),
                            .init(
                                name: "date",
                                type: .string,
                                isMandatory: true,
                                info: "Submission date of the given comment."
                            ),
                            .init(
                                name: "user",
                                type: .object("User"),
                                isMandatory: true,
                                info: "Comment author user details."
                            ),
                        ]
                    ),
                    .user,
                ],
                example: ###"""
                [
                    {
                        "user": {
                            "email": "root@localhost.com",
                            "id": "73FDE1C3-089A-480E-A99A-1C67E030FC87",
                            "imageUrl": "https://placekitten.com/256/256",
                            "name": "Root User"
                        },
                        "id": "936E1F6F-8675-43D7-BEDB-0A168DA4C551",
                        "content": "Cras leo nibh, suscipit eu consectetur quis",
                        "date": "2022-10-31T11:25:31Z"
                    },
                    {
                        "user": {
                            "email": "john@localhost.com",
                            "id": "19B5CC08-D698-4592-96B8-437681EDCE67",
                            "imageUrl": "https://placekitten.com/256/256",
                            "name": "John Doe"
                        },
                        "id": "54BDD31D-3660-4865-B7E2-5D7A1973C6CF",
                        "content": "Proin facilisis massa risus",
                        "date": "2022-10-31T11:25:31Z"
                    }
                ]
                """###
            )
        )
        
        // MARK: -
        
        Endpoint(
            name: "Create comment",
            method: .post,
            path: "/posts/[id]/comments/",
            info: "Create a new comment under an existing post.",
            request: .init(
                queryParams: [
                    
                ],
                headers: [
                    .authorization,
                    .contentTypeBody,
                    .accept,
                ],
                body: [
                    .init(
                        name: "CommentInput",
                        info: "Input type for creating a new comment under a post.",
                        parameters: [
                            .init(
                                name: "content",
                                type: .string,
                                isMandatory: true,
                                info: "Comment message value."
                            ),
                        ]
                    ),
                ],
                example: ###"""
                curl -X POST http://localhost:8080/api/v1/posts/[id]/comments/ \
                     -H "Authorization: Bearer [TOKEN]" \
                     -H "Content-Type: application/json" \
                     -H "Accept: application/json" \
                     --data-raw '
                     {
                        "content": "Lorem ipsum dolor sit amet"
                     }
                     '
                """###
            ),
            response: .init(
                statusCodes: [
                    .ok,
                    .badRequest,
                    .notFound,
                ],
                headers: [
                    .contentTypeResponse,
                ],
                body: [
                    .init(
                        name: "CommentItem",
                        info: "A detailed view of a single comment message.",
                        parameters: [
                            .init(
                                name: "id",
                                type: .uuid,
                                isMandatory: true,
                                info: "Unique identifier of the comment object."
                            ),
                            .init(
                                name: "content",
                                type: .string,
                                isMandatory: true,
                                info: "Content of the comment message."
                            ),
                            .init(
                                name: "date",
                                type: .string,
                                isMandatory: true,
                                info: "Submission date of the given comment."
                            ),
                            .init(
                                name: "postId",
                                type: .uuid,
                                isMandatory: true,
                                info: "The post identifier of the given comment."
                            ),
                            .init(
                                name: "userId",
                                type: .uuid,
                                isMandatory: true,
                                info: "The identifier of the comment author."
                            ),
                        ]
                    ),
                ],
                example: ###"""
                {
                    "id": "D1C5CA29-AC1A-438A-A1CF-6256EC10F010",
                    "content": "Lorem ipsum dolor sit amet",
                    "postId": "91007F7C-DFC5-46EE-BA67-3865628EBC60",
                    "userId": "73FDE1C3-089A-480E-A99A-1C67E030FC87",
                    "date": "2022-11-16T14:37:03Z"
                }
                """###
            )
        )
        
        // MARK: -
        
        Endpoint(
            name: "Delete comment",
            method: .delete,
            path: "/posts/[id]/comments/[id]/",
            info: "Removes a given comment from an existing post item.",
            request: .init(
                queryParams: [
                    
                ],
                headers: [
                    .authorization,
                ],
                body: [
                ],
                example: ###"""
                curl -i -X DELETE http://localhost:8080/api/v1/posts/[id]/comments/[id]/ \
                     -H "Authorization: Bearer [TOKEN]"
                """###
            ),
            response: .init(
                statusCodes: [
                    .deleted,
                    .unauthorized,
                    .notFound,
                ],
                headers: [
                ],
                body: [
                ],
                example: ###"""
                HTTP/1.1 204 No Content
                connection: keep-alive
                date: Tue, 15 Nov 2022 16:41:21 GMT
                """###
            )
        )
        
        // MARK: -
    }
}
