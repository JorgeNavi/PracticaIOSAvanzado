import XCTest

@testable import PracticaIOSAvanzado

final class DetailHeroUseCaseTests: XCTestCase {
    
    var sut: DetailHeroUseCase!
    var apiProvider: PIAApiProviderProtocol!
    var storeDataProvider: StoreDataProvider!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        apiProvider = PIAApiProviderMock()
        storeDataProvider = StoreDataProvider(persistency: .memory)
        sut = DetailHeroUseCase(apiProvider: PIAApiProviderMock(), storeDataProvider: storeDataProvider)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        apiProvider = nil
        storeDataProvider = nil
        try super.tearDownWithError()
    }
    
    func test_LoadLocations_ShouldReturn_HeroLocation() throws {
        let apiHero = DataMock.getHeroGoku()
        let expectedLocation = ApiLocation(id: "36E934EC-C786-4A8F-9C48-A6989BCA929E",
                                           date: "2024-10-20T00:00:00Z",
                                           latitude: "35.71867899343361",
                                           longitude: "139.8202084625344",
                                           hero: nil)
        storeDataProvider.add(heroes: [apiHero])
        let hero = try XCTUnwrap(storeDataProvider.fetchHeroes(filter: nil).first)
        XCTAssertTrue(hero.locations?.isEmpty == true)
        var receivedLocations: [Location]?
        
        let expectated = expectation(description: "Load locations")
        
        sut.loadLocationsForHeroWith(id: apiHero.id ?? "") { result in
            switch result {
            case .success(let locations):
                receivedLocations = locations
                expectated.fulfill()
            case .failure:
                XCTFail("Error")
            }
        }
        
        wait(for: [expectated], timeout: 1)
        
        XCTAssertEqual(receivedLocations?.count, 2)
        let location = hero.locations?.first(where: {$0.id == "36E934EC-C786-4A8F-9C48-A6989BCA929E"})
        XCTAssertEqual(location?.id, expectedLocation.id)
        XCTAssertEqual(location?.latitude, expectedLocation.latitude)
        XCTAssertEqual(location?.longitude, expectedLocation.longitude)
        XCTAssertEqual(location?.date, expectedLocation.date)
    }
    
    func test_LoadLocations_ShouldReturn_Error() throws {
        sut = DetailHeroUseCase(apiProvider: ApiProviderErrorMock(),
                                storeDataProvider: storeDataProvider)
        var error: PIAApiError?
        
        let expectated = expectation(description: "Load locations returns error")
        
        sut.loadLocationsForHeroWith(id: "id") { result in
            switch result {
            case .success( _):
                XCTFail("Expected Error")
            case .failure(let receivedError):
                error = receivedError
                expectated.fulfill()
            }
        }
        
        wait(for: [expectated], timeout: 1)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.description, "Hero id not found")
    }
    
    func test_LoadTransformations_ShouldReturn_HeroTransformation() throws {
        let apiHero = DataMock.getHeroGoku() //establecemos un heroe fijo que sepamos que tiene transformaciones
        let expectedTransformation = ApiTransformation(id: "17824501-1106-4815-BC7A-BFDCCEE43CC9",
                                                       name: "1. Oozaru – Gran Mono",
                                                       photo: "https://areajugones.sport.es/wp-content/uploads/2021/05/ozarru.jpg.webp",
                                                       info: "Cómo todos los Saiyans con cola, Goku es capaz de convertirse en un mono gigante si mira fijamente a la luna llena. Así es como Goku cuando era un infante liberaba todo su potencial a cambio de perder todo el raciocinio y transformarse en una auténtica bestia. Es por ello que sus amigos optan por cortarle la cola para que no ocurran desgracias, ya que Goku mató a su propio abuelo adoptivo Son Gohan estando en este estado. Después de beber el Agua Ultra Divina, Goku liberó todo su potencial sin necesidad de volver a convertirse en Oozaru",
                                                       hero: nil) //nos mockeamos aqui mismo una transformacion que podamos comparar de forma facil
        

        storeDataProvider.add(heroes: [apiHero]) //añadimos el heroe a la BBDD
        let hero = try XCTUnwrap(storeDataProvider.fetchHeroes(filter: nil).first) //lo desempaquetamos
        XCTAssertTrue(hero.transformations?.isEmpty == true) //Corroboramos que no hay transformaciones en la BBDD
        var receivedTransformations: [Transformation]? //variable para las transformaciones que vamos a recibir
        
        let expectated = expectation(description: "Load transformations")
        
        sut.loadTransformationsForHeroWith(id: apiHero.id ?? "") { result in //llamamos al metodo del useCase
            switch result {
            case .success(let transformations): //si hay transformaciones
                receivedTransformations = transformations //las añadimos a la variable
                expectated.fulfill()
            case .failure: //controlamos el error
                XCTFail("Error")
            }
        }
        
        wait(for: [expectated], timeout: 1)
        
        XCTAssertEqual(receivedTransformations?.count, 15) //comprobamos que nos han llegado las 15 transformaciones del json
        let transformation = hero.transformations?.first(where: {$0.id == "17824501-1106-4815-BC7A-BFDCCEE43CC9"}) //establecemos el id de la transfromacion que hemos mockeado arriba para hacer las comparaciones de lo que tenemos y lo que nos llega en condiciones
        //hacemos las equiparaciones
        XCTAssertEqual(transformation?.id, expectedTransformation.id)
        XCTAssertEqual(transformation?.name, expectedTransformation.name)
        XCTAssertEqual(transformation?.info, expectedTransformation.info)
        XCTAssertEqual(transformation?.photo, expectedTransformation.photo)
    }
    
    func test_LoadTransformations_ShouldReturn_Error() throws {
        sut = DetailHeroUseCase(apiProvider: ApiProviderErrorMock(),
                                storeDataProvider: storeDataProvider)
        var error: PIAApiError?
        
        let expectated = expectation(description: "Load transformations returns error")
        
        sut.loadTransformationsForHeroWith(id: "id") { result in
            switch result {
            case .success( _):
                XCTFail("Expected Error")
            case .failure(let receivedError):
                error = receivedError
                expectated.fulfill()
            }
        }
        
        wait(for: [expectated], timeout: 1)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.description, "Hero id not found")
    }
}
