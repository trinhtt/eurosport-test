//
//  HomeViewController.swift
//  eurosport
//
//  Created by Thanh on 02/12/2022.
//

import Foundation
import Combine

class APIClient {
    
    private var configuration: URLSessionConfiguration
    private var session: URLSession
    private var decoder: JSONDecoder
    
    static let shared = APIClient()
    
    init(
        sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.configuration = sessionConfiguration
        self.session = URLSession(configuration: configuration)
        self.decoder = decoder
    }
    
    func get<T: Codable>(endpoint: String)  -> AnyPublisher<T, Error> {
        guard let url = URL(string: endpoint) else { return Fail(error: NetworkError.badURL).eraseToAnyPublisher() }
        
        return session.dataTaskPublisher(for: url)
            .tryMap(\.data)
            .decode(type: T.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
