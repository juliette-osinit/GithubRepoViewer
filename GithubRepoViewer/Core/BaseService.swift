//
//  BaseService.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import EVReflection


enum Actions: String {
    case auth = "auth"
}


protocol BaseServiceProtocol: class {
    var apiProvider: ApiProvider! {get set}
    func request<T : EVReflectable>(body: T?, method: Alamofire.HTTPMethod, path: String) -> Observable<(HTTPURLResponse, AnyObject)>
    init()
}


class BaseService: BaseServiceProtocol {
    
    var apiProvider: ApiProvider!
    
    required init() {
    }
}


extension BaseServiceProtocol {
    
    func request<T : EVReflectable>(body: T?, method: Alamofire.HTTPMethod, path: String = "") -> Observable<(HTTPURLResponse, AnyObject)> {
        return apiProvider.request(path: path, method: method, parameters: (body!.toDictionary()) as? [String : AnyObject])
            .flatMap({ (response: HTTPURLResponse, data: AnyObject) -> Observable<(HTTPURLResponse, AnyObject)> in
                return Observable.just((response, data))
            })
    }
    
    func auth(_ login: String, _ password: String) -> Observable<(HTTPURLResponse, AnyObject)> {
        let req = AuthRequestBody(action: Actions.auth.rawValue, login: login, password: password)
        return request(body: req, method: .post)
    }
}
