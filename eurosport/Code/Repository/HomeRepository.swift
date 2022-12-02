//
//  HomeRepository.swift
//  eurosport
//
//  Created by Thanh on 02/12/2022.
//

import Foundation
import Combine

protocol HomeRepository {
    func getHomeArticles() -> AnyPublisher<DTOHome, Error>
}

struct DTOHome: Codable {
    let videos: [Video]
    let stories: [Story]
}

struct LiveHomeRepository: HomeRepository {
    
    enum Constants {
        static let homeURL = "https://extendsclass.com/api/json-storage/bin/edfefba"
    }
    
    func getHomeArticles() -> AnyPublisher<DTOHome, Error> {
        APIClient.shared.get(endpoint: Constants.homeURL)
            .eraseToAnyPublisher()
        
    }
}
