//
//  BasePresenter.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation


protocol BasePresenter: BaseInteractorOutput {
    func onSetTokenSuccess()
    func onError(reason: String)
    func onAuthChecked(authorized: Bool)
    
    func viewOutput() -> BaseViewOutput
    func routerInput() -> BaseRouter?
    init()
}


extension BasePresenter {
    
    func onSetTokenSuccess() {
    }

    func onError(reason: String) {
        print(reason)
        viewOutput().onError(reason: reason)
    }

    func onAuthChecked(authorized: Bool) {
    }
    
    func onRequestBegin(completion: @escaping (() -> ())) {
        viewOutput().waitForComplete(completion: completion) {}
    }
    
    func onRequestFinish() {
        debugPrint("close throbber")
        viewOutput().dismissWiredController()
    }
}
