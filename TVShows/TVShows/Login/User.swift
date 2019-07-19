//
//  User.swift
//  TVShows
//
//  Created by Infinum on 15/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let type: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}
struct LoginData: Codable {
    let token: String
}

struct Shows: Codable {
    let id: String
    let title: String
    let imageUrl: String
    let likesCount: Int
    enum CodingKeys: String, CodingKey {
        case title
        case imageUrl
        case likesCount
        case id = "_id"
    }
}



