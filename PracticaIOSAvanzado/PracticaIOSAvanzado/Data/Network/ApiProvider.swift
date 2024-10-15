//
//  ApiProvider.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 15/10/24.
//

import Foundation


//Generamos un enum de errores personalizados:
enum ApiError: Error {
    case invalidRequest
}

//Generamos un enum de endPoints para establecer los endPoints de nuestra API. Los endPoints son URL específicas dentro de una API que se utilizan para acceder a un recurso o realizar una operación. Por ejemplo, la URL donde se recibe la lista de Heroes
enum Endpoint {
    case heroes
    
    //En este método, se establece la URL que nos da la API en los distintos endPoints para poder informar de las mismas como path
    func path() -> String {
        switch self {
        case .heroes:
            return "/api/heros/all"
        }
    }
}


//creamos un builder que nos construya las request:
class RequestBuilder {
    
    //creamos una constante a la que le asignamos el valor del host de la url (del server). En nuestro caso, la API de DB
    private let host = "dragonball.keepcoding.education"
    //creamos una variable para nuestra URLRequest
    private var request: URLRequest?
    let token = ""
    
    //creamos el método en el que vamos a asignar valor a los componentes de la url:
    private func url(endPoint: Endpoint) -> URL? { //le pasamos el endPoint por parámetro para poder acceder a él
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = endPoint.path()
        return components.url
    }
    
    //Este método nos va a establecer las cabeceras en función de lo que le pasemos (cabeceras como "Authorization")
    private func setHeaders(params: [String: String]) {
        
    }
    
    func buildRequest(endPoint: Endpoint, params: [String: String]) -> URLRequest? { //le pasamos el endPoint por parámetro para poder acceder a él
        guard let url = self.url(endPoint: endPoint)  else {
            return nil
        }
        request = URLRequest(url: url) //aquí se le asigna la URL completa de la request a request
        return request //se devuelve request
        
    }
}


//Con ApiProvider vamos a realizar las peticiones de red
class ApiProvider {
    
    private let session: URLSession //creamos la instancia de la URLSession
    private let requestBuilder: RequestBuilder
    
    //inicializador de ApiProvider
    init(session: URLSession = .shared, requestBuilder: RequestBuilder = RequestBuilder()) {
        self.session = session
        self.requestBuilder = requestBuilder
    }
    
    //MARK: - Métodos de ApiProvider:
    
    //cargar herores:
    func loadHeroes(name: String = "", completion: @escaping (Result<[ApiHero], ApiError>) -> Void) { //al hacer una petición a la API, vamos a usar un requestBuilder al que le pasamos el endPoint propio de la lista de heroes y nos devuelve el url completo con el método buildRequest como una request
        if let request = requestBuilder.buildRequest(endPoint: .heroes, params: ["name" : name]) { //si hay request:
            session.dataTask(with: request) { data, response, error in //session hace sus cosas
                //
            }
        } else { //si no hay request
            completion(.failure(.invalidRequest)) //fallo personalizado de request
        }
        
    }
    
    
}
