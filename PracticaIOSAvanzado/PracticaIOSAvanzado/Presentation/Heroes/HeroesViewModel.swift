//
//  HeroesViewModel.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//
import UIKit

class HeroesViewModel {
    
    let useCase: HeroUseCaseProtocol
    
    init(useCase: HeroUseCaseProtocol = HeroUseCase()) {
        self.useCase = useCase
    }
    
    func loadData(filter: String?) {
        var predicate: NSPredicate?
        if let filter {
            predicate = NSPredicate(format: "name CONTAINS[cd] %@", filter) //// El modificador [cd] es c -> Para ignorar mayúsuclas o minúsculas, d -> Ignorar signos de puntuación como acentos. El contains funciona como un "like" de SQL, es decir, el filtro busca por nombre similar a los registros de la BBDD ignorando mayusculas y caracteres raros
        }
        useCase.loadHeroes(filter: predicate) { result in
            switch result {
            case .success(let heroes):
                debugPrint(heroes)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
