//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 11..
//

import SwiftHtml

struct IndexTemplate {
    
    static func build(_ groups: [Group]) -> SwiftHtml.Tag {
        Html {
            Head {
                Meta().charset("utf-8")
                Meta().name(.viewport).content("width=device-width, initial-scale=1")
                
                Title("JSON server")
                
                Link(rel: .stylesheet).href("./css/colors.css")
                Link(rel: .stylesheet).href("./css/style.css")
                Link(rel: .stylesheet).href("./css/code.css")
                
                //                Link(rel: .icon).href("./img/\(key).ico")
                //                Link(rel: .shortcutIcon).href("./img/\(key)/favicon.ico")
                //                Link(rel: .appleTouchIcon).href("./img/\(key)/apple-touch-icon.png")
                
            }
            Body {
                Header {
                    H1 {
                        B("JSON")
                        Text(" server")
                    }
                    P("Just a dummy API server.")
                }
                
                Div {
                    
                    Div {
                        Div {
                            H2("Base URL")
                            //                            P("http://localhost:8080/api/v1/")
                            P("https://jsonserver.binarybirds.com/api/v1/")
                        }
                        .class("global-info")
                        
                        Div {
                            H3("Global query parameters")
                            
                            Ul {
                                Li {
                                    Span(" - ")
                                        .style("color: #999 !important;")
                                    Span("sleep")
                                        .class("name")
                                    Span(": " + "Int")
                                        .class("type")
                                    Span("Emulate slow response times by providing a sleep value in seconds. (e.g. ?sleep=3)")
                                        .class("description")
                                }
                                
                                Li {
                                    Span(" - ")
                                        .style("color: #999 !important;")
                                    Span("chaos")
                                        .class("name")
                                    Span(": " + "String")
                                        .class("type")
                                    Span("The server might returns with a random response if this parameter is present. (e.g. ?chaos=true)")
                                        .class("description")
                                }
                            }
                            .class("parameters", "content-block")
                            
                        }
                        .class("global-info")
                        
                        for (groupIndex, group) in groups.enumerated() {
                            Header {
                                H2(group.name)
                                P(group.info)
                            }
                            .class("group-info")
                            
                            
                            Section {
                                for (endpointIndex, endpoint) in group.endpoints.enumerated() {
                                    let endpointId = "\(groupIndex+1)-\(endpointIndex+1)"
                                    
                                    Div {
                                        Header {
                                            Span(endpoint.method.rawValue)
                                                .class("method", endpoint.method.rawValue)
                                            Text(" " + endpoint.path)
                                            
                                            Img(src: "/img/chevron-down.svg", alt: "Toggle")
                                        }
                                        .onClick("toggleElement('endpoint-\(endpointId)')")
                                        
                                        details(endpoint: endpoint, endpointId: endpointId)
                                    }
                                    .class("endpoint")
                                }
                            }
                            .class("endpoints")
                        }
                    }
                    .class("container")
                }
                .class("wrapper")
                
                Footer {
                    P {
                        Text("Created by ")
                        A("Tibor Bödecs")
                            .href("https://twitter.com/tiborbodecs/")
                            .target(.blank)
                        Text(" &middot; 2022")
                    }
                }
                
                Script()
                    .type(.javascript)
                    .src("./js/main.js")
            }
        }
    }
    
    
}


private extension IndexTemplate {
    
    @TagBuilder
    static func details(endpoint: Endpoint, endpointId: String) -> SwiftHtml.Tag {
        Div {
            Div {
                Header {
                    H3(endpoint.name)
                    P(endpoint.info)
                }
                
                Div {
                    Button("Example")
                        .onClick("changeTab(event, 'example')")
                        .class("tablinks active")
                    
                    Button("Request")
                        .onClick("changeTab(event, 'request')")
                        .class("tablinks")
                    
                    Button("Response")
                        .onClick("changeTab(event, 'response')")
                        .class("tablinks")
                }
                .class("tab")
                
                Div {
                    exampleBlock(endpoint, endpointId: endpointId)
                }
                .id("example")
                .class("tabcontent", "first")
                
                Div {
                    requestBlock(endpoint)
                }
                .id("request")
                .class("tabcontent")
                
                Div {
                    responseBlock(endpoint)
                }
                .id("response")
                .class("tabcontent")
            }
            .class("details")
        }
        .id("endpoint-\(endpointId)")
        .class("details-wrapper")
    }
    
