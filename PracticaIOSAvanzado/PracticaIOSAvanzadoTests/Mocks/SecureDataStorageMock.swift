

import Foundation
@testable import PracticaIOSAvanzado

/// Mock para `SecureDataStoreProtocol`.
/// Simula el almacenamiento seguro, pero en lugar de utilizar `Keychain`, utiliza `UserDefaults`.
/// Esto permite probar componentes que dependen de `SecureDataStoreProtocol` sin modificar el entorno de `Keychain`.
class SecureDataStorageMock: SecureDataStoreProtocol {
  
    // Clave usada para almacenar y recuperar el token de autenticación en UserDefaults.
    private let kToken = "kToken"
    
    // Instancia de UserDefaults utilizada para almacenar los datos simulados.
    private var userDefaults = UserDefaults.standard
    
    /// Guarda un token de autenticación en UserDefaults.
    /// - Parameter token: El token de autenticación a guardar.
    func saveToken(_ token: String) {
        userDefaults.set(token, forKey: kToken)
    }
    
    /// Recupera el token de autenticación de UserDefaults.
    /// - Returns: El token de autenticación si existe; de lo contrario, `nil`.
    func getToken() -> String? {
        userDefaults.string(forKey: kToken)
    }
    
    /// Elimina el token de autenticación de UserDefaults.
    func deleteToken() {
        userDefaults.removeObject(forKey: kToken)
    }
}
