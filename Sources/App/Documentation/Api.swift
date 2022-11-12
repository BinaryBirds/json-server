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
            Group(name: "User", info: "User related endpoints", endpoints: userEndpoints),
            Group(name: "Post", info: "Post related endpoints", endpoints: postEndpoints),
        ]
    }
}
