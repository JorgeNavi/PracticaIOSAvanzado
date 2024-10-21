//
//  SecureDataStore.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 21/10/24.
//
import KeychainSwift

//implementamos un protocolo que nos va a hacer falta para el mockeado de los test
protocol SecureDataStoreProtocol {
    
    func saveToken(_ token: String)
    func getToken() -> String?
    func deleteToken()
}

//Hacemos uso de keyChain para guardar elementos como e token de usuario de forma segura
class SecureDataStore: SecureDataStoreProtocol {
    
    private let keyToken = "keyToken" //hacemos una instancia de token con un valor predefinido
    private let keychain = KeychainSwift() //instanciamos KeychainSwift para hacer uso de su funcionalidad
    
    static let shared: SecureDataStore = .init() //Singleton para usar la misma instancia en toda la App
    
    //guardar el token estableciendo su valor:
    func saveToken(_ token: String) {
        keychain.set(token, forKey: keyToken) //se le otorga el valor "token" a la clave "keyToken"
    }
    
    func getToken() -> String? {
        keychain.get(keyToken) //nos devuelve el valor del token
    }
    
    func deleteToken() {
        keychain.delete(keyToken) //nos permite eliminar nuestro token
    }
    
    //el token lo vamos a utilizar donde construimos la API, en nuestro caso en el RequestBuilder
}
