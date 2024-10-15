//
//  ApiLocation.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 15/10/24.
//


//Creamos el modelo de Location de la API
struct ApiLocation: Codable {
    let id: String?
    let date: String?
    let latitude: String?
    let longitude: String?
    let hero: ApiHero? //Las localizaciones de la API están ligadas a un heroe, por tanto tiene que tener un atributo hero que sea del tipo de heroe de la API
    
    
    //vamos a hacer uso de CodingKey para que los nombres de nuestros atributos y los de la API en Postman no entren en conflicto:
    enum CodingKeys: String, CodingKey {
        //Solo lo especificamos en aquellos casos que sea necesario
        case id
        case date = "dateShow"
        case latitude = "latitud"
        case longitude = "longitud"
        case hero
    }
    
    //Copiamos el JSON de las localizaciones de Postman para que nos sirva de referencia en el CodingKey:
    /*
           "id": "B93A51C8-C92C-44AE-B1D1-9AFE9BA0BCCC",
           "latitud": "35.71867899343361",
           "dateShow": "2022-02-20T00:00:00Z",
           "hero": {
               "id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
           },
           "longitud": "139.8202084625344"
     */
}
