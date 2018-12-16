//
//  AuthProtocols.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation


// MARK: - Interactor protocols

protocol AuthInteractorInput: BaseInteractor {
    func signIn(login: String, password: String)
}

protocol AuthInteractorOutput: BaseInteractorOutput {
    func onAuthSuccess()
    func onAuthFailed()
}

// MARK: - Router protocols

protocol AuthRouterInput: BaseRouter {
    func goToReposView()
}

// MARK: - Presenter protocols

protocol AuthPresenterOutput: BasePresenter {
    func viewIsReady()
    func onLoginChanged(_ login: String?)
    func onPasswordChanged(_ password: String?)
    func onAuthClicked()
}

// MARK: - View protocols

protocol AuthViewOutput: BaseViewOutput {
}
