//
//  ApiProvider.swift
//  DragonBall
//
//  Created by ibautista on 11/10/23.
//

import Foundation

protocol ApiProviderProtocol {
    func login(for user: String, with pasword: String)
}

class ApiProvider: ApiProviderProtocol {
    
    static private let apiBaseURL = "https://dragonball.keepcoding.education/api"
    
    private enum Endpoint {
        static let login = "/auth/login"
    }
    
    func login (for user: String, with password: String) {  // Lo normal es que vaya con el completion, lo vamos a hacer con notificacion por pornerlo en practica.
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.login)") else {
            return
        }
        
        guard let loginData = String(format: "%@:%@", user, password).data(using: .utf8)?.base64EncodedString() else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            print("Login: \(String(describing: response))")
            guard error == nil else {
                //Enviar notificacion indicando error
                return
            }
            guard data,
                    (response as? HTTPURLResponse)?.statusCode == 200 else {
                //Enviar notificacion
                return
            }
            guard let responseData = String(data: data, encoding: .utf8) else {
                //Enviar notificacion indicando reponse vacío
                return
            }
            
            NotificationCenter.default.post(
                name: NotificationCenter.apiLoginNotification,
                object: nil,
                userInfo: ["KEY_TOKEN" : responseData])
        }.resume()
        
    }
    
}
