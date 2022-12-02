//
//  AppDelegate+Window.swift
//  eurosport
//
//  Created by Thanh on 02/12/2022.
//

import UIKit

extension AppDelegate {
    
    func prepareWindow() {
        let navigationController = NavigationController()
        let rootCoordinator = LiveRootCoordinator(rootViewController: navigationController)
        rootCoordinator.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootCoordinator.rootViewController
        window?.makeKeyAndVisible()
    }
}
