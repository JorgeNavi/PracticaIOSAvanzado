//
//  PIARequestBuilder.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//

import Foundation

//creamos un builder que nos construya las request:
class PIARequestBuilder {
    
    //creamos una constante a la que le asignamos el valor del host de la url (del server). En nuestro caso, la API de DB
    private let host = "dragonball.keepcoding.education"
    //creamos una variable para nuestra URLRequest
    private var request: URLRequest?
    //creamos una constante para el token
    var token: String? {
        secureStorage.getToken() //Cogemos el valor del token del keychain
    }
    
    //para el keyChain, instanciamos una constante de tipo SecureDataStoreProtocol. El compilador nos pide que hagamos el init.
    private let secureStorage: SecureDataStoreProtocol
    
    //con esto ya tenemos acceso a nuestro keyChain
    init(secureStorage: SecureDataStoreProtocol = SecureDataStore.shared) {
        self.secureStorage = secureStorage
    }
    
    //creamos el método en el que vamos a asignar valor a los componentes de la url:
    private func url(endPoint: PIAEndPoint) throws(PIAApiError) -> URL { //le pasamos el endPoint por parámetro para poder acceder a él
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.host
        components.path = endPoint.path()
        if let url = components.url {
            return url
        } else {
            throw PIAApiError.URLMalFormed
        }
    }
    
    //Este método nos va a establecer las cabeceras en función de lo que le pasemos (cabeceras como "Authorization")
    //requiredAuthorization se va a usar para la implementación del Token
    private func setHeaders(params: [String: String]?, requiredAuthorization: Bool = true) throws(PIAApiError) { // params: [String: String] es el parámetro de las cabeceras
        if requiredAuthorization { //Si se requiere autorizacion:
            guard let token = self.token else { //comprobamos que tenemos el token desempaquetandolo
                throw PIAApiError.sessionTokenMissing //token perdido
            }
            request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let params {
            request?.httpBody = try? JSONSerialization.data(withJSONObject: params)
            }
        request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

    
    func buildRequest(endPoint: PIAEndPoint, params: [String: String]) throws(PIAApiError) -> URLRequest { //le pasamos el endPoint por parámetro para poder acceder a él
        do {
            let url = try self.url(endPoint: endPoint)
            request = URLRequest(url: url) //aquí se le asigna la URL completa de la request a request
            request?.httpMethod = endPoint.httpMethod() //Aqui se establece el metodo http (en este caso solo tenemos POST porque en nuestra API recuperar herores es POST
            try setHeaders(params: params) //Le pasamos el header
            if let finalRequest = self.request {
                return finalRequest //Y se devuelve request
            }
        } catch {
            throw error
        }
        throw PIAApiError.URLMalFormed
    }
}
