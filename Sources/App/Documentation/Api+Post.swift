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
                        type: .array("UUID"),
                        isMandatory: false,
                        info: "Array of tag identifiers. (e.g. ?tagIds[]=UUID1&tagIds[]=UUID2)"
                    ),
                    .init(
                        name: "search",
                        type: .string,
                        isMandatory: false,
                        info: "Search string that uses the post title and excerpt to look up posts."
                    ),
                    .init(
                        name: "from",
                        type: .string,
                        isMandatory: false,
                        info: "Lists post from a given start date. (e.g. ?from=2022-10-28T20:05:51Z)"
                    ),
                    .init(
                        name: "to",
                        type: .string,
                        isMandatory: false,
                        info: "Lists post until a given end date.  (e.g. ?to=2022-10-29T20:05:51Z)"
                    ),
                ],
                headers: [
                    .contentTypeBody,
                    .accept,
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
                    .ok,
                    .unauthorized,
                ],
                headers: [
                    .contentTypeResponse,
                ],
                body: [
                    .init(
                        name: "PagedPostResponse",
                        info: "The object containing the page items and the pagination metadata.",
                        parameters: [
                            .init(
                                name: "items",
                                type: .array("PostListItem"),
                                isMandatory: true,
                                info: "The array of post list items."
                            ),
                            .init(
                                name: "metadata",
                                type: .object("PageMetadata"),
                                isMandatory: true,
                                info: "The page metadata object"
                            ),
                        ]
                    ),
                    .init(
                        name: "PageMetadata",
                        info: "The object containing the page metadata details.",
                        parameters: [
                            .init(
                                name: "per",
                                type: .int,
                                isMandatory: true,
                                info: "The number of items per page."
                            ),
                            .init(
                                name: "total",
                                type: .int,
                                isMandatory: true,
                                info: "The total number of items."
                            ),
                            .init(
                                name: "page",
                                type: .int,
                                isMandatory: true,
                                info: "The current page index."
                            ),
                        ]
                    ),
                    
                    .init(
                        name: "PostListItem",
                        info: "The list item containing the basic post data.",
                        parameters: [
                            .init(
                                name: "id",
                                type: .uuid,
                                isMandatory: true,
                                info: "Unique identifier of the post object."
                            ),
                            .init(
                                name: "title",
                                type: .string,
                                isMandatory: true,
                                info: "Title of the post object."
                            ),
                            .init(
                                name: "imageUrl",
                                type: .string,
                                isMandatory: true,
                                info: "The associated image URL of the post item."
                            ),
                            .init(
                                name: "excerpt",
                                type: .string,
                                isMandatory: true,
                                info: "Short description about the post item."
                            ),
                            .init(
                                name: "date",
                                type: .string,
                                isMandatory: true,
                                info: "Publication date of the post item."
                            ),
                        ]
                    ),
                ],
                example: ###"""
                {
                    "items": [
                        {
                            "id": "C76C17FB-FA6B-4586-8C76-C4B66F1EC1E0",
                            "title": "Post #1",
                            "imageUrl": "https://placekitten.com/640/360",
                            "excerpt": "Excerpt #1",
                            "date": "2022-10-31T11:25:30Z"
                        },
                        /* ... */
                        {
                            "id": "91007F7C-DFC5-46EE-BA67-3865628EBC60",
                            "title": "Post #10",
                            "imageUrl": "https://placekitten.com/640/360",
                            "excerpt": "Excerpt #10",
                            "date": "2022-10-22T11:25:30Z"
                        }
                    ],
                    "metadata": {
                        "per": 10,
                        "total": 28,
                        "page": 1
                    }
                }
                """###
            )
        )
        
        // MARK: -
        
        Endpoint(
            name: "Get post details",
            method: .get,
            path: "/posts/[id]/",
            info: "Get the details of a single post object using an identifier.",
            request: .init(
                queryParams: [
                    
                ],
                headers: [
                    .accept,
                ],
                body: [
                ],
                example: ###"""
                curl -X GET http://localhost:8080/api/v1/posts/[id]/ \
                     -H "Accept: application/json"
                """###
            ),
            response: .init(
                statusCodes: [
                    .ok,
                    .unauthorized,
                    .notFound,
                ],
                headers: [
                    .contentTypeResponse,
                ],
                body: [
                    .postDetail,
                    .tagListItem,
                ],
                example: ###"""
                {
                    "id": "C76C17FB-FA6B-4586-8C76-C4B66F1EC1E0",
                    "title": "Post #1",
                    "imageUrl": "https://placekitten.com/640/360",
                    "date": "2022-10-31T11:25:30Z",
                    "excerpt": "Excerpt #1",
                    "content": "Content #1",
                    "tags": [
                        {
                            "id": "1E3D953E-7FD8-43E4-B394-62854ED7FB7E",
                            "name": "Orange"
                        },
                        {
                            "id": "F34F7725-1DEF-4D58-AF96-DCA55ECAEE46",
                            "name": "Red"
                        }
                    ]
                }
                """###
            )
        )
        
        // MARK: -
        
        Endpoint(
            name: "Create a new post",
            method: .post,
            path: "/posts/",
            info: "Creates a new post item and returns the created object.",
            request: .init(
                queryParams: [
                ],
                headers: [
                    .authorization,
                    .contentTypeBody,
                    .accept,
                ],
                body: [
                    .postInput(),
                ],
                example: ###"""
                curl -X POST http://localhost:8080/api/v1/posts/ \
                     -H "Authorization: Bearer [TOKEN]" \
                     -H "Content-Type: application/json" \
                     -H "Accept: application/json" \
                     --data-raw '
                     {
                         "imageUrl": "https://placekitten.com/640/360",
                         "title": "Lorem ipsum",
                         "excerpt": "Lorem ipsum",
                         "date": "2022-10-27T20:05:51Z",
                         "content": "Lorem ipsum dolor sit amet",
                         "tagIds": [
                            "1E3D953E-7FD8-43E4-B394-62854ED7FB7E",
                            "F34F7725-1DEF-4D58-AF96-DCA55ECAEE46"
                         ]
                     }
                     '
                """###
            ),
            response: .init(
                statusCodes: [
                    .ok,
                    .badRequest,
                    .unauthorized,
                    .notFound,
                ],
                headers: [
                    .contentTypeResponse,
                ],
                body: [
                    .postDetail,
                    .tagListItem,
                ],
                example: ###"""
                {
                    "id": "C76C17FB-FA6B-4586-8C76-C4B66F1EC1E0",
                    "title": "Lorem ipsum",
                    "imageUrl": "https://placekitten.com/640/360",
                    "date": "2022-10-31T11:25:30Z",
                    "excerpt": "Lorem ipsum",
                    "content": "Lorem ipsum dolor sit amet",
                    "tags": [
                        {
                            "id": "1E3D953E-7FD8-43E4-B394-62854ED7FB7E",
                            "name": "Orange"
                        },
                        {
                            "id": "F34F7725-1DEF-4D58-AF96-DCA55ECAEE46",
                            "name": "Red"
                        }
                    ]
                }
                """###
            )
        )
        
        // MARK: -
        
        Endpoint(
            name: "Update an existing post",
            method: .put,
            path: "/posts/[id]/",
            info: "Updates an existing post object with new data values based on the input.",
            request: .init(
                queryParams: [
                ],
                headers: [
                    .authorization,
                    .contentTypeBody,
                    .accept,
                ],
                body: [
                    .postInput(),
                ],
                example: ###"""
                curl -X PUT http://localhost:8080/api/v1/posts/[id]/ \
                     -H "Authorization: Bearer [TOKEN]" \
                     -H "Content-Type: application/json" \
                     -H "Accept: application/json" \
                     --data-raw '
                     {
                         "imageUrl": "https://placekitten.com/640/360",
                         "title": "Lorem ipsum",
                         "excerpt": "Lorem ipsum",
                         "date": "2022-10-27T20:05:51Z",
                         "content": "Lorem ipsum dolor sit amet",
                         "tagIds": [
                            "1E3D953E-7FD8-43E4-B394-62854ED7FB7E"
                         ]
                     }
                     '
                """###
            ),
            response: .init(
                statusCodes: [
                    .ok,
                    .badRequest,
                    .unauthorized,
                    .notFound,
                ],
                headers: [
                    .contentTypeResponse,
                ],
                body: [
                    .postDetail,
                    .tagListItem,
                ],
                example: ###"""
                {
                    "id": "C76C17FB-FA6B-4586-8C76-C4B66F1EC1E0",
                    "title": "Lorem ipsum",
                    "imageUrl": "https://placekitten.com/640/360",
                    "date": "2022-10-31T11:25:30Z",
                    "excerpt": "Lorem ipsum",
                    "content": "Lorem ipsum dolor sit amet",
                    "tags": [
                        {
                            "id": "F34F7725-1DEF-4D58-AF96-DCA55ECAEE46",
                            "name": "Red"
                        }
                    ]
                }
                """###
            )
        )
        
        // MARK: -
        
        Endpoint(
            name: "Patch an existing post",
            method: .patch,
            path: "/posts/[id]/",
            info: "Patch an existing post item using an input object.",
            request: .init(
                queryParams: [
                ],
                headers: [
                    .authorization,
                    .contentTypeBody,
                    .accept,
                ],
                body: [
                    .postInput(isPatch: true),
                ],
                example: ###"""
                curl -X PATCH http://localhost:8080/api/v1/posts/[id]/ \
                     -H "Authorization: Bearer [TOKEN]" \
                     -H "Content-Type: application/json" \
                     -H "Accept: application/json" \
                     --data-raw '
                     {
                          "imageUrl": "https://placekitten.com/640/360",
                          "title": "Lorem ipsum",
                          "excerpt": "Lorem ipsum",
                          "date": "2022-10-27T20:05:51Z",
                          "content": "Lorem ipsum dolor sit amet",
                          "tagIds": [
                              "F34F7725-1DEF-4D58-AF96-DCA55ECAEE46"
                          ]
                     }
                     '
                """###
            ),
            response: .init(
                statusCodes: [
                    .ok,
                    .badRequest,
                    .unauthorized,
                    .notFound,
                ],
                headers: [
                    .contentTypeResponse,
                ],
                body: [
                    .postDetail,
                    .tagListItem,
                ],
                example: ###"""
                {
                    "id": "C76C17FB-FA6B-4586-8C76-C4B66F1EC1E0",
                    "title": "Lorem ipsum",
                    "imageUrl": "https://placekitten.com/640/360",
                    "date": "2022-10-31T11:25:30Z",
                    "excerpt": "Lorem ipsum",
                    "content": "Lorem ipsum dolor sit amet",
                    "tags": [
                        {
                            "id": "F34F7725-1DEF-4D58-AF96-DCA55ECAEE46",
                            "name": "Red"
                        }
                    ]
                }
                """###
            )
        )
        
        // MARK: -
        
        Endpoint(
            name: "Delete post",
            method: .delete,
            path: "/posts/[id]/",
            info: "Removes an existing post item including the tag association links.",
            request: .init(
                queryParams: [
                ],
                headers: [
                    .authorization,
                ],
                body: [
                ],
                example: ###"""
                curl -i -X DELETE http://localhost:8080/api/v1/posts/[id]/ \
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
