
@testable import PracticaIOSAvanzado

// Mock de proveedor de API que simula respuestas exitosas.
class PIAApiProviderMock: PIAApiProviderProtocol {
    
    // Simula la carga de héroes desde una API y devuelve exitosamente un array de ApiHero o un error.
    func loadHeroes(name: String, completion: @escaping ((Result<[ApiHero], PIAApiError>) -> Void)) {
        do {
            let heroes = try DataMock.mockHeroes()  // Intenta obtener héroes mockeados.
            completion(.success(heroes))  // Devuelve los héroes si la operación es exitosa.
        } catch {
            completion(.failure(PIAApiError.dataError))  // Devuelve un error si ocurre una excepción.
        }
    }
    
    // Simula la carga de ubicaciones asociadas a un héroe desde una API y siempre devuelve éxito.
    func loadLocations(id: String, completion: @escaping ((Result<[ApiLocation], PIAApiError>) -> Void)) {
        
        do {
            let locations = try DataMock.mockLocations()
            completion(.success(locations))
        } catch {
            completion(.failure(PIAApiError.dataError))
        }
    }
    
    // Simula la carga de transformaciones de un héroe desde una API y siempre devuelve éxito.
    func loadTransformations(id: String, completion: @escaping ((Result<[ApiTransformation], PIAApiError>) -> Void)) {
        
        do {
            let transformations = try DataMock.mockTransformations()
            completion(.success(transformations))
        } catch {
            completion(.failure(PIAApiError.dataError))
        }
    }
    
    func loginRequest(username: String, password: String, completion: @escaping ((Result<String, PIAApiError>) -> Void)) {
        if username == "admin" && password == "admin" {
            completion(.success("token"))
        } else {
            completion(.failure(PIAApiError.invalidCredentials))
        }
    }
}

// Mock de proveedor de API que simula respuestas de error para todas las peticiones.
class ApiProviderErrorMock: PIAApiProviderProtocol {
    
    // Simula la carga de héroes y siempre devuelve un error.
    func loadHeroes(name: String, completion: @escaping ((Result<[ApiHero], PIAApiError>) -> Void)) {
        completion(.failure(PIAApiError.dataError))  // Devuelve un error simulado.
    }
    
    // Simula la carga de ubicaciones y siempre devuelve un error.
    func loadLocations(id: String, completion: @escaping ((Result<[ApiLocation], PIAApiError>) -> Void)) {
        completion(.failure(PIAApiError.dataError))  // Devuelve un error simulado.
    }
    
    // Simula la carga de transformaciones y siempre devuelve un error.
    func loadTransformations(id: String, completion: @escaping ((Result<[ApiTransformation], PIAApiError>) -> Void)) {
        completion(.failure(PIAApiError.dataError))  // Devuelve un error simulado.
    }
    
    func loginRequest(username: String, password: String, completion: @escaping ((Result<String, PIAApiError>) -> Void)) {
        completion(.failure(PIAApiError.invalidCredentials))
    }
}
