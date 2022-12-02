//
//  UIView+Extension.swift
//  eurosport
//
//  Created by Thanh on 02/12/2022.
//

import UIKit

extension UIView {
    
    func constraintsForAnchoringTo(
        boundsOf view: UIView,
        withInsets insets: NSDirectionalEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.leading),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.trailing)
        ]
    }
}
