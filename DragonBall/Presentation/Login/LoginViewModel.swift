//
//  LoginViewModel.swift
//  DragonBall
//
//  Created by ibautista on 10/10/23.
//

import Foundation


class LoginViewModel: LoginViewControllerDelegate {
    
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    var viewState: ((LoginViewState) -> Void)?
    
    //MARK: - Initializers -
    init(
        apiProvider: ApiProviderProtocol,
        secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(onLoginReponse),
                name: NotificationCenter.apiLoginNotification,
                object: nil)
    
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func onLoginPressed(email: String?, password: String?) {
        viewState?(.loading(true))
        
        DispatchQueue.global().async {
            guard self.isValid(email: email) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorEmail("Indique un email válido"))
                return
            }
            guard self.isValid(password: password) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorEmail("Indique un password válido"))
                return
            }
            
            self.doLoginWith(
                email: email ?? "",
                password: password ?? ""
            )
        }
        
    }
    
    @objc func onLoginReponse(_ notification: Notification) {
        // Pasear resultado que vendrá en notification.userInfo.
        defer {
            viewState?.(.loading(false))  // se ejecuta al final de la funcion, para aquellos casos donde hay que realizarlo en varios sitios
        }
        
        guard let token = notification.userInfo?[NotificationCenter.tokenKey] as? String,
              !token.isEmpty else {
            
            return
        }
        secureDataProvider.save(token: token)
        viewState?(.loading(true))
        viewState?(.navigateToNext)
        
    }
    
    private func isValid(email: String?) -> Bool {
        email?.isEmpty == false && email?.contains("@") ?? false
    }
    
    private func isValid(password: String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0) >= 4
        
    }
    
    func doLoginWith(email: String, password: String) {
        
    }
}

extension NotificationCenter {   // Lo suyo es que esté en su clase especifica
    static let apiLoginNotification = Notification.Name("NOTIFICATION_API_LOGIN")
}
