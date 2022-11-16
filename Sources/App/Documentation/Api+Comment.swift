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
    }
}
