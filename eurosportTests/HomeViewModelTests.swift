//
//  HomeViewModelTests.swift
//  eurosportTests
//
//  Created by Thanh on 02/12/2022.
//

import XCTest
import Combine

@testable import eurosport

class HomeViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    func setupViewModel(videoCount: Int, storyCount: Int) -> LiveHomeViewModel {
        let mockRepository = MockRepository(videoCount: videoCount, storyCount: storyCount)
        let viewModel = LiveHomeViewModel(
            coordinator: MockRootCoordinator(),
            homeRepository: mockRepository
        )
        return viewModel
    }
    
    func waitForSubscription(viewModel: LiveHomeViewModel, completion: ((HomeState) -> Void)?) {
        viewModel
            .currentState
            .sink { state in
                if case .loaded = state {
                    completion?(state)
                }
            }
            .store(in: &cancellables)
    }
    
    func test_datasource_count_is_correct() {
        // Given
        let numberOfVideos: Int = 5
        let numberOfStories: Int = 10
        let viewModel = setupViewModel(videoCount: numberOfVideos, storyCount: numberOfStories)
        
        // When
        viewModel.fetchHome()
        let expectation = expectation(description: "Wait for subscription")
        
        // Then
        waitForSubscription(viewModel: viewModel) { state in
            XCTAssertEqual(numberOfVideos + numberOfStories, state.values.count)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.3)
    }
    
    func test_dto_to_viewModel_conversion_is_correct() {
        // Given
        let numberOfVideos: Int = 2
        let numberOfStories: Int = 3
        let mockDTO = createMockDTOHome(videoCount: numberOfVideos, storyCount: numberOfStories)
        
        let viewModel = setupViewModel(videoCount: numberOfVideos, storyCount: numberOfStories)
        
        // When
        let cellViewModels = viewModel.dtoToViewModels(dto: mockDTO)
        
        // Then
        XCTAssertEqual(cellViewModels[0], .story(mockDTO.stories[0]))
        XCTAssertEqual(cellViewModels[1], .video(mockDTO.videos[0]))
        XCTAssertEqual(cellViewModels[2], .story(mockDTO.stories[1]))
        XCTAssertEqual(cellViewModels[3], .video(mockDTO.videos[1]))
        XCTAssertEqual(cellViewModels[4], .story(mockDTO.stories[2]))
        XCTAssertEqual(cellViewModels.count, numberOfVideos + numberOfStories)
    }
    
    func test_tap_article_cell_show_article_view() {
        // Given
        let mockCoordinator = MockRootCoordinator()
        let viewModel = LiveHomeViewModel(
            coordinator: mockCoordinator,
            homeRepository: MockRepository(videoCount: 0, storyCount: 1)
        )
        
        // When
        viewModel.fetchHome()
        let expectation = expectation(description: "Wait for subscription")
        
        waitForSubscription(viewModel: viewModel) { state in
            viewModel.tableView(UITableView(), didSelectRowAt: IndexPath(item: 0, section: 0))
            
            // Then
            XCTAssertTrue(mockCoordinator.didCallShowArticleView)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.3)
    }
    
    func test_tap_video_cell_present_video_player() {
        // Given
        let mockCoordinator = MockRootCoordinator()
        let viewModel = LiveHomeViewModel(
            coordinator: mockCoordinator,
            homeRepository: MockRepository(videoCount: 1, storyCount: 0)
        )
        
        // When
        viewModel.fetchHome()
        let expectation = expectation(description: "Wait for subscription")
        
        waitForSubscription(viewModel: viewModel) { state in
            viewModel.tableView(UITableView(), didSelectRowAt: IndexPath(item: 0, section: 0))
            
            // Then
            XCTAssertTrue(mockCoordinator.didCallShowVideo)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.3)
    }
}
