

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
        guard let url = bundle.url(forResource: "Locations", withExtension: "json"),
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
    
    static func getHeroGoku() -> ApiHero {
            ApiHero(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
                    name: "Goku",
                    info: "Sobran las presentaciones cuando se habla de Goku. El Saiyan fue enviado al planeta Tierra, pero hay dos versiones sobre el origen del personaje. Según una publicación especial, cuando Goku nació midieron su poder y apenas llegaba a dos unidades, siendo el Saiyan más débil. Aun así se pensaba que le bastaría para conquistar el planeta. Sin embargo, la versión más popular es que Freezer era una amenaza para su planeta natal y antes de que fuera destruido, se envió a Goku en una incubadora para salvarle.",
                    photo:  "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300",
                    favorite: false)
        }
}
