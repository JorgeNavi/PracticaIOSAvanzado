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
            apiProvider.loadHeroes(name: "") { [weak self] result in //se cargan los herores de la API
                switch result {
                case .success(let apiHeroes): //si se cargan satisfactoriamente:
                    self?.storeDataProvider.add(heroes: apiHeroes) //se añaden a la BBDD los heroes de la API
                    let localHeroes = self?.storeDataProvider.fetchHeroes(filter: filter) //En una constante localHeroes se recuperan los herores de la BBDD con el filtro
                    let heroes = localHeroes.map({Hero(moHero: $0)}) //en una constante heroes se mapean los heroes al tipo MOHero
                    completion(.success(heroes)) //y se devuelven los heroes
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            let heroes = localHeroes.map({Hero(moHero: $0)})
            completion(.success(heroes))
        }
    }
}
