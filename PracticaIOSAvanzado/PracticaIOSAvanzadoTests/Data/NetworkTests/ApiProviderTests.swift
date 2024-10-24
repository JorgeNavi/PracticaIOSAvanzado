

import XCTest
@testable import PracticaIOSAvanzado

/// Clase de pruebas para `PIAApiProvider`. Se encarga de verificar la funcionalidad del proveedor de la API,
/// utilizando mocks para simular el entorno de red y almacenamiento seguro.
final class ApiProviderTests: XCTestCase {
    
    var sut: PIAApiProvider!

    override func setUpWithError() throws {
        // Configuramos el API Provider para las pruebas:
        // - Se utiliza una configuración de sesión `ephemeral` que no persiste datos en el disco.
        // - Se especifica que las respuestas serán manejadas por nuestro `URLProtocolMock`.
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: configuration)
        
        // Para la construcción de requests, se utiliza un mock de SecureDataStorage para simular la gestión de tokens.
        let requestProvider = PIARequestBuilder(secureStorage: SecureDataStorageMock())
        
        // Creamos el ApiProvider con la sesión configurada y el constructor de requests mock.
        sut = PIAApiProvider(session: session, requestBuilder: requestProvider)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Reset de los objetos y limpieza de datos mock para preparar el entorno para otras pruebas.
        SecureDataStorageMock().deleteToken()
        URLProtocolMock.handler = nil
        URLProtocolMock.error = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_loadHeros_shouldReturn_15_Heroes() throws {
        // Preparación de la información necesaria para el test
        let expectedToken = "Some Token"
        let expectedHero = try DataMock.mockHeroes().first!
        var heroesResponse = [ApiHero]()
        URLProtocolMock.handler = { request in
            // En el handler, validamos la request y configuramos la respuesta simulada.
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/all"))
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(expectedToken)")
            
            // Devolvemos Data y HTTPResponse del handler.
            let data = try DataMock.loadHeroesData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
           return  (data, response)
        }
        
        // Ejecución del método de la API y evaluación de resultados.
        let expectation = expectation(description: "Load Heroes")
        setToken(expectedToken)
        sut.loadHeroes { result in
            switch result {
            case .success(let apiheroes):
                heroesResponse = apiheroes
                expectation.fulfill()
            case .failure( _):
                XCTFail("Success expected")
            }
        }
        
        // Validación de los datos recibidos.
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(heroesResponse.count, 15)
        let heroReceived = heroesResponse.first
        XCTAssertEqual(heroReceived?.id, expectedHero.id)
        XCTAssertEqual(heroReceived?.name, expectedHero.name)
        XCTAssertEqual(heroReceived?.info, expectedHero.info)
        XCTAssertEqual(heroReceived?.favorite, expectedHero.favorite)
        XCTAssertEqual(heroReceived?.photo, expectedHero.photo)
        
    }
    
    func test_loadHerosError_shouldReturn_Error() throws {
        // Configuración de las condiciones de error para la prueba.
        let expectedToken = "Some Token"
        var error: PIAApiError?
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: 503)
        
        // Ejecución del método de la API esperando un error.
        let expectation = expectation(description: "Load Heroes Error")
        setToken(expectedToken)
        sut.loadHeroes { result in
            switch result {
            case .success( _):
                XCTFail("Error expected")
            case .failure(let receivedError):
                error = receivedError
                expectation.fulfill()
            }
        }

        // Validación del error recibido.
        wait(for: [expectation], timeout: 2)
        let receivedError = try XCTUnwrap(error)
        XCTAssertEqual(receivedError.description, "Server error: \(503)")
    }
    
    // Función auxiliar para establecer el token en el almacenamiento seguro simulado.
    func setToken(_ token: String) {
        SecureDataStorageMock().saveToken(token)
    }
}
