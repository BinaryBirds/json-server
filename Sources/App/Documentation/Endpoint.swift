//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 11..
//

import Foundation
import Vapor

struct Endpoint {

    let name: String

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
        
        var name: String {
            switch self {
            case .uuid:
                return rawValue.uppercased()
            default:
                return rawValue.capitalized
            }
        }
        
        var htmlValue: String {
            "<span class=\"type \(rawValue)\">\(name)</span>"
        }
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
        
        
        /*
        pre code .keyword { color: #9B2393; }
        pre code .type { color: #3900A0; }
        pre code .call { color: #326D74; }
        pre code .property { color: #6C36A9; }
        pre code .number { color: #1C00CF; }
        pre code .string { color: #C41A16; }
        pre code .comment { color: #5D6C79; }
        pre code .dotAccess { color: #0F68A0; }
        pre code .preprocessing { color: #643820;
         */
            
        var curl: String {
            return example
                .replacingOccurrences(of: "curl", with: "<span class=\"call\">curl</span>")
                .replacingOccurrences(of: "-X POST", with: "-X <span class=\"keyword\">POST</span>")
                .replacingOccurrences(of: "-X GET", with: "-X <span class=\"keyword\">GET</span>")
                .replacingOccurrences(of: "-X PUT", with: "-X <span class=\"keyword\">PUT</span>")
                .replacingOccurrences(of: "-X PATCH", with: "-X <span class=\"keyword\">PATCH</span>")
                .replacingOccurrences(of: "-X DELETE", with: "-X <span class=\"keyword\">DELETE</span>")
                .replacingOccurrences(of: "-X", with: "<span class=\"property\">-X</span>")
                .replacingOccurrences(of: "-H", with: "<span class=\"property\">-H</span>")
                .replacingOccurrences(of: "--data-raw", with: "<span class=\"property\">--data-raw</span>")
                .replacingOccurrences(of: "\\", with: "<span class=\"keyword\">\\</span>")
                .replacingOccurrences(of: " \"", with: " <span class=\"string\">\"")
                .replacingOccurrences(of: "\" ", with: "\"</span> ")
        }
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

struct Group {
    let name: String
    let info: String

    let endpoints: [Endpoint]
}
