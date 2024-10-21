//
//  PIAApiError.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//

import Foundation


//Generamos un enum de errores personalizados:
enum PIAApiError: Error, CustomStringConvertible { //CustomStringConvertible junto con la variable que obliga a implementar, description, podemos personalizar el mensaje de error
    
    var description: String { //le otorga valor a description segun el error
        switch self {
            case .invalidRequest:
            return "Invalid request"
        case .ServerError(error: let error):
            return "Server error: \((error as NSError).code)" //nos permite imprimir el codigo de error que ha recibido
        case .ApiError(statusCode: let statusCode):
            return "API error: \(statusCode)"
        case .dataError:
            return "Data error"
        case .parsingDataError:
            return "Parsing data error"
        case .sessionTokenMissing:
            return "Session token missing"
        case .URLMalFormed:
            return "URL malformed"
        }
    }
    
    case invalidRequest
    case ServerError(error: Error)
    case ApiError(statusCode: Int)
    case dataError
    case parsingDataError
    case sessionTokenMissing
    case URLMalFormed
}

