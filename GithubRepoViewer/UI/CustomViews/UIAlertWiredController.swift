//
//  UIAlertWiredController.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation
import UIKit

class UIAlertWiredController: UIAlertController {
    var callback: (() -> ())?
    var nextAction: (() -> ())?
    
    func dismissWithCustomCompletion() {
        if callback != nil {
            dismiss(animated: true, completion: callback)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
