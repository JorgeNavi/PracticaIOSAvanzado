
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
        // Crea un array de ubicaciones mockeado.
        let locations = [ApiLocation(id: "id", date: "date", latitude: "latitud", longitude: "0000", hero: nil)]
        completion(.success(locations))  // Devuelve las ubicaciones mockeadas.
    }
    
    // Simula la carga de transformaciones de un héroe desde una API y siempre devuelve éxito.
    func loadTransformations(id: String, completion: @escaping ((Result<[ApiTransformation], PIAApiError>) -> Void)) {
        // Crea un array de transformaciones mockeado.
        let transformations = [ApiTransformation(id: "id", name: "name", photo: "photo", info: "desc", hero: nil)]
        completion(.success(transformations))  // Devuelve las transformaciones mockeadas.
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
}