    @TagBuilder
    static func render(headers: [Endpoint.Header]) -> SwiftHtml.Tag {
        
        Ul {
            for header in headers {
                Li {
                    if header.isMandatory {
                        Span {
                            Span(header.key)
                                .class("name")
                            Span(": " + header.value)
                                .class("type")
                        }
                        .class("required")
                    }
                    else {
                        Span(header.key)
                            .class("name")
                        Span(": " + header.value)
                            .class("type")
                    }
                    Span(header.info)
                        .class("description")
                }
                
            }
        }
        .class("parameters", "content-block")
    }
    
    @TagBuilder
    static func render(objects: [Endpoint.Object]) -> SwiftHtml.Tag {
        for object in objects {
            Div {
                Header {
                    H5(object.name)
                    P(object.info)
                }
                Ul {
                    for param in object.parameters {
                        Li {
                            Span(" - ")
                                .style("color: #999 !important;")
                            Span(param.name)
                                .class("name")
                                .class(add: "required", param.isMandatory)
                            Text(": ")
                            Span(param.type.htmlValue)
                                .class("type")
                                .class(add: "required", param.isMandatory)
                            
                            Span(param.info)
                                .class("description")
                        }
                        
                    }
                }
                .class("parameters")
            }
            .class("object", "content-block")
        }
    }
    
    @TagBuilder
    static func exampleBlock(_ endpoint: Endpoint, endpointId: String) -> SwiftHtml.Tag {
        Div {
            Textarea(endpoint.request.curlExample)
                .id("example-code-\(endpointId)")
                .class("original-code")
            
            Button {
                Text("Copy")
            }
            .id("copy-button-\(endpointId)")
            .class("copy-button")
            .onClick("copySnippet('\(endpointId)')")
        }
        .id("tooltip-\(endpointId)")
        .class("tooltip")
        
        H4("cURL request")
        Pre {
            Code(endpoint.request.curl)
        }
        .class("content-block")
        
        H4("Sample response")
        Pre {
            Code(endpoint.response.highlightedExample)
        }
        .class("content-block")
    }
    
    @TagBuilder
    static func requestBlock(_ endpoint: Endpoint) -> SwiftHtml.Tag {
        
        if !endpoint.request.queryParams.isEmpty {
            H4("Query parameters")
            Ul {
                for param in endpoint.request.queryParams {
                    Li {
                        if param.isMandatory {
                            Span {
                                Span(param.name)
                                    .class("name")
                                Span(": " + param.type.htmlValue)
                                    .class("type")
                            }
                            .class("required")
                        }
                        else {
                            Span(param.name)
                                .class("name")
                            Span(": " + param.type.htmlValue)
                                .class("type")
                        }
                        Span(param.info)
                            .class("description")
                    }
                    
                }
            }
            .class("parameters", "content-block")
        }
        
        if !endpoint.request.headers.isEmpty {
            H4("Headers")
            render(headers: endpoint.request.headers)
        }
        
        if !endpoint.request.body.isEmpty {
            H4("Body")
            render(objects: endpoint.request.body)
        }
    }
    
    @TagBuilder
    static func responseBlock(_ endpoint: Endpoint) -> SwiftHtml.Tag {
        
        if !endpoint.response.statusCodes.isEmpty {
            H4("Status codes")
            Ul {
                for status in endpoint.response.statusCodes {
                    Li {
                        Span(String(status.value.code))
                            .class("code")
                        Span(" - " + status.value.reasonPhrase.capitalized)
                            .class("name")
                        
                        Span(status.info)
                            .class("reason")
                    }
                    .class("httpStatus\(String(status.value.code / 100))xx")
                }
            }
            .class("response-codes", "content-block")
        }
        
        if !endpoint.response.headers.isEmpty {
            H4("Headers")
            render(headers: endpoint.response.headers)
        }
        
        if !endpoint.response.body.isEmpty {
            H4("Body")
            render(objects: endpoint.response.body)
        }
    }
}
