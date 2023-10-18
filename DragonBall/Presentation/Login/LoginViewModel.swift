//
//  LoginViewModel.swift
//  DragonBall
//
//  Created by ibautista on 10/10/23.
//

import Foundation

class LoginViewModel: LoginViewControllerDelegate {

    // MARK: - Dependencies -
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol

    // MARK: - Properties -
    var viewState: ((LoginViewState) -> Void)?

    // MARK: - Initializers -
    init(
        apiProvider: ApiProviderProtocol,
        secureDataProvider: SecureDataProviderProtocol) {
            self.apiProvider = apiProvider
            self.secureDataProvider = secureDataProvider

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(onLoginResponse),
                name: NotificationCenter.apiLoginNotification,
                object: nil)
        }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public Functions -
    func onLoginPressed(email: String?, password: String?) {
        viewState?(.loading(true)) // Mostrar vista de carga, se deja en el hilo principal
        DispatchQueue.global().async {
            guard self.isValid(email: email) else {
                self.viewState?(.loading(false))  // deja de mostrar la carga. Hemos indicado main en el setObserver
                self.viewState?(.showErrorEmail("Indique un email válido")) // muestra mensaje de error
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

    @objc func onLoginResponse(_ notification: Notification) {  // Funcion que se ejecutará cuando notifique 
        // Pasear resultado que vendrá en notification.userInfo.
        defer {
            viewState?(.loading(false)) // deja de mostar el loading
        }

//      //Accedemos al token, nos aseguramos de que haya token y no esté vacío. Es de tipo any, hay que castearlo a string.
        guard let token = notification.userInfo?[NotificationCenter.tokenKey] as? String,
              !token.isEmpty else {
            return
        }
        secureDataProvider.save(token: token) // guardamos el token en el keychain
        viewState?(.navigateToNext) // navega a la siguiente pantalla
    }

    // MARK: - Private functions -
    private func isValid(email: String?) -> Bool {
        email?.isEmpty == false && email?.contains("@") ?? false
    }

    private func isValid(password: String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0) >= 4
    }

    private func doLoginWith(email: String, password: String) {
        apiProvider.login(for: email,
                          with: password)
    }
}
