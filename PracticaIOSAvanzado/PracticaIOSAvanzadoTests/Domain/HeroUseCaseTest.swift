
import XCTest
@testable import PracticaIOSAvanzado

final class HeroesUseCaseTests: XCTestCase {
    
    var sut: HeroUseCase!  // System Under Test (SUT), el caso de uso de héroes que estamos probando.
    var storeDataProvider: StoreDataProvider!  // Proveedor de datos de la tienda para pruebas de persistencia.
    
    override func setUpWithError() throws {
        // Configuración inicial para cada prueba; configuramos un storeDataProvider y nuestro caso de uso con un mock.
        try super.setUpWithError()
        storeDataProvider = StoreDataProvider(persistency: .memory)  // Uso de memoria como backend para evitar persistencia real.
        sut = HeroUseCase(apiProvider: PIAApiProviderMock(), storeDataProvider: storeDataProvider)  // Inicialización del SUT con un proveedor de API mock.
    }

    override func tearDownWithError() throws {
        // Limpieza después de cada prueba para evitar efectos secundarios.
        storeDataProvider = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_LoadHeroes_ShouldReturnHeroes() {
        // Dado que se esperan héroes mockeados como salida del caso de uso.
        let expectedHeroes = try? DataMock.mockHeroes()  // Carga héroes mockeados esperados para comparación.
        var receivedHeroes: [Hero]?  // Almacenará los héroes recibidos del caso de uso.
        
        // Cuando se carga héroes a través del caso de uso.
        let expectation = expectation(description: "Load heroes")  // Expectativa para asincronía.
        sut.loadHeroes { result in
            switch result {
            case .success(let heroes):
                receivedHeroes = heroes  // Guarda los héroes recibidos en caso de éxito.
                expectation.fulfill()  // Cumple la expectativa si se reciben datos.
            case .failure(_):
                XCTFail("Expected succes")  // Falla la prueba si se recibe un error.
            }
        }
        
        // Entonces, deberíamos recibir los héroes y coincidir con los esperados.
        wait(for: [expectation], timeout: 1)  // Espera a que la expectativa se cumpla.
        XCTAssertNotNil(receivedHeroes)  // Asegura que los héroes no son nulos.
        XCTAssertEqual(receivedHeroes?.count, expectedHeroes?.count)  // Verifica que la cantidad de héroes recibidos sea la esperada.
        let bdHeroes = storeDataProvider.fetchHeroes(filter: nil)  // Recupera héroes de la base de datos para verificación adicional.
        XCTAssertEqual(receivedHeroes?.count, bdHeroes.count)  // Asegura que la cantidad coincide con la base de datos.
    }
    
    func test_LoadHeroes_Error_ShouldREturnError() {
        // Dado que se ha configurado el caso de uso para fallar.
        sut = HeroUseCase(apiProvider: ApiProviderErrorMock(), storeDataProvider: storeDataProvider)  // Configuración con un mock que siempre falla.
        var error: PIAApiError?  // Variable para capturar el error recibido.
        
        // Cuando se intenta cargar héroes y se espera un error.
        let expectation = expectation(description: "Load heroes return error")
        sut.loadHeroes { result in
            switch result {
            case .success(_):
                XCTFail("Expected error")  // La prueba debe fallar si se reciben héroes.
            case .failure(let errorReceived):
                error = errorReceived  // Guarda el error recibido en caso de fallo.
                expectation.fulfill()  // Cumple la expectativa al recibir un error.
            }
        }
        
        // Entonces, deberíamos haber capturado un error específico.
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(error)  // Asegura que realmente se recibió un error.
        XCTAssertEqual(error?.description, "Data error")  // Verifica que el mensaje de error sea el esperado.
    }
    
    func test_LoadHeroes_SuldReturn_DataFiltered() {
        // Dado que esperamos recibir héroes filtrados por nombre.
        let expectedHeros = 2  // Número esperado de héroes que contienen 'g' en su nombre.
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", "g")  // Filtro para aplicar en la carga de héroes.
        var receivedHeroes: [Hero]?  // Almacenará los héroes recibidos del caso de uso.
        
        // Cuando se carga héroes con filtro.
        let expectation = expectation(description: "Load heroes filtered with 'g' in his name")
        sut.loadHeroes(filter: predicate) { result in
            switch result {
            case .success(let heroes):
                receivedHeroes = heroes  // Guarda los héroes recibidos en caso de éxito.
                expectation.fulfill()  // Cumple la expectativa al recibir datos.
            case .failure(_):
                XCTFail("Expected succes")  // Falla la prueba si se recibe un error.
            }
        }
        
        // Entonces, deberíamos recibir exactamente el número esperado de héroes filtrados.
        wait(for: [expectation], timeout: 0.1)  // Tiempo de espera corto ya que es una operación de memoria.
        XCTAssertEqual(receivedHeroes?.count, expectedHeros)  // Verifica que la cantidad de héroes recibidos sea la esperada.
    }
}
