//
//  BaseViewOutput.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation
import UIKit


protocol BaseViewOutput: class {
    func waitForComplete(completion: (() -> ())?, callback: @escaping (() -> ()))
    func dismissWiredController()
    func onError(reason: String)
}


extension BaseViewOutput {
}
