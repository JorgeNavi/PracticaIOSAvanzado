//
//  HeroesViewModel.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//

class HeroesViewModel {
    
    let useCase: HeroUseCaseProtocol
    
    init(useCase: HeroUseCaseProtocol = HeroUseCase()) {
        self.useCase = useCase
    }
}
