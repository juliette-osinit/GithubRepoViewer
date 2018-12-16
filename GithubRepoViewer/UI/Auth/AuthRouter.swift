//
//  AuthAuthRouter.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Open Solutions. All rights reserved.
//

class AuthRouter: AuthRouterInput {
    
    weak var view: RoutableView?
    
    required init() { }
    
    init(_ view: RoutableView?) {
        self.view = view
    }
    
    func goToReposView() {
        debugPrint("goToReposView")
//        let vc = ReposViewController.controllerFromStoryboard(.repos)
//        vc.getAssembler()?.assemble(view: vc, data: nil)
//        view?.push(vc: vc)
    }
}
