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

struct ShowDetails: Codable {
    let type: String
    let title: String
    let description: String
    let id: String
    let likesCount: Int
    let imageUrl: String
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case likesCount
        case imageUrl
        case id = "_id"
    }
}

struct Episodes: Codable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String
    let episodeNumber: String
    let season: String
  
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageUrl
        case episodeNumber
        case season
        case id = "_id"
    }
}

struct NewEpisode: Codable {
    let showId: String
    let mediaId: String
    let title: String
    let description: String
    let episodeNumber: String
    let season: String
    
    enum CodingKeys: String, CodingKey {
        case showId
        case mediaId
        case title
        case description
        case episodeNumber
        case season
    }
}

struct EpisodeDetails: Codable {
    let showId: String
    let imageUrl: String
    let title: String
    let description: String
    let episodeNumber: String
    let season: String
    let id: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case showId
        case imageUrl
        case title
        case description
        case episodeNumber
        case season
        case id = "_id"
        case type
    }
}

struct Comments: Codable {
    let text: String
    let episodeId: String
    let userEmail: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case text
        case episodeId
        case userEmail
        case id = "_id"
      }
}
struct Media: Codable {
    let mediaId: String
    enum CodingKeys: String, CodingKey {
        case mediaId
    }
}





