//
//  Story.swift
//  eurosport
//
//  Created by Thanh on 02/12/2022.
//

import Foundation

struct Story: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let teaser: String
    let image: String
    let date: TimeInterval
    let author: String
    let sport: Sport
    let articleType: ArticleType = .story
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case teaser
        case image
        case date
        case author
        case sport
    }
}
