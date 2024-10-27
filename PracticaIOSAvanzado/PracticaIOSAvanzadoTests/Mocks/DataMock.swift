

import Foundation
@testable import PracticaIOSAvanzado

/// Clase auxiliar que provee métodos para cargar datos de prueba desde archivos locales.
/// Se utiliza para facilitar la realización de pruebas unitarias, permitiendo simular respuestas de API.
class DataMock {
    
    /// Carga datos desde un archivo JSON localizado en el bundle de la aplicación.
    /// Ideal para simular la carga de datos como si provinieran de una API real.
    /// - Returns: Los datos en formato `Data`.
    /// - Throws: Un error si el archivo no puede ser encontrado o leído, facilitando la identificación de problemas en los recursos de prueba.
    static func loadHeroesData() throws -> Data {
        let bundle = Bundle(for: DataMock.self)
        guard let url = bundle.url(forResource: "Heroes", withExtension: "json"),
              let data = try? Data.init(contentsOf: url)  else {
            throw NSError(domain: "io.keepcoding.PracticaIOSAvanzado", code: -1)
        }
        return data
    }
    
    static func loadLocationsData() throws -> Data {
        let bundle = Bundle(for: DataMock.self)
        guard let url = bundle.url(forResource: "Localizations", withExtension: "json"),
              let data = try? Data.init(contentsOf: url)  else {
            throw NSError(domain: "io.keepcoding.PracticaIOSAvanzado", code: -2)
        }
        return data
    }
    
    static func loadTransformationsData() throws -> Data {
        let bundle = Bundle(for: DataMock.self)
        guard let url = bundle.url(forResource: "Transformations", withExtension: "json"),
              let data = try? Data.init(contentsOf: url)  else {
            throw NSError(domain: "io.keepcoding.PracticaIOSAvanzado", code: -3)
        }
        return data
    }
    
    /// Utiliza los datos cargados del archivo JSON para crear y devolver un array de objetos `ApiHero`.
    /// Esto simula el proceso de decodificación de datos que normalmente ocurre después de recibir datos de una API.
    /// - Returns: Un array de instancias de `ApiHero`.
    /// - Throws: Cualquier error de decodificación o carga de datos, asegurando que los problemas sean capturados durante las pruebas.
    static func mockHeroes() throws -> [ApiHero] {
        do {
            let data = try self.loadHeroesData()
            let heroes = try JSONDecoder().decode([ApiHero].self, from: data)
            return heroes
        } catch {
            throw error
        }
    }
    
    static func mockLocations() throws -> [ApiLocation] {
        do {
            let data = try self.loadLocationsData()
            let locations = try JSONDecoder().decode([ApiLocation].self, from: data)
            return locations
        } catch {
            throw error
        }
    }
    
    static func mockTransformations() throws -> [ApiTransformation] {
        do {
            let data = try self.loadTransformationsData()
            let transformations = try JSONDecoder().decode([ApiTransformation].self, from: data)
            return transformations
        } catch {
            throw error
        }
    }
}
