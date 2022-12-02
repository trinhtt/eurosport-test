//
//  RootCoordinator.swift
//  eurosport
//
//  Created by Thanh on 02/12/2022.
//

import UIKit
import AVKit

protocol RootCoordinator {
    func showArticleView(with story: Story)
    func showVideo(with stringURL: String)
}

class LiveRootCoordinator: Coordinator<UINavigationController>, RootCoordinator {
    
    func start() {
        let homeViewController = HomeViewController(
            viewModel: LiveHomeViewModel(
                coordinator: self,
                homeRepository: LiveHomeRepository()
            )
        )
        rootViewController?.setViewControllers([homeViewController], animated: false)
    }
    
    func showArticleView(with story: Story) {
        let articleViewController = ArticleViewController(story: story)
        rootViewController?.pushViewController(articleViewController, animated: true)
    }
    
    func showVideo(with stringURL: String) {
        guard let url = URL(string: stringURL) else { return }
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        
        rootViewController?.present(vc, animated: true) {
            vc.player?.play()
        }

    }
}
