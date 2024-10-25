//
//  Untitled.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//
import Foundation

//Generamos un enum de endPoints para establecer los endPoints de nuestra API. Los endPoints son URL específicas dentro de una API que se utilizan para acceder a un recurso o realizar una operación. Por ejemplo, la URL donde se recibe la lista de Heroes
enum PIAEndPoint {
    case heroes
    case locations
    case transformations
    case login
    
    //En este método, se establece la URL que nos da la API en los distintos endPoints para poder informar de las mismas como path
    func path() -> String {
        switch self {
        case .heroes:
            return "/api/heros/all"
        case .locations:
            return "/api/heros/locations"
        case .transformations:
            return "/api/heros/tranformations"
        case .login:
            return "/api/auth/login"
        }
    }
    
    func httpMethod() -> String {
        switch self {
        case .heroes, .locations, .transformations, .login:
            "POST"
        }
    }
}
