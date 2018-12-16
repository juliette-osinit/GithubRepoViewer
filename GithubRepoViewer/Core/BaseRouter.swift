//
//  BaseRouter.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation
import UIKit


protocol BaseRouter: class {

    var view: RoutableView? { get set}

    init()
}


extension BaseRouter {

    func goToParentScreen() {
        _ = view?.pop()
    }
}
