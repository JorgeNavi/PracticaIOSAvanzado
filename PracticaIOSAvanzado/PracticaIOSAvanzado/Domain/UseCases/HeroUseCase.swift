//
//  HeroUsecase.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//

protocol HeroUseCaseProtocol {
    
    func loadHeroes(filter: String?, completion: ((Result<Hero, PIAApiError>) -> Void))
    
}

class HeroUseCase: HeroUseCaseProtocol {
    
    func loadHeroes(filter: String? = nil, completion: ((Result<Hero, PIAApiError>) -> Void)) {
        
    }
}
