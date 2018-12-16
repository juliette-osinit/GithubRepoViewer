//
//  AuthAuthViewController.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Open Solutions. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController, AuthViewOutput  {

    var assembler = AuthAssembler()
    var presenter: AuthPresenterOutput?
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = AuthPresenter.assemble(view: self)
        
        presenter?.viewIsReady()
    }

    @IBAction func signInClicked(_ sender: Any) {
        presenter?.onAuthClicked()
    }
    
    // MARK: - AuthViewInput
    
}

extension AuthViewController: Constructable {
    
    func getAssembler() -> BaseModuleAssembler? {
        return assembler
    }
    
    func setPresenter<T: BasePresenter>(presenter: T) {
        if self.presenter == nil {
            self.presenter = presenter as? AuthPresenterOutput
        }
    }
}
