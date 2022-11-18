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
                    .accept,
                ],
                body: [
                ],
                example: ###"""
                curl -X GET http://localhost:8080/api/v1/tags/ \
                     -H "Accept: application/json"
                """###
            ),
            response: .init(
                statusCodes: [
                    .ok,
                ],
                headers: [
                    .contentTypeResponse,
                ],
                body: [
                    .init(
                        name: "[TagListItem]",
                        info: "Array of tag list items.",
                        parameters: [
                            .init(
                                name: "id",
                                type: .uuid,
                                isMandatory: true,
                                info: "Unique identifier of the tag object."
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
                [
                    {
                        "id": "F34F7725-1DEF-4D58-AF96-DCA55ECAEE46",
                        "name": "Red"
                    },
                    {
                        "id": "1E3D953E-7FD8-43E4-B394-62854ED7FB7E",
                        "name": "Orange"
                    }
                ]
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
                    .notFound,
                ],
                headers: [
                    .contentTypeResponse,
                ],
                body: [
                    .tagDetail,
                ],
                example: ###"""
                {
                    "id": "F34F7725-1DEF-4D58-AF96-DCA55ECAEE46",
                    "name": "Red"
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
                    .tagInput(),
                ],
                example: ###"""
                curl -X POST http://localhost:8080/api/v1/tags/ \
                     -H "Authorization: Bearer [TOKEN]" \
                     -H "Content-Type: application/json" \
                     -H "Accept: application/json" \
                     --data-raw '
                     {
                         "name": "Red"
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
                    .tagDetail,
                ],
                example: ###"""
                {
                    "id": "F34F7725-1DEF-4D58-AF96-DCA55ECAEE46",
                    "name": "Red"
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
                    .tagInput(),
                ],
                example: ###"""
                curl -X PUT http://localhost:8080/api/v1/tags/[id]/ \
                     -H "Authorization: Bearer [TOKEN]" \
                     -H "Content-Type: application/json" \
                     -H "Accept: application/json" \
                     --data-raw '
                     {
                         "name": "Red"
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
                    .tagDetail,
                ],
                example: ###"""
                {
                    "id": "F34F7725-1DEF-4D58-AF96-DCA55ECAEE46",
                    "name": "Red"
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
                    .tagInput(isPatch: true),
                ],
                example: ###"""
                curl -X PATCH http://localhost:8080/api/v1/tags/[id]/ \
                     -H "Authorization: Bearer [TOKEN]" \
                     -H "Content-Type: application/json" \
                     -H "Accept: application/json" \
                     --data-raw '
                     {
                         "name": "Red"
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
                    .tagDetail,
                ],
                example: ###"""
                {
                    "id": "F34F7725-1DEF-4D58-AF96-DCA55ECAEE46",
                    "name": "Red"
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
                    .deleted,
                    .unauthorized,
                    .notFound
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
