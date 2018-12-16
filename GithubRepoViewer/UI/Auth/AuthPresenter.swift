//
//  AuthAuthPresenter.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Open Solutions. All rights reserved.
//


class AuthPresenter: AuthPresenterOutput, AuthInteractorOutput {
    
    weak var view: AuthViewOutput?
    var interactor: AuthInteractorInput?
    var router: AuthRouterInput?
    
    required init() { }
    
    func viewOutput() -> BaseViewOutput {
        if let out = view {
            return out
        } else {
            fatalError("viewOutput() in \(String.init(describing: self)) is nil!!!")
        }
    }
    
    func routerInput() -> BaseRouter? {
        return router
    }

    //FIXME remove me
    static func assemble(view: AuthViewController) -> AuthPresenterOutput {
        let presenter = AuthPresenter()
        
        let service: AuthService = InstancesFactory.createService()
        let interactor: AuthInteractor = InstancesFactory.createInteractor(service: service, output: presenter)
        let router: AuthRouter = InstancesFactory.createRouter(view: view)
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        return presenter
    }
    
    // MARK: - BaseInteractorOutput

    func onAuthChecked(authorized: Bool, isOnlyForSupport: Bool) {
    }
    
    // MARK: - AuthPresenterOutput
    
    func onAuthSuccess() {
    }
    
    func onAuthFailed() {
    }

    // MARK: - AuthinteractorOutput
    
    func viewIsReady() {
        debugPrint("viewIsReady")
    }
    
    func onLoginChanged(_ login: String?) {
        debugPrint("onLoginChanged: \(String(describing: login))")
    }
    
    func onPasswordChanged(_ password: String?) {
        debugPrint("onPasswordChanged: \(String(describing: password))")
    }
    
    func onAuthClicked() {
        debugPrint("onAuthClicked")
    }
}
