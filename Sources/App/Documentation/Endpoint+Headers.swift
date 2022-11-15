//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 15..
//

import Foundation

extension Endpoint.Header {

    static var contentTypeBody: Endpoint.Header {
        .init(
            key: "Content-Type",
            value: "application/json",
            info: "Indicates that the request body is a JSON object.",
            isMandatory: true
        )
    }

    static var contentTypeResponse: Endpoint.Header {
        .init(
            key: "Content-Type",
            value: "application/json",
            info: "Indicates that the response is a JSON object.",
            isMandatory: true
        )
    }
    
    static var accept: Endpoint.Header {
        .init(
            key: "Accept",
            value: "application/json",
            info: "Standard accept header to indicate that we only accept a JSON response.",
            isMandatory: false
        )
    }
    
    static var authorization: Endpoint.Header {
        .init(
            key: "Authorization",
            value: "Bearer [TOKEN]",
            info: "You have to provide a Bearer token using this header field to access this endpoint.",
            isMandatory: true
        )
    }
}
