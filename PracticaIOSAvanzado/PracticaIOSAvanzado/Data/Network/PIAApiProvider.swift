//
//  ApiProvider.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 15/10/24.
//

import Foundation

protocol PIAApiProviderProtocol {
    
    func loadHeroes(name: String, completion: @escaping (Result<[ApiHero], PIAApiError>) -> Void)
    
    func loadLocations(id: String, completion: @escaping (Result<[ApiLocation], PIAApiError>) -> Void)
    
    func loadTransformations(id: String, completion: @escaping (Result<[ApiTransformation], PIAApiError>) -> Void)
    
    func loginRequest(username: String, password: String, completion: @escaping ((Result<String, PIAApiError>) -> Void))
}


//Con ApiProvider vamos a realizar las peticiones de red
class PIAApiProvider: PIAApiProviderProtocol {
    
    private let session: URLSession //creamos la instancia de la URLSession
    private let requestBuilder: PIARequestBuilder
    
    //inicializador de ApiProvider
    init(session: URLSession = .shared, requestBuilder: PIARequestBuilder = PIARequestBuilder()) {
        self.session = session
        self.requestBuilder = requestBuilder
    }
    
    //MARK: - Métodos de ApiProvider:
    
    //MARK: makeRequest:
    
    //Hacemos un método que se encarga de gestionar los errores y los datos de las request para reutilizarlo en loadHerores, loadLocations, etc. Asi que en el result metemos un tipo genérico que añadimos a la función y al completion que nos sirva para herores, locations y transformations
    private func makeRequest<G: Decodable>(request: URLRequest, completion: @escaping ((Result<G, PIAApiError>) -> Void)) {
        session.dataTask(with: request) { data, response, error in //session hace sus casos en que recibe data, hay response del servidor y hay algun error.
            if let error { //si hay error:
                completion(.failure(.serverError(error: error))) //lanzamos un error controlado (personalizado) del servidor
                return //y return para que no se siga ejecutando código secuencialmente
            }
            let httpResponse = response as? HTTPURLResponse //Se instancia una HTTPURLResponse como httpResponse
            let statusCode = httpResponse?.statusCode //Se instancia un httpResponse?.statusCode como statusCode
            if statusCode != 200 { //Si statusCode no es igual a 200 (codigo de que todo ha ido OK):
                completion(.failure(.apiError(statusCode: statusCode ?? -1))) //lanzamos un error controlado (personalizado) de la Api con el valor del statusCode o -1 por defecto
                return //y return para que no se siga ejecutando código secuencialmente
            } else {
                guard let data else {
                    completion(.failure(.dataError))
                    return
                }
                if G.self == String.self {
                    if let token = String(data: data, encoding: .utf8) {
                        completion(.success(token as! G))
                    } else {
                        completion(.failure(.parsingDataError))
                    }
                    return
                }
                
                do {
                    let apiResponse = try JSONDecoder().decode(G.self, from: data) //se instancia una constante respuesta en la que se decodifica el JSON de la API de data
                    completion(.success(apiResponse)) //asi que se lanza success
                } catch {
                    completion(.failure(.parsingDataError)) //Se lanza error su falla el paso previo
                }
            }
        }.resume()
    }
    
    
    //IMPORTANTÍSIMO, SI NO SE INCLUYE ESTO NO SE LANZA LA PETICIÓN!
    
    //MARK: Métodos de recuperar información de la API:
    
    //cargar heroes:
    func loadHeroes(name: String = "", completion: @escaping (Result<[ApiHero], PIAApiError>) -> Void) { //al hacer una petición a la API, vamos a usar un requestBuilder al que le pasamos el endPoint propio de la lista de heroes y nos devuelve el url completo con el método buildRequest como una request
        do { //En este caso se buscan los heroes por nombre
            let request = try requestBuilder.buildRequest(endPoint: .heroes, params: ["name" : name]) //si hay request:
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error)) //fallo personalizado de request
        }
    }
    
    //cargar localizaciones:
    func loadLocations(id: String, completion: @escaping (Result<[ApiLocation], PIAApiError>) -> Void) { //al hacer una petición a la API, vamos a usar un requestBuilder al que le pasamos el endPoint propio de la lista de localizaciones y nos devuelve el url completo con el método buildRequest como una request
        do {
            let request = try requestBuilder.buildRequest(endPoint: .locations, params: ["id" : id]) //si hay request:
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error)) //fallo personalizado de request
        }
    }
    
    //cargar transformaciones:
    func loadTransformations(id: String, completion: @escaping (Result<[ApiTransformation], PIAApiError>) -> Void) { //al hacer una petición a la API, vamos a usar un requestBuilder al que le pasamos el endPoint propio de la lista de heroes y nos devuelve el url completo con el método buildRequest como una request
        do {
            let request = try requestBuilder.buildRequest(endPoint: .transformations, params: ["id" : id]) //si hay request:
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error)) //fallo personalizado de request
        }
    }
    
    //metodo de peticion de login para la Api
    func loginRequest(username: String, password: String, completion: @escaping ((Result<String, PIAApiError>) -> Void)) {
        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(PIAApiError.invalidCredentials))
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        
        do {
            var request = try requestBuilder.buildRequest(endPoint: .login, params: [:], requiredAuthorization: false)
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(PIAApiError.apiError(statusCode: 400))) // Error en la construcción de la petición
        }
    }
}

