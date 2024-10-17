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
    let token = "eyJhbGciOiJIUzI1NiIsImtpZCI6InByaXZhdGUiLCJ0eXAiOiJKV1QifQ.eyJleHBpcmF0aW9uIjo2NDA5MjIxMTIwMCwiaWRlbnRpZnkiOiIxRTgxNzY1OC02MkMyLTQ1RUItQTY1Mi03QTVCMTk0MUI5QUMiLCJlbWFpbCI6ImpvcmdlLmVzcGxpZWdvQGdtYWlsLmNvbSJ9.qSQDP5ha2aaLGDTPZcb1FfILwWpo7wCdHJ0iKmhvKN0"
    
    //creamos el método en el que vamos a asignar valor a los componentes de la url:
    private func url(endPoint: PIAEndPoint) -> URL? { //le pasamos el endPoint por parámetro para poder acceder a él
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.host
        components.path = endPoint.path()
        return components.url
    }
    
    //Este método nos va a establecer las cabeceras en función de lo que le pasemos (cabeceras como "Authorization")
    private func setHeaders(params: [String: String]?) { // params: [String: String] es el parámetro de las cabeceras
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if let params {
            request?.httpBody = try? JSONSerialization.data(withJSONObject: params)
            }
        request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

    
    func buildRequest(endPoint: PIAEndPoint, params: [String: String]) -> URLRequest? { //le pasamos el endPoint por parámetro para poder acceder a él
        guard let url = self.url(endPoint: endPoint)  else {
            return nil
        }
        request = URLRequest(url: url) //aquí se le asigna la URL completa de la request a request
        request?.httpMethod = endPoint.httpMethod() //Aqui se establece el metodo http (en este caso solo tenemos POST porque en nuestra API recuperar herores es POST
        setHeaders(params: params) //Le pasamos el header
        
        return request //Y se devuelve request
        
    }
}
