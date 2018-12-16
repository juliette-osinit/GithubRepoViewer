//
//  InstancesFactory.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation

class InstancesFactory {
    
    static func createService<T:BaseService>() -> T {
        let service = T()
        service.apiProvider = ApiProvider(URL: URL(string:AppConstants.EndpointURL)!)
        return service
    }
    
    static func createInteractor<T:BaseInteractor, U:BaseService, V:BaseInteractorOutput> (service: U, output: V) -> T {
        return T(service: service,output: output)
    }
    
    static func createRouter<T:BaseRouter, T1: RoutableView>(view: T1) -> T {
        let router = T()
        router.view = view
        return router
    }
}
