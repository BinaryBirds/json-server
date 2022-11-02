//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 10. 27..
//

import Vapor

struct ApiUser: Authenticatable {
    let id: UUID
}

