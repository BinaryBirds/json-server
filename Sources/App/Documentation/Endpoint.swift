//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 11..
//

import Foundation
import Vapor

struct Endpoint {

    let method: Method
    let path: String
    let info: String
    
    let request: Request
    let response: Response
    
    
}

extension Endpoint {
    enum Method: String {
        case get
        case post
        case put
        case patch
        case delete
    }
}

extension Endpoint {
    
    enum DataType: String {
        case uuid
        case string
        case int
        case bool
        case double
        case array
        case object
    }
}

extension Endpoint {
    struct Header {
        let key: String
        let value: String
        let info: String
        let isRequired: Bool
    }
}

extension Endpoint {
    struct Parameter {
        let name: String
        let type: DataType
        let isRequired: Bool
        let info: String
    }
}

extension Endpoint {

    struct Object {
        let name: String
        let info: String
        let parameters: [Parameter]
    }
}

extension Endpoint {
    
    struct Request {
        
        struct QueryParam {
            let name: String
            let type: DataType
            let isRequired: Bool
            let info: String
        }
        
        let queryParams: [QueryParam]
        let headers: [Header]
        let body: [Object]
        let example: String
    }
}


extension Endpoint {

    struct Response {
        
        struct Status {
            let value: HTTPResponseStatus
            let info: String
        }

        let statusCodes: [Status]
        let headers: [Header]
        let body: [Object]
        let example: String
    }
}

@resultBuilder
enum EndpointBuilder {

    static func buildBlock(_ components: Endpoint...) -> [Endpoint] {
        components
    }
}
