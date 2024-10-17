//
//  Hero.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//

import Foundation

//el modelo de la app
struct Hero: Hashable {
    let id: String
    let name: String
    let photo: String
    let favorite: Bool
    
    
    init(moHero: MOHero) {
        self.id = moHero.id ?? ""
        self.name = moHero.name ?? ""
        self.photo = moHero.photo ?? ""
        self.favorite = moHero.favorite
    }
}
