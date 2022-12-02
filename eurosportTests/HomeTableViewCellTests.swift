//
//  HomeTableViewCellTests.swift
//  eurosportTests
//
//  Created by Thanh on 02/12/2022.
//

import XCTest

@testable import eurosport

class HomeTableViewCellsTests: XCTestCase {
    
    func test_play_image_for_video_is_visible() {
        // Given
        let cell = HomeTableViewCell()
        let viewModel = HomeTableViewCellViewModel(
            title: "",
            subtitle: "",
            thumbnailURL: "",
            type: .video,
            category: ""
        )
        
        // When
        cell.reloadCell(with: viewModel)
        
        // Then
        XCTAssertFalse(cell.playImageView.isHidden)
    }
    
    func test_play_image_for_story_is_hidden() {
        // Given
        let cell = HomeTableViewCell()
        let viewModel = HomeTableViewCellViewModel(
            title: "",
            subtitle: "",
            thumbnailURL: "",
            type: .story,
            category: ""
        )
        
        // When
        cell.reloadCell(with: viewModel)
        
        // Then
        XCTAssertTrue(cell.playImageView.isHidden)
    }
}
