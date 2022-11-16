//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 16..
//

import Foundation

extension Endpoint {

    @EndpointBuilder
    static var fileEndpoints: [Endpoint] {
        Endpoint(
            name: "Upload file",
            method: .post,
            path: "/files/",
            info: "Upload a single file using a key to save under a given name.",
            request: .init(
                queryParams: [
                    .init(
                        name: "key",
                        type: .string,
                        isMandatory: true,
                        info: "The name that should be used to store the file."
                    ),
                ],
                headers: [
                    .authorization,
                ],
                body: [
                ],
                example: ###"""
                 curl -X POST "http://localhost:8080/api/v1/files/?key=test.jpg" \
                     -H "Authorization: Bearer [TOKEN]" \
                     --data-binary @"/Users/[me]/test_image.jpg"
                """###
            ),
            response: .init(
                statusCodes: [
                    .ok,
                    .unauthorized,
                ],
                headers: [
                    
                ],
                body: [
                    .init(
                        name: "String",
                        info: "The full URL of the uploaded file.",
                        parameters: [
                        ]
                    ),
                ],
                example: ###"""
                HTTP/1.1 200 OK
                content-type: text/plain; charset=utf-8
                content-length: 38
                connection: keep-alive
                date: Wed, 16 Nov 2022 13:50:00 GMT

                http://localhost:8080/uploads/test.jpg
                """###
            )
        )
        
        // MARK: -
    }
}
