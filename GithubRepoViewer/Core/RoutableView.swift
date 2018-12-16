//
//  RoutableView.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation
import UIKit


protocol RoutableView: class {
    func push(vc: UIViewController)
    func switchToTabBarController(vc: UITabBarController)
    func switchNavigationController(vc: UINavigationController)
    func pop() -> UIViewController?
    func present(customView: UIViewController)
}
