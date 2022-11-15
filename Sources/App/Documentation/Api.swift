//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 12..
//

import Foundation

extension Endpoint {
    
    static var api: [Group] {
        [
            Group(
                name: "User",
                info: "User authentication and profile details.",
                endpoints: userEndpoints
            ),
            Group(
                name: "Post",
                info: "Post management - list, create, update, delete, etc.",
                endpoints: postEndpoints
            ),
            Group(
                name: "Tag",
                info: "Tag management - list, create, update, delete, etc.",
                endpoints: tagEndpoints
            ),
        ]
    }
}
