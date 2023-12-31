//
//  ApiProvider.swift
//  DragonBall
//
//  Created by ibautista on 11/10/23.
//

import Foundation

extension NotificationCenter {   // Lo suyo es que esté en su clase especifica
    static let apiLoginNotification = Notification.Name("NOTIFICATION_API_LOGIN")
    static let tokenKey = "KEY_TOKEN"
}

// MARK: - Protocol -
protocol ApiProviderProtocol {
    func login(for user: String, with pasword: String)
//    func getHeroes(by name: String?, token: String, completion: ((String) -> Void)?)
}

// MARK: - Class -
class ApiProvider: ApiProviderProtocol {

    // MARK: - Constants -
    static private let apiBaseURL = "https://dragonball.keepcoding.education/api"

    private enum Endpoint {
        static let login = "/auth/login"
        static let heroes = "/heros/all"
    }
    // MARK: - Funcion ApiProviderProtocol -
    func login (for user: String, with password: String) {  // Lo normal es que vaya con el completion, lo vamos a hacer con notificacion por pornerlo en practica.
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.login)") else {
            return
        }
        guard let loginData = String(format: "%@:%@",
                                     user, password).data(using: .utf8)?.base64EncodedString() else {
            // por requerimiento de la api hay que codificarlo a base664.
            return
        }
        var urlRequest = URLRequest(url: url) // Preparando la url para hacer la petición
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(loginData)",
                            forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in  // Para hacer la petición
            //            print("Login: \(String(describing: response))")
            guard error == nil else {
                // TODO: Enviar notificacion indicando error
                return
            }
            guard let data,  // Que haya datos y responda status code 200. Igual que poner let data = data (Si no es nil guardalo en data)
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                // TODO: Enviar notificacion indicando response error
                return
            }
            guard let responseData = String(data: data, encoding: .utf8) else {  // El token viene como string ni json ni otro modelo de datos. No hay que decodificar.
                // TODO: Enviar notificacion indicando reponse vacío
                return
            }

            NotificationCenter.default.post(   // Enviamos notificación con el data que es el token
                name: NotificationCenter.apiLoginNotification,
                object: nil,
                userInfo: [NotificationCenter.tokenKey: responseData])
        }.resume()
    }
}
//    func getHeroes(by name: String?) {
//        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.heroes)") else {
//            return
//        }
//
//        let jsonData: [String: Any] = ["name": name ?? ""]
//        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue("Bearer \(token)",
//                            forHTTPHeaderField: "Autorizathion")
//        urlRequest.httpBody = jsonParameters
//
//        URLSession.shared.dataTask(with: urlRequest) { data, response, error in  // Para hacer la petición
//            //            print("Login: \(String(describing: response))")
//            guard error == nil else {
//                // TODO: Enviar notificacion indicando error
//                completion?([])
//                return
//            }
//            guard let data,  // Que haya datos y responda status code 200. Igual que poner let data = data (Si no es nil guardalo en data)
//                  (response as? HTTPURLResponse)?.statusCode == 200 else {
//                // TODO: Enviar notificacion indicando response error
//                completion?([])
//                return
//            }
//            guard let heroes = try? JSONDecoder().decode(Heroes.self, from: data) else {
//
//            }
//            completion?(heroes)
//
//        }.resume()
//    }
// }
