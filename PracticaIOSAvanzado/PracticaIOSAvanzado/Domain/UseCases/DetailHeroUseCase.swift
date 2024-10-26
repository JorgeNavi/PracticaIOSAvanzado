

import Foundation


protocol DetailHeroUseCaseProtocol {
    
    func loadLocationsForHeroWith(id: String, completion: @escaping ((Result<[Location], PIAApiError>) -> Void))
    func loadTransformationsForHeroWith(id: String, completion: @escaping ((Result<[Transformation], PIAApiError>) -> Void))
}


class DetailHeroUseCase: DetailHeroUseCaseProtocol {
    
    private var apiProvider: PIAApiProviderProtocol
    private var storeDataProvider: StoreDataProvider
    
    //Les damos de valor por defecto nuestro PIAApiProvider y nuestro singleton
    init (apiProvider: PIAApiProviderProtocol = PIAApiProvider(), storeDataProvider: StoreDataProvider = .shared) {
        self.apiProvider = apiProvider
        self.storeDataProvider = storeDataProvider
    }
    
    //Necesitamos obtener el heroe de la BBDD
    //Con el heroe comprobamos si tiene localizaciones
    //si las tiene, las devolvemos
    //Si no las tiene llamamos a la API, insertamos en BBDD y las devolvemos
    func loadLocationsForHeroWith(id: String, completion: @escaping ((Result<[Location], PIAApiError>) -> Void)) {
        guard let hero = self.getHeroWith(id: id) else { //el id del parámetro de getHeroWith será el mismo id del parámetro de loadLocationsForHeroWith
            completion(.failure(.heroNotFound(idHero: id))) //se devuelve en el else, en caso de que no se encuentre el hero
            return
        }
        let dbLocations = hero.locations ?? [] //Esto nos devuelve un Set<MOLocation>?. Un Set es como un Array pero con funcionalidad especial, por ejemplo, no permite dos objetos iguales. //se le añade a dbLocations las localiozaciones del hero recibido con getHeroWith
        if dbLocations.isEmpty { //Si el heroe no tiene localizaciones:
            apiProvider.loadLocations(id: id) {[weak self] result in //se hace una peticion a la API de las localizaciones
                switch result {
                case .success(let locations): //si se tiene exito en la peticion:
                    self?.storeDataProvider.add(locations: locations) //se almacenan en la BBDD
                    let dbLocations = hero.locations ?? [] //dbLocations equivale a las localizaciones del heroe que se ha recuperado
                    let localLocations = dbLocations.map({Location(moLocation: $0)}) //se mapean las localizaciones de la BBDD al modelo de datos de la app (del Domain)
                    completion(.success(localLocations)) //se devuelve un resultado de exito con las localizaciones del domain
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else { //si el heroe tiene localizaciones:
            let localLocations = dbLocations.map({Location(moLocation: $0)}) //se mapean las localizaciones de la BBDD al modelo de datos de la app (del Domain)
            completion(.success(localLocations))
        }
    }
    //Necesitamos obtener el heroe de la BBDD
    //Con el heroe comprobamos si tiene transformaciones
    //si las tiene, las devolvemos
    //Si no las tiene llamamos a la API, insertamos en BBDD y las devolvemos
    func loadTransformationsForHeroWith(id: String, completion: @escaping ((Result<[Transformation], PIAApiError>) -> Void)) {
        guard let hero = getHeroWith(id: id) else {
            completion(.failure(.heroNotFound(idHero: id)))
            return
        }
        let dbTransformations = hero.transformations ?? []
        if dbTransformations.isEmpty {
            apiProvider.loadTransformations(id: id) {[weak self] result in
                switch result {
                case .success(let transformations):
                    self?.storeDataProvider.add(transformations: transformations)
                    let dbTransformations = hero.transformations ?? []
                    let localTransformations = dbTransformations.map({Transformation(moTransformation: $0)})
                    completion(.success(localTransformations))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            let localTransformations = dbTransformations.map({Transformation(moTransformation: $0)})
            completion(.success(localTransformations))
        }
    }
    
    
    //Vamos a establecer un método que nos devuelva un heroe a través de su id:
    private func getHeroWith(id: String) -> MOHero? {
        let predicate = NSPredicate(format: "id == %@", id) //establecemos el filtro de búsqueda por id
        let hero = storeDataProvider.fetchHeroes(filter: predicate) //Se recuperan los heroes de la BBDD con el filtro de búsqueda
        return hero.first //se devuelve el primero que nos proporciona que equivalga con el id que se le manda en el parámetro
    }
}
