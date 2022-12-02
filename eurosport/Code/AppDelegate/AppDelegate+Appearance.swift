//
//  AppDelegate+Appearance.swift
//  eurosport
//
//  Created by Thanh on 02/12/2022.
//

import UIKit

extension AppDelegate {
    func setupAppearance() {
        setupNavBarAppearance()
    }
    
    private func setupNavBarAppearance() {
        let newNavBarAppearance = customNavBarAppearance()
        
        let appearance = UINavigationBar.appearance()
        appearance.scrollEdgeAppearance = newNavBarAppearance
        appearance.compactAppearance = newNavBarAppearance
        appearance.standardAppearance = newNavBarAppearance
        appearance.compactScrollEdgeAppearance = newNavBarAppearance
    }
    
    func customNavBarAppearance() -> UINavigationBarAppearance {
        let customNavBarAppearance = UINavigationBarAppearance()
        
        customNavBarAppearance.configureWithOpaqueBackground()
        customNavBarAppearance.backgroundColor = Asset.Colors.main.color
        
        // Apply white colored normal and large titles.
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        customNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Apply white color to all the nav bar buttons.
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.white]
        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
        customNavBarAppearance.backButtonAppearance = barButtonItemAppearance
        customNavBarAppearance.doneButtonAppearance = barButtonItemAppearance
        
        customNavBarAppearance.setBackIndicatorImage(Asset.Images.back.image, transitionMaskImage: Asset.Images.back.image)
        
        return customNavBarAppearance
    }
}
