//
//  ResultBase.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation
import EVReflection

class ResultBase: EVObject {

    var errors: [ResultError]? = []
    var success: NSNumber?
    var need_token: NSNumber?
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "error":
            if let rawValue = value as? NSArray {
                for (val) in rawValue {
                    errors?.append(ResultError(json: ((val as? NSDictionary) ?? [:]).toJsonString()))
                }
            } else {
                let re = ResultError()
                re.field = ""
                re.value = (value as? String) ?? "Error"
                self.errors?.append(re)
            }
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
    
    
}

class Cookies: EVObject {
    var BITRIX_SM_SUPPORT_NOT_AUTH_PWD: String?
}
