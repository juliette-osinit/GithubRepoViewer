//
//  AuthService.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import EVReflection


class AuthService : BaseService {
    
    required init() {
    }
    
    func signIn(login: String, password: String) -> Observable<(HTTPURLResponse, AnyObject)> {
        let regRequest = AuthRequestBody(action: Actions.auth.rawValue, login: login, password: password)
        return request(body: regRequest, method: .post)
    }
    
}
