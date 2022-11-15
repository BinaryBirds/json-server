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
}
