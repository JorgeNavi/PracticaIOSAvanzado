

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
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/all"))
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(expectedToken)")
            
            // Devolvemos Data y HTTPResponse del handler.
            let data = try DataMock.loadHeroesData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
           return  (data, response)
        }
        
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

        let expectedToken = "Token"
        var error: PIAApiError?
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: 503)

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

        wait(for: [expectation], timeout: 2)
        let receivedError = try XCTUnwrap(error)
        XCTAssertEqual(receivedError.description, "Server error: \(503)")
    }
    
    func test_loadTransformations_shouldReturn_Transformations() throws {
        // Given
        let expectedToken = "Token"
        let expectedTransformation = try DataMock.mockTransformations().first!
        var transformationsResponse = [ApiTransformation]()
        
        URLProtocolMock.handler = { request in
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/tranformations"))
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(expectedToken)")
            
    
            let data = try DataMock.loadTransformationsData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (data, response)
        }
        
        // When
        let expectation = expectation(description: "Load Transformations")
        setToken(expectedToken)
        sut.loadTransformations(id: "1") { result in
            switch result {
            case .success(let transformations):
                transformationsResponse = transformations
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(transformationsResponse.count, 15)
        XCTAssertEqual(transformationsResponse.first?.id, expectedTransformation.id)
    }
    
    func test_loadTransformationsError_shouldReturn_Error() throws {
        // Given
        let expectedToken = "Token"
        var error: PIAApiError?
        
        // En el handler, validamos la request y configuramos la respuesta simulada.
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: -3)
        
        // When
        let expectation = expectation(description: "Load Transformations Error")
        setToken(expectedToken)
        sut.loadTransformations(id: "1") { result in
            switch result {
            case .success(_):
                XCTFail("Error expected")
            case .failure(let receivedError):
                error = receivedError
                expectation.fulfill()
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(error?.description, "Server error: \(-3)")
    }
    
    func test_loadLocations_shouldReturn_Locations() throws {
        // Given
        let expectedToken = "Token"
        let expectedLocation = try DataMock.mockLocations().first!
        var locationsResponse = [ApiLocation]()
        
        // En el handler, validamos la request y configuramos la respuesta simulada.
        URLProtocolMock.handler = { request in
            // Validación de la request generada por la app
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/locations"))
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(expectedToken)")
            
            // Respuesta simulada con datos de ubicaciones mock
            let data = try DataMock.loadLocationsData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (data, response)
        }
        
        // When
        let expectation = expectation(description: "Load Locations")
        setToken(expectedToken)
        sut.loadLocations(id: "1") { result in
            switch result {
            case .success(let locations):
                locationsResponse = locations
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(locationsResponse.count, 2)
        XCTAssertEqual(locationsResponse.first?.id, expectedLocation.id)
    }
    
    func test_loadLocationsError_shouldReturn_Error() throws {
        // Given
        let expectedToken = "Token"
        var error: PIAApiError?
        
        // En el handler, validamos la request y configuramos la respuesta simulada.
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: -2)
        
        // When
        let expectation = expectation(description: "Load Locations Error")
        setToken(expectedToken)
        sut.loadLocations(id: "1") { result in
            switch result {
            case .success(_):
                XCTFail("Error expected")
            case .failure(let receivedError):
                error = receivedError
                expectation.fulfill()
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(error?.description, "Server error: \(-2)")
    }
    
    func test_login() throws {
        // Given
        let username = "admin"
        let password = "admin"
        let expectedToken = "Token"
        

        URLProtocolMock.handler = { request in
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/auth/login"))
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            
            let data = expectedToken.data(using: .utf8)!
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (data, response)
        }
        
        // When
        let expectation = expectation(description: "Login")
        var loginResponse: String?
        
        sut.loginRequest(username: username, password: password) { result in
            switch result {
            case .success(let token):
                loginResponse = token
                expectation.fulfill()
            case .failure(_):
                XCTFail("Success expected")
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(loginResponse, expectedToken)
    }
    
    func test_login_error() throws {
        // Given
        let username = "notAdmin"
        let password = "notAdmin"
        var error: PIAApiError?
        

        URLProtocolMock.handler = { request in
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/login"))
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 401, httpVersion: nil, headerFields: nil)!
            return (Data(), response)
        }
        
        // When
        let expectation = expectation(description: "Login Failure")
        
        sut.loginRequest(username: username, password: password) { result in
            switch result {
            case .success(_):
                XCTFail("Failure expected")
            case .failure(let receivedError):
                error = receivedError
                expectation.fulfill()
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(error?.description, "API error: \(401)")
    }
    
    // Función auxiliar para establecer el token en el almacenamiento seguro simulado.
    func setToken(_ token: String) {
        SecureDataStorageMock().saveToken(token)
    }
}
