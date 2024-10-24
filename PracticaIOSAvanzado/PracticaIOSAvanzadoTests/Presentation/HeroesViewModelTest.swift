
import XCTest
@testable import PracticaIOSAvanzado

// Mock para simular el comportamiento del caso de uso cuando se recuperan los héroes correctamente.
class HeroUseCaseMock: HeroUseCaseProtocol {
    func loadHeroes(filter: NSPredicate?, completion: @escaping ((Result<[Hero], PIAApiError>) -> Void)) {
        // Intenta convertir los héroes mockeados a su representación de dominio y maneja el caso de error implícitamente.
        let heroes = try? DataMock.mockHeroes().map({$0.mapToHero()})
        completion(.success(heroes ?? []))
    }
}

// Mock para simular el comportamiento del caso de uso cuando hay un error al recuperar héroes.
class HeroUseCaseErrorMock: HeroUseCaseProtocol {
    func loadHeroes(filter: NSPredicate?, completion: @escaping ((Result<[Hero], PIAApiError>) -> Void)) {
        // Devuelve directamente un fallo con un error específico.
        completion(.failure(.dataError))
    }
}

final class HeroesViewModelTests: XCTestCase {
    
    var sut: HeroesViewModel!  // System Under Test (SUT)

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Inicializa el ViewModel con un mock que simula la carga exitosa de héroes.
        sut = HeroesViewModel(useCase: HeroUseCaseMock())
    }

    override func tearDownWithError() throws {
        // Limpieza de recursos.
        sut = nil
        try super.tearDownWithError()
    }
    
    // Prueba que verifica que el ViewModel carga y retorna el número esperado de héroes.
    func testLoad_Should_Return_Heroes() {
        var heroes: [Hero]?
        let expectedCountHeroes = 15  // Número esperado de héroes a cargar.
        
        let expectation = expectation(description: "Load heroes")
        sut.statusHeroes.bind {[weak self] status in
            switch status {
            case .dataUpdated:
                // Carga exitosa, recuperar héroes del ViewModel.
                heroes = self?.sut.heroes
                expectation.fulfill()
            case .error(reason: _):
                XCTFail("Expected success")
            case .none:
                break
            }
        }
        // Solicitar la carga de datos.
        sut.loadData(filter: nil)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(heroes?.count, expectedCountHeroes)
    }
    
    // Prueba que verifica el manejo correcto de errores en el ViewModel.
    func testLoad_Should_Return_Error() {
        sut = HeroesViewModel(useCase: HeroUseCaseErrorMock())  // Utilizar mock que simula un error.
        var msgError: String?
        
        let expectation = expectation(description: "Load Heroes should return error")
        sut.statusHeroes.bind { status in
            switch status {
            case .dataUpdated:
                XCTFail("Expected Error")
            case .error(reason: let msg):
                // Captura el mensaje de error para verificarlo.
                msgError = msg
                expectation.fulfill()
            case .none:
                break
            }
        }
        // Solicitar la carga de datos esperando un error.
        sut.loadData(filter: nil)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(msgError, "Data error")  // Verificar que el mensaje de error sea el esperado.
    }
    
    // Prueba la función que recupera un héroe por índice.
    func test_HeroATIndex() {
        var hero: Hero?
        
        let expectation = expectation(description: "Load hero at index")
        sut.statusHeroes.bind { status in
            switch status {
            case .dataUpdated:
                // Datos cargados, proceder a probar la recuperación por índice.
                expectation.fulfill()
            case .error(reason: _):
                XCTFail("Expected success")
            case .none:
                break
            }
        }
        // Cargar datos para hacer posible la prueba de índices.
        sut.loadData(filter: nil)
        
        wait(for: [expectation], timeout: 1)
        
        // Verificar la correcta recuperación del primer héroe y un índice fuera de límites.
        hero = sut.heroAt(index: 0)
        XCTAssertNotNil(hero)
        XCTAssertEqual(hero?.name, "Maestro Roshi")
        
        hero = sut.heroAt(index: 30)  // Índice que excede la cantidad de héroes cargados.
        XCTAssertNil(hero)  // Debería ser nil porque el índice es inválido.
    }
}

extension ApiHero {
    // Método para mapear de la estructura de la API al dominio utilizado por la app.
    func mapToHero() -> Hero {
        Hero(id: self.id ?? "",
             name: self.name ?? "",
             info: self.info ?? "",
             photo: self.photo ?? "",
             favorite: self.favorite ?? false)
    }
}
