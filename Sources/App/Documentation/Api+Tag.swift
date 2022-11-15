//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 15..
//

import Foundation

extension Endpoint {
    
    @EndpointBuilder
    static var tagEndpoints: [Endpoint] {
        Endpoint(
            name: "List tags",
            method: .get,
            path: "/tags/",
            info: "List all the available tags.",
            request: .init(
                queryParams: [
                    
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
                                name: "name",
                                type: .string,
                                isMandatory: true,
                                info: "Name of the tag object."
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
            name: "Get tag details",
            method: .get,
            path: "/tags/[id]/",
            info: "Get the details of a single tag object using an identifier.",
            request: .init(
                queryParams: [
                    
                ],
                headers: [
                    .accept,
                ],
                body: [
                ],
                example: ###"""
                curl -X GET http://localhost:8080/api/v1/tags/[id]/ \
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
                    .postDetail,
                    .tagList,
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
            name: "Create a new tag",
            method: .post,
            path: "/tags/",
            info: "Creates a new tag item and returns the created object.",
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
                  curl -X POST http://localhost:8080/api/v1/tags/ \
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
                    .tagList,
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
            name: "Update an existing tag",
            method: .put,
            path: "/tags/[id]/",
            info: "Updates an existing tag object with new data values based on the input.",
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
                  curl -X PUT http://localhost:8080/api/v1/tags/[id]/ \
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
                    .tagList,
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
            name: "Patch an existing tag",
            method: .patch,
            path: "/tags/[id]/",
            info: "Patch an existing tag item using an input object.",
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
                  curl -X POST http://localhost:8080/api/v1/tags/ \
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
                    .tagList,
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
            name: "Delete tag",
            method: .delete,
            path: "/tags/[id]/",
            info: "Removes an existing tag item including the post association links.",
            request: .init(
                queryParams: [
                ],
                headers: [
                    .authorization,
                ],
                body: [
                ],
                example: ###"""
                curl -i -X DELETE http://localhost:8080/api/v1/tags/[id]/ \
                    -H "Authorization: Bearer [TOKEN]"
                """###
            ),
            response: .init(
                statusCodes: [
                    .init(value: .noContent, info: "Object succesfully deleted."),
                    .unauthorized,
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
