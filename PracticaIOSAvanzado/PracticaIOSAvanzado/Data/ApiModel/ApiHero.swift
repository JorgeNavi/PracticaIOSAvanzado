//
//  ApiHero.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 15/10/24.
//

//creamos el modelo de Hero de la API
struct ApiHero: Codable {
    
    let id: String?
    let name: String?
    let info: String?
    let photo: String?
    let favorite: Bool?
    
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case info = "description"
        case photo
        case favorite
    }
}

