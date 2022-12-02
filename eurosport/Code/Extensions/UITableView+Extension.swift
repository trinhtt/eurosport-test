//
//  UITableView+Extension.swift
//  eurosport
//
//  Created by Thanh on 02/12/2022.
//

import UIKit

extension UITableView {
    
    func registerCell(for type: AnyClass) {
        self.register(type, forCellReuseIdentifier: NSStringFromClass(type))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(
        ofType type: T.Type,
        at indexPath: IndexPath
    ) -> T {
        let identifier = NSStringFromClass(type)
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        guard let cell = cell as? T else { fatalError("Couldn't dequeue cell of type \(type.description())") }
        return cell
    }
}
