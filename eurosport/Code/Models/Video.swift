//
//  Video.swift
//  eurosport
//
//  Created by Thanh on 02/12/2022.
//

import Foundation

struct Video: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let thumbnail: String
    let url: String
    let date: TimeInterval
    let views: Int
    let sport: Sport
    let articleType: ArticleType = .video
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case thumbnail = "thumb"
        case url
        case date
        case views
        case sport
    }
}
