//
//  RootCoordinator.swift
//  eurosport
//
//  Created by Thanh on 02/12/2022.
//

import UIKit

/// This protocol defines the behavior of a basic coordinator
protocol Coordinable {

  /// Presents the given view controller
  ///
  /// - Parameters:
  ///   - viewController: the view controller
  ///   - completion: the completion
  func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)

  /// Dismisses the current root view controller
  ///
  /// - Parameter completion: the completion
  func dismiss(animated: Bool, completion: (() -> Void)?)
}

/// This class defines the base coordinator
class Coordinator<T: UIViewController>: Coordinable {

  /// The root view controller
  weak var rootViewController: T?

  /// Initializes a new coordinator with a view controller
  ///
  /// - Parameter rootViewController: the root view controller
  init(rootViewController: T) {
    self.rootViewController = rootViewController
  }

  func present(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
    rootViewController?.present(viewController,
                                animated: animated,
                                completion: completion)
  }

  func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
    rootViewController?.dismiss(animated: animated, completion: completion)
  }
}

extension Coordinator where T: UINavigationController {

  /// Pushes the given view controller on the stack
  ///
  /// - Parameter viewController: the view controller
  func push(_ viewController: UIViewController) {
    rootViewController?.pushViewController(viewController, animated: true)
  }

  /// Pop the current view controller
  func back() {
    rootViewController?.popViewController(animated: true)
  }

  /// Pop to the root view controller
  func popToRoot() {
    rootViewController?.popToRootViewController(animated: true)
  }
}
