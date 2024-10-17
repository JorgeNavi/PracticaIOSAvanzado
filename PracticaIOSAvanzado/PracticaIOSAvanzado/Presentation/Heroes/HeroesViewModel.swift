//
//  HeroesViewModel.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//
import UIKit

enum statusHeroes {
    case dataUpdated
    case error(reason: String)
    case none
}

class HeroesViewModel {
    
    let useCase: HeroUseCaseProtocol
    
    //vamos a usar el observable y el jaleo de la variable privada y publica para establecer el status del viewModel:
    var statusHeroes: PIAObservable<statusHeroes> = PIAObservable(.none)
    var heroes: [Hero] = []
    
    
    init(useCase: HeroUseCaseProtocol = HeroUseCase()) {
        self.useCase = useCase
    }
    
    func loadData(filter: String?) {
        var predicate: NSPredicate?
        if let filter {
            predicate = NSPredicate(format: "name CONTAINS[cd] %@", filter) //// El modificador [cd] es c -> Para ignorar mayúsuclas o minúsculas, d -> Ignorar signos de puntuación como acentos. El contains funciona como un "like" de SQL, es decir, el filtro busca por nombre similar a los registros de la BBDD ignorando mayusculas y caracteres raros
        }
        useCase.loadHeroes(filter: predicate) { [weak self] result in
            switch result {
            case .success(let heroes):
                self?.heroes = heroes
                self?.statusHeroes.value = .dataUpdated //al informarle aquí del value, se le va a asignar este nuevo valor a la clave privada y notificamos ese nuevo valor con valueChanged?(_value)
            case .failure(let error):
                self?.statusHeroes.value = .error(reason: error.description) //al informarle aquí del value, se le va a asignar este nuevo valor a la clave privada y notificamos ese nuevo valor con valueChanged?(_value)
            }
        }
    }
    
    //establecemos una función que nos devuelve un héroe para la celda:
    func heroAt(index: Int) -> Hero? {
        guard index < heroes.count else { //si el índice es menos que el número de heroes total:
            return nil //si no, devuelve nil porque estaría devolviendo un objeto
        }
        return heroes[index] //devuelveme ese heroe del indice
    }
}
