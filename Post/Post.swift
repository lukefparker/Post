//
//  Post.swift
//  Post
//
//  Created by luke parker on 12/17/18.
//  Copyright © 2018 luke parker. All rights reserved.
//

import Foundation

//let posts: Post = []
struct Post: Codable {
    let username: String
    let text: String
    let timestamp: TimeInterval
    
    init(username: String, text: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
    self.username = username
    self.text = text
    self.timestamp = timestamp
}

    var queryTimeStamp: TimeInterval {
        return self.timestamp - 0.00001
    }
    var date: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
