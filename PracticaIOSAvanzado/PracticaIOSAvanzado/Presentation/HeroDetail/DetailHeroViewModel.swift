
import UIKit
import MapKit

enum statusDetailHero {
    
    case locationUpdated
    case error(reason: String)
    case none
}


class DetailHeroViewModel {
    
    private let hero: Hero
    private var heroLocations: [Location] = []
    private var useCase: DetailHeroUseCaseProtocol
    var status: PIAObservable<statusDetailHero> = PIAObservable(.none)
    
    var annotations: [HeroAnnotation] = []
    
    init(hero: Hero, useCase: DetailHeroUseCaseProtocol = DetailHeroUseCase()) {
        self.useCase = useCase
        self.hero = hero
    }
    
    func loadData() {
        loadLocations()
    }
    
    //recibimos las localizaciones:
    private func loadLocations() {
        useCase.loadLocationsForHeroWith(id: hero.id) {[weak self] result in
            switch result {
            case .success(let locations):
                self?.heroLocations = locations
                self?.createAnnotations()
            case .failure(let error):
                self?.status.value = .error(reason: error.description)
            
            }
        }
    }
    
    //Una vez recibidas las localizaciones, vamos a crear nuestras anotaciones:
    private func createAnnotations() {
        self.annotations = []
        heroLocations.forEach {[weak self] location in
            guard let coordinate = location.coordinate else { //primero comprobamos la coordenada que habiamos creado en la extensión
                return
            }
            let annotation = HeroAnnotation(title: self?.hero.name, coordinate: coordinate)
            self?.annotations.append(annotation)
        }
        self.status.value = .locationUpdated
    }
}
