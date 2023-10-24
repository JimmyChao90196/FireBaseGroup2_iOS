//
//  Article.swift
//  FireBaseGroup2_iOS
//
//  Created by JimmyChao on 2023/10/23.
//

import Foundation
import UIKit
import FirebaseFirestore


struct Article: Codable {
    
    var id: String
    var title: String
    var content: String
    var authorId: String
    var tag: [String]
    var createdTime: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case tag
        case authorId = "author_id"
        case createdTime = "created_time"
    }
    
    init( id: String, title: String, content: String, tag: [String], createdTime: Timestamp) {
        self.authorId = "Jimmy-83935"
        self.createdTime = createdTime
        self.id = id
        self.title = title
        self.content = content
        self.tag = tag
    }
}



struct UserInfo: Codable {
    var id: String
    var name: String
    var email: String
    var request: [String]
    var friend: [String]
    

    init(id: String, name: String, email: String, request: [String], friend: [String]) {
        self.id = id
        self.name = name
        self.email = email
        self.request = request
        self.friend = friend
    }
}


