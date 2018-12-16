//
//  AuthAuthInteractor.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Open Solutions. All rights reserved.
//

import RxSwift


class AuthInteractor: AuthInteractorInput, BaseInteractor {

    var bag = DisposeBag()
    var authService: AuthService?
    weak var authOutput: AuthInteractorOutput?
    
    required internal init<T : BaseService, U : BaseInteractorOutput>(service: T, output: U) {
        authService = service as? AuthService
        authOutput = output as? AuthInteractorOutput
    }
    
    func service() ->BaseService {
        if let authS = authService {
            return authS
        } else {
            fatalError("service() in \(String.init(describing: self)) is nil!!!")
        }
    }
    
    func output() -> BaseInteractorOutput {
        if let out = authOutput {
            return out
        } else {
            fatalError("output() in \(String.init(describing: self)) is nil!!!")
        }
    }
    
    func signIn(login: String, password: String) {
        weak var weakSelf = self
        
//        chainRequest {
//            weakSelf?.authService?.authorizeWithEmailAndPush(login: login, password: password).subscribe(onNext: {
//                (response,data) in
//                let resp = AuthResponse(json: data as? String)
//                weakSelf?.handleAuthResponse(result: resp.result, success: {
//                    if let result = AuthResponseResultType(rawValue: resp.result) {
//                        switch result {
//                        case .success :
//                            weakSelf?.authOutput?.onAuthSucess()
//                        case .fail:
//                            weakSelf?.authOutput?.onAuthFailed()
//                        }
//                    } else {
//                        weakSelf?.authOutput?.onAuthFailed()
//                    }
//                }, error: { error in
//                    weakSelf?.authOutput?.onAuthFailed()
//                })
//            }, onError: { (error) in
//                weakSelf?.authOutput?.onError()
//            }).disposed(by: self.bag)
//        }
    }

}
