//
//  AuthResponse.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import EVReflection
import Foundation


enum AuthResponseResultType: String {
    case success = "success"
    case fail = "fail"
}


class AuthResponse: ResponseBase {
    var result: AuthResponseResult?
}

class AuthResponseResult: ResultBase {
    var result: String?
    var type: String?
    var to: String?
    var security_code: String?
}
