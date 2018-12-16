//
//  BaseInteractor.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation
import RxSwift
import Localize_Swift


protocol BaseInteractor: class {
    var bag: DisposeBag { get set }
    func handleResponse< T : ResultBase> (result: T?, success: (() -> ()), error: ((String) -> ()), closeThrobber: Bool)
    func service() -> BaseService
    func output() -> BaseInteractorOutput
    init<T:BaseService,U:BaseInteractorOutput>(service:T, output:U)
}


extension BaseInteractor {
    
    func chainRequest(requestPushCode: Bool = false, callback: @escaping (() -> ())) {
        weak var weakSelf = self
        
        let callbackWrapper: (() -> ()) = {
            weakSelf?.output().onRequestBegin(){
                callback()
            }
        }
    }
    
    func handleResponse< T : ResultBase> (result: T?, success: (() -> ()), error: ((String) -> ()), closeThrobber: Bool = true ) {
        if closeThrobber {
            output().onRequestFinish()
        }
        
        if let res = result {
            if let errors = res.errors, errors.count > 0 {
                let err = errors[0]
                
                if (err.field ?? "-").lowercased() == "undifined_action" {
                    success()
                    return
                }
                
                var message = err.value ?? ""
                if err.msg != nil, !(err.msg?.isEmpty ?? false) {
                    message = err.msg ?? ""
                }
                
                if message.isEmpty {
                    message = "ERROR_RESPONSE".localized()
                }
                
                error(message)
            } else {
                if let success = res.success?.boolValue , success == false {
                    error("ERROR_RESPONSE".localized())
                }
                else {
                    success()
                }
            }
        } else {
            error("ERROR_RESPONSE".localized())
        }
    }
}
