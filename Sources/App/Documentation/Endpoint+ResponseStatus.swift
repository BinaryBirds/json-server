//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 15..
//

import Foundation

extension Endpoint.Response.Status {

    static var ok: Endpoint.Response.Status {
        .init(value: .ok, info: "Indicates a successful response.")
    }

    static var unauthorized: Endpoint.Response.Status {
        .init(value: .unauthorized, info: "Indicates an unauthorized request attempt.")
    }
    
    static var badRequest: Endpoint.Response.Status {
        .init(value: .badRequest, info: "Indicates an invalid request body.")
    }
    
    static var notFound: Endpoint.Response.Status {
        .init(value: .notFound, info: "Object not found.")
    }
    
    static var deleted: Endpoint.Response.Status {
        .init(value: .noContent, info: "Object succesfully deleted.")
    }
}
