//
//  Assembler.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation


protocol Constructable: BaseViewOutput, RoutableView {
    func setPresenter<T: BasePresenter>(presenter: T)
    
    func getAssembler() -> BaseModuleAssembler?
}


extension Constructable  {
    
    func getAssembler() -> BaseModuleAssembler? {
        return nil
    }
    
    func setPresenter<T: BasePresenter>(presenter: T) {
    }
}
