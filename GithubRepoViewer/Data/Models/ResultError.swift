//
//  ResultError.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import EVReflection
import Foundation


enum ErrorValue: String {
    case sessionExpired = "session_expired"
}


class ResultError: EVObject {
    var field: String?
    var code: String?
    var value: String?
    var msg: String?
    var type: String?
}
