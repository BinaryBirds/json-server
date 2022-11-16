//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 11. 15..
//

import Foundation

extension Endpoint.Object {
    
    static var userLoginRequest: Endpoint.Object {
        .init(
            name: "UserLoginRequest",
            info: "A simple JSON object with an email and password values.",
            parameters: [
                .init(
                    name: "email",
                    type: .string,
                    isMandatory: true,
                    info: "Valid email address of the user account."
                ),
                .init(
                    name: "password",
                    type: .string,
                    isMandatory: true,
                    info: "Login password for the given user account."
                ),
            ]
        )
    }

    static var token: Endpoint.Object {
        .init(
            name: "UserLoginResponse",
            info: "The response object, containing the authorization token value.",
            parameters: [
                .init(
                    name: "id",
                    type: .uuid,
                    isMandatory: true,
                    info: "Unique identifier of the authorization token."),
                .init(
                    name: "value",
                    type: .string,
                    isMandatory: true,
                    info: "The authorization token, this sould be used as a Bearer value."),
                .init(
                    name: "user",
                    type: .object("User"),
                    isMandatory: true,
                    info: "Detailed information about the user account."),
            ]
        )
    }

    static var user: Endpoint.Object {
        .init(
            name: "User",
            info: "The user account detail object.",
            parameters: [
                .init(
                    name: "id",
                    type: .uuid,
                    isMandatory: true,
                    info: "Unique user identifier."
                ),
                .init(
                    name: "email",
                    type: .string,
                    isMandatory: true,
                    info: "Email address of the user account."
                ),
                .init(
                    name: "name",
                    type: .string,
                    isMandatory: false,
                    info: "Name of the user."
                ),
                .init(
                    name: "imageUrl",
                    type: .string,
                    isMandatory: false,
                    info: "Profile picture URL for the given user account."
                ),
            ]
        )
    }
    
    static func userInput(isPatch: Bool = false) -> Endpoint.Object {
        .init(
            name: "UserInput",
            info: "Input object for altering user types.",
            parameters: [
                
                .init(
                    name: "email",
                    type: .string,
                    isMandatory: !isPatch,
                    info: "New email address for the user."
                ),
                .init(
                    name: "name",
                    type: .string,
                    isMandatory: !isPatch,
                    info: "New name for the user."
                ),
                .init(
                    name: "password",
                    type: .string,
                    isMandatory: !isPatch,
                    info: "New password for the user."
                ),
                .init(
                    name: "imageUrl",
                    type: .string,
                    isMandatory: !isPatch,
                    info: "New profile picture URL for the user."
                ),
            ]
        )
    }
    
    
    // MARK: - post
    
    static var postDetail: Endpoint.Object {
        .init(
            name: "Post",
            info: "Post detail object containing joined post information.",
            parameters: [
                .init(
                    name: "id",
                    type: .uuid,
                    isMandatory: true,
                    info: "Unique post identifier"
                ),
                .init(
                    name: "title",
                    type: .string,
                    isMandatory: true,
                    info: "Post title"
                ),
                .init(
                    name: "imageUrl",
                    type: .string,
                    isMandatory: true,
                    info: "Post image URL."
                ),
                .init(
                    name: "date",
                    type: .string,
                    isMandatory: true,
                    info: "Publish date of the post."
                ),
                .init(
                    name: "excerpt",
                    type: .string,
                    isMandatory: true,
                    info: "Short description of the post."
                ),
                .init(
                    name: "content",
                    type: .string,
                    isMandatory: true,
                    info: "Actual contents of the post."
                ),
                .init(
                    name: "tags",
                    type: .array("TagList"),
                    isMandatory: true,
                    info: "Associated tags of a given post."
                ),
            ]
        )
    }
    
    static func postInput(isPatch: Bool = false) -> Endpoint.Object {
        .init(
            name: "PostInput",
            info: "Input object for altering post types.",
            parameters: [
                .init(
                    name: "title",
                    type: .string,
                    isMandatory: !isPatch,
                    info: "Post title"
                ),
                .init(
                    name: "imageUrl",
                    type: .string,
                    isMandatory: !isPatch,
                    info: "Post image URL."
                ),
                .init(
                    name: "date",
                    type: .string,
                    isMandatory: !isPatch,
                    info: "Publish date of the post."
                ),
                .init(
                    name: "excerpt",
                    type: .string,
                    isMandatory: !isPatch,
                    info: "Short description of the post."
                ),
                .init(
                    name: "content",
                    type: .string,
                    isMandatory: !isPatch,
                    info: "Actual contents of the post."
                ),
                .init(
                    name: "tagIds",
                    type: .array("UUID"),
                    isMandatory: !isPatch,
                    info: "Tag identifiers as String values to associate the post with."
                ),
            ]
        )
    }
    
    // MARK: -
    
    static var tagListItem: Endpoint.Object {
        .init(
            name: "TagListItem",
            info: "Short tag information.",
            parameters: [
                .init(
                    name: "id",
                    type: .uuid,
                    isMandatory: true,
                    info: "Unique tag identifier"
                ),
                .init(
                    name: "name",
                    type: .string,
                    isMandatory: true,
                    info: "Name of the tag"
                ),
            ]
        )
    }
    
    static var tagDetail: Endpoint.Object {
        .init(
            name: "TagDetail",
            info: "Detailed tag information.",
            parameters: [
                .init(
                    name: "id",
                    type: .uuid,
                    isMandatory: true,
                    info: "Unique identifier of the tag object."
                ),
                .init(
                    name: "name",
                    type: .string,
                    isMandatory: true,
                    info: "Name of the tag object."
                ),
            ]
        )
    }
    
    static func tagInput(isPatch: Bool = false) -> Endpoint.Object {
        .init(
            name: "TagInput",
            info: "Input object for altering tag types.",
            parameters: [
                .init(
                    name: "name",
                    type: .string,
                    isMandatory: !isPatch,
                    info: "Name of the tag"
                ),
            ]
        )
    }
}
