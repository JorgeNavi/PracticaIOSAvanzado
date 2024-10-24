//
//  Hero.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//

import Foundation

//el modelo de la app
struct Hero: Hashable
{
    let id: String
    let name: String
    let info: String
    let photo: String
    let favorite: Bool
    
    
    init(moHero: MOHero) {  //se incicializan (o crean) pasandoles un modelo de la BBDD
        self.id = moHero.id ?? ""
        self.name = moHero.name ?? ""
        self.info = moHero.info ?? ""
        self.photo = moHero.photo ?? ""
        self.favorite = moHero.favorite
    }
}
