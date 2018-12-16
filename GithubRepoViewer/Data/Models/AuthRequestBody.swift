//
//  AuthRequestBody.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation
import EVReflection

class AuthRequestBody : BaseRequestBody {
    
    var req: AuthRequest?
    
    init(action: String, login: String, password: String) {
        super.init(action:action)
        self.req = AuthRequest(login: login, password: password)
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}


class AuthRequest: EVObject {
    
    var login: String?
    var password: String?
    
    init(login: String?, password: String?) {
        self.login = login
        self.password = password
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
