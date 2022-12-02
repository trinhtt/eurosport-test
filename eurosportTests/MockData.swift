//
//  MockData.swift
//  eurosportTests
//
//  Created by Thanh on 02/12/2022.
//

import XCTest
import Combine

@testable import eurosport

var mockFootballSport = Sport(id: 1, name: "Football")
var mockBasketballSport = Sport(id: 2, name: "Basketball")

func createMockVideos(number: Int) -> [Video] {
    var videos = [Video]()
    for i in 0..<number {
        videos.append(
            Video(
                id: i,
                title: "\(i)",
                thumbnail: "\(i)",
                url: "\(i)",
                date: Double(i),
                views: i,
                sport: i % 2 == 0 ? mockFootballSport : mockBasketballSport
            )
        )
    }
    
    return videos
}

func createMockStories(number: Int) -> [Story] {
    var stories = [Story]()
    for i in 0..<number {
        stories.append(
            Story(
                id: i,
                title: "\(i)",
                teaser: "\(i)",
                image: "\(i)",
                date: Double(i),
                author: "\(i)",
                sport: i % 2 == 0 ? mockFootballSport : mockBasketballSport
            )
        )
    }
    
    return stories
}

func createMockDTOHome(videoCount: Int, storyCount: Int) -> DTOHome {
    return DTOHome(
        videos: createMockVideos(number: videoCount),
        stories: createMockStories(number: storyCount)
    )
}

class MockRootCoordinator: RootCoordinator {
    
    var didCallShowArticleView = false
    var didCallShowVideo = false
    
    func showArticleView(with story: eurosport.Story) {
        didCallShowArticleView = true
    }
    
    func showVideo(with stringURL: String) {
        didCallShowVideo = true
    }
}

struct MockRepository: HomeRepository {
    
    let mockDTO: DTOHome
    
    init(
        videoCount: Int,
        storyCount: Int
    ) {
        self.mockDTO = createMockDTOHome(videoCount: videoCount, storyCount: storyCount)
    }
    
    func getHomeArticles() -> AnyPublisher<eurosport.DTOHome, Error> {
        return Future() { promise in
            promise(.success(mockDTO))
        }.eraseToAnyPublisher()
    }
}

class MockHomeViewModel: HomeViewModel {
    
    var stateSubject: CurrentValueSubject<HomeState, Never>
    private var cancellables = Set<AnyCancellable>()
    
    func fetchHome() {}
    
    init(_ state: HomeState) {
        stateSubject = CurrentValueSubject(state)
    }
    
    var currentState: AnyPublisher<eurosport.HomeState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    func getCurrentState(completion: ((HomeState) -> Void)?) {
        stateSubject
            .receive(on: RunLoop.main)
            .sink { state in
                completion?(state)
            }
            .store(in: &cancellables)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateSubject.value.values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
