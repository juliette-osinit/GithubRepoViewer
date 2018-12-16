//
//  AuthAssembler.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation


class AuthAssembler: BaseModuleAssembler {
    
    func assemble(view: Constructable, data: AnyObject?) {
        let presenter = AuthPresenter()
        let router = AuthRouter(view)
        let service: AuthService = InstancesFactory.createService()
        let interactor: AuthInteractor = InstancesFactory.createInteractor(service: service, output: presenter)
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view as? AuthViewOutput
        
        view.setPresenter(presenter: presenter)
    }
}
