//
//  LoginViewController.swift
//  DragonBall
//
//  Created by ibautista on 10/10/23.
//

import UIKit

// MARK: - View Protocol -
protocol LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)? { get set }
    func onLoginPressed(email: String?, password: String?)
    // TODO: Funcion que notifica al model que se ha pulsado el boton de login
}

// MARK: - View State -
enum LoginViewState {
    case loading(_ isLoading: Bool)
    case showErrorEmail(_ error: String?)
    case showErrorPassword(_ error: String?)
    case navigateToNext
}

class LoginViewController: UIViewController {
    // MARK: - IBOutlet -
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailFieldError: UILabel!
    @IBOutlet weak var passwordFieldError: UILabel!
    @IBOutlet weak var loadingView: UIView!

    // MARK: - IBAction -
    @IBAction func onLoginPressed(_ sender: Any) {
        // Obtener el email y password introducidos por el usuario
        // Enviarlos al servicio del API de login

        viewModel?.onLoginPressed(
            email: emailField.text,
            password: passwordField.text)
    }
    // MARK: - Public Properties -
    var viewModel: LoginViewControllerDelegate?

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
        // Do any additional setup after loading the view.
    }

    // MARK: - Private Properties -
    private enum FieldType: Int {
        case email = 0
        case password
    }

    private func initViews() {
        emailField.delegate = self  // delegado que responde ante los mensajes introducidos por el usuario. Detecta cuando el usuario empieza a escribir y así podemos ocultar los mensajes de error.
        emailField.tag = FieldType.email.rawValue
        passwordField.delegate = self
        passwordField.tag = FieldType.password.rawValue

        view.addGestureRecognizer( // detecta cuando se toca la pantalla para que oculte el teclado
            UITapGestureRecognizer(
                target: self, // el target se refiere a la vista self, al loginView
                action: #selector(dismissKeyboard) // la funcion que se ejecuta cuando hacemos tap en el loginView
            )
        )
    }

    @objc func dismissKeyboard() {  // funcion para que se oculte el teclado
        view.endEditing(true)
    }

    private func setObservers() {
        viewModel?.viewState = { [weak self] state in  // ViewModel envia el estado a la vista, y según eso la vista ejectuará una lógica u otra.
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.loadingView.isHidden = !isLoading  // si es false se oculta la vista

                    case .showErrorEmail(let error):
                        self?.emailFieldError.text = error
                        self?.emailFieldError.isHidden = (error == nil || error?.isEmpty == true)

                    case .showErrorPassword(let error):
                        self?.passwordFieldError.text = error
                        self?.passwordFieldError.isHidden = (error == nil || error?.isEmpty == true)

                    case .navigateToNext:
                        self?.loadingView.isHidden = true // cuando vayamos a la siguiente vista nos aseguramos de que la vista se oculta, para evitar posibles fallos.
                    // Navegar a la siguiente vista
                }
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch FieldType(rawValue: textField.tag) {
        case .email:
            emailFieldError.isHidden = true
        case .password:
            passwordFieldError .isHidden = true
        default: break
        }
    }
}
