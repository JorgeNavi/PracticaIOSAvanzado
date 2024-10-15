//
//  ApiTransformation.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 15/10/24.
//

struct ApiTransformation: Codable {
    let id: String?
    let name: String?
    let photo: String?
    let description: String?
    let hero: ApiHero?
    
}




//Copiamos el JSON de las transformaiones de Postman para que nos sirva de referencia en los atributos:
/*
 "name": "1. Oozaru – Gran Mono",
 "id": "17824501-1106-4815-BC7A-BFDCCEE43CC9",
 "photo": "https://areajugones.sport.es/wp-content/uploads/2021/05/ozarru.jpg.webp",
 "hero": {
 "id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
 },
 "description": "Cómo todos los Saiyans con cola, Goku es capaz de convertirse en un mono gigante si mira fijamente a la luna llena. Así es como Goku cuando era un infante liberaba todo su potencial a cambio de perder todo el raciocinio y transformarse en una auténtica bestia. Es por ello que sus amigos optan por cortarle la cola para que no ocurran desgracias, ya que Goku mató a su propio abuelo adoptivo Son Gohan estando en este estado. Después de beber el Agua Ultra Divina, Goku liberó todo su potencial sin necesidad de volver a convertirse en Oozaru"
 */
