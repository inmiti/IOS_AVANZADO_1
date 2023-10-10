//
//  LoginViewModel.swift
//  DragonBall
//
//  Created by ibautista on 10/10/23.
//

import Foundation


class LoginViewModel: LoginViewControllerDelegate {
    
    var viewState: ((LoginViewState) -> Void)?
    
    func onLoginPressed(email: String?, password: String?) {
        viewState?(.loading(true))
        
        guard isValid(email: email) else {
            return
        }
        guard isValid(password: password) else {
            return
        }
        
        doLoginWith(
            email: email ?? "",
            password: password ?? "")
    }
    
    private func isValid(email: String?) -> Bool {
        email?.isEmpty == false && (email?.contains("@") ?? false
    }
    
    private func isValid(password: String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0) >= 4
        
    }
    
    func doLoginWith(email: <#T##String?#>, password: <#T##String?#>)
}
