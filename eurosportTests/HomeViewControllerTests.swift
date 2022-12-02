//
//  HomeViewControllerTests.swift
//  eurosportTests
//
//  Created by Thanh on 02/12/2022.
//

import XCTest
import Combine

@testable import eurosport

class HomeViewControllerTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    func test_show_loader_if_state_loading() {
        // Given
        let mockViewModel = MockHomeViewModel(.loading(previousState: nil))
        let viewController = HomeViewController(viewModel: mockViewModel)
        let expectation = expectation(description: "Wait for subscription")
        
        // When
        viewController.viewDidLoad()
        mockViewModel.getCurrentState { _ in
            // Then
            XCTAssertTrue(viewController.loader.isAnimating)
            XCTAssertFalse(viewController.loader.isHidden)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.3)
    }
    
    func test_hide_loader_if_state_loaded() {
        // Given
        let videos = createMockVideos(number: 1)
        let state = HomeState.loaded(videos.map { .video($0) })
        let mockViewModel = MockHomeViewModel(state)
        let viewController = HomeViewController(viewModel: mockViewModel)
        let expectation = expectation(description: "Wait for subscription")
        
        // When
        viewController.viewDidLoad()
        mockViewModel.getCurrentState { _ in
            // Then
            XCTAssertFalse(viewController.loader.isAnimating)
            XCTAssertTrue(viewController.loader.isHidden)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.3)
    }
    
    func test_cell_count_is_correct() {
        // Given
        let videos = createMockVideos(number: 17)
        let state = HomeState.loaded(videos.map { .video($0) })
        let mockViewModel = MockHomeViewModel(state)
        let viewController = HomeViewController(viewModel: mockViewModel)
        let expectation = expectation(description: "Wait for subscription")
        
        // When
        viewController.viewDidLoad()
        mockViewModel.getCurrentState { _ in
            // Then
            XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), 17)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.3)
    }
}
