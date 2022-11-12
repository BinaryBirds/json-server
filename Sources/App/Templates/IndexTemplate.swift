//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 11..
//

import SwiftHtml

struct IndexTemplate {
    
    static func build(_ endpoints: [Endpoint]) -> SwiftHtml.Tag {
        Html {
            Head {
                Meta().charset("utf-8")
                Meta().name(.viewport).content("width=device-width, initial-scale=1")

//                Title(title.stripHtml())

//                Style {
//                    Text(
//                        ###"""
//                        :root {
//                            --primary-color: \###(colors.primary.light);
//                            --secondary-color: \###(colors.secondary.light);
//                        }
//                        @media (prefers-color-scheme: dark) {
//                            :root {
//                                --primary-color: \###(colors.primary.dark);
//                                --secondary-color: \###(colors.secondary.dark);
//                            }
//                        }
//                        """###
//                        )
//                }
                
                Link(rel: .stylesheet).href("./css/colors.css")
                Link(rel: .stylesheet).href("./css/style.css")
                Link(rel: .stylesheet).href("./css/code.css")

                
                Style {
                    Text(###"""
      :root {
        --primary-color: #2097F3;
        --secondary-color: #2097F3;
      }

      @media (prefers-color-scheme: dark) {
        :root {
          --primary-color: #2097F3;
          --secondary-color: #2097F3;
        }
      }
"""###)
                }
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

                Section {
                    Div {
                        H2("Endpoints")
                        P("Lorem ipsum dolor sit amet")

                        Div {
                            for endpoint in endpoints {
                                H3(endpoint.path)
                                Dl {
                                    Dt {
                                        Span(endpoint.method.rawValue)
                                            .class("method", endpoint.method.rawValue)
                                        Text(" " + endpoint.path)
                                    }
                                    Dd {
                                        P(endpoint.info)
                                        
                                        H4("Request")
                                        
                                        H5("Query parameters")
                                        Ul {
                                            for param in endpoint.request.queryParams {
                                                Li {
                                                    if param.isRequired {
                                                        Span {
                                                            Span(param.name)
                                                                .class("name")
                                                            Span(" :" + param.type.rawValue)
                                                                .class("type")
                                                        }
                                                        .class("required")
                                                    }
                                                    else {
                                                        Span(param.name)
                                                            .class("name")
                                                        Span(" :" + param.type.rawValue)
                                                            .class("type")
                                                    }
                                                    Span(param.info)
                                                        .class("description")
                                                }
                                                
                                            }
                                        }
                                        .class("parameters")
                                        
                                        H5("Headers")
                                        render(headers: endpoint.request.headers)
                                        
                                        
                                        H5("Body")
                                        render(objects: endpoint.request.body)
                                        
                                        
                                        H4("Response")
                                        
                                        H5("Status codes")
         
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
                                        .class("response-codes")
                                    
                                        H5("Headers")
                                        render(headers: endpoint.response.headers)
                                        
                                        H5("Body")
                                        render(objects: endpoint.response.body)
                                        
                                        H4("Example")
                                        
                                        H5("Request")
                                        Pre {
                                            Code(endpoint.request.example)
                                        }
                                        
                                        H5("Response")
                                        Pre {
                                            Code(endpoint.response.example)
                                        }
                                    }
                                }
                                    
                                
                            }
                        }
                        .class("endpoints")
                    }
                    .class("container")
                }
                
                


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
    static func render(headers: [Endpoint.Header]) -> SwiftHtml.Tag {
        
        Ul {
            for header in headers {
                Li {
                    if header.isRequired {
                        Span {
                            Span(header.key)
                                .class("name")
                            Span(" :" + header.value)
                                .class("type")
                        }
                        .class("required")
                    }
                    else {
                        Span(header.key)
                            .class("name")
                        Span(" :" + header.value)
                            .class("type")
                    }
                    Span(header.info)
                        .class("description")
                }
                
            }
        }
        .class("parameters")
    }
    
    @TagBuilder
    static func render(objects: [Endpoint.Object]) -> SwiftHtml.Tag {
        for object in objects {
            H6(object.name)
            P(object.info)
            
            Ul {
                for param in object.parameters {
                    Li {
                        if param.isRequired {
                            Span {
                                Span(param.name)
                                    .class("name")
                                Span(" :" + param.type.rawValue)
                                    .class("type")
                            }
                            .class("required")
                        }
                        else {
                            Span(param.name)
                                .class("name")
                            Span(" :" + param.type.rawValue)
                                .class("type")
                        }
                        Span(param.info)
                            .class("description")
                    }
                    
                }
            }
            .class("parameters")
        }
    }
}
