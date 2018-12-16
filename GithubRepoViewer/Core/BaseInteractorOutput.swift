//
//  BaseInteractorOutput.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation


protocol BaseInteractorOutput: class {
    func onSetTokenSuccess()
    func onAuthChecked(authorized: Bool)
    
    func onError(reason: String)
    func onRequestBegin(completion: @escaping (() -> ()))
    func onRequestFinish()
}
