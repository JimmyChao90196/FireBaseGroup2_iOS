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
        case authorId = "author_id"
        case tag
        case createdTime = "created_time"
    }
    
    init( id: String, title: String, content: String, tag: [String], createdTime: Timestamp) {
        self.id = id
        self.title = title
        self.content = content
        self.tag = tag
        self.authorId = "Jimmy"
        self.createdTime = createdTime
    }
}
