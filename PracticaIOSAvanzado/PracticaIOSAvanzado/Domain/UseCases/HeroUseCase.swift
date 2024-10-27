//
//  HeroUsecase.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//
import Foundation

protocol HeroUseCaseProtocol {
    
    func loadHeroes(filter: NSPredicate?, completion: @escaping ((Result<[Hero], PIAApiError>) -> Void))
    
}

class HeroUseCase: HeroUseCaseProtocol {
    
    private var apiProvider: PIAApiProviderProtocol
    private var storeDataProvider: StoreDataProvider
    
    init (apiProvider: PIAApiProviderProtocol = PIAApiProvider(), storeDataProvider: StoreDataProvider = .shared) {
        self.apiProvider = apiProvider
        self.storeDataProvider = storeDataProvider
    }
    
    func loadHeroes(filter: NSPredicate? = nil, completion: @escaping ((Result<[Hero], PIAApiError>) -> Void)) {

        let localHeroes = storeDataProvider.fetchHeroes(filter: filter) //Esto va a cargar los heroes que tengamos en BBDD
        
        if localHeroes.isEmpty { //Si no hay heroes en base de datos:
            apiProvider.loadHeroes(name: "") { [weak self] result in //se hace una peticion de los herores a la API
                switch result {
                case .success(let apiHeroes): //si se cargan satisfactoriamente:
                    DispatchQueue.main.async { //Volvemos al hilo principal IMPORTANTE
                        self?.storeDataProvider.add(heroes: apiHeroes) //se añaden a la BBDD los heroes de la API con el metodo del storeDataProvider
                        let dbHeroes = self?.storeDataProvider.fetchHeroes(filter: filter) ?? [] //En una constante localHeroes se recuperan los herores de la BBDD con el filtro
                        let heroes = dbHeroes.map({Hero(moHero: $0)}) //en una constante heroes se mapean los heroes desde el tipo MOHero al tipo del modelo de la app (del Domain)
                        completion(.success(heroes)) //y se devuelven los heroes para ser mostrados en la capa de presentación
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else { //Si localHeroes no está vacio
            let heroes = localHeroes.map({Hero(moHero: $0)}) //en una constante heroes se mapean los heroes desde el tipo MOHero al tipo del modelo de la app (del Domain)
            completion(.success(heroes)) //y se devuelven los heroes para ser mostrados en la capa de presentación
        }
    }
}
