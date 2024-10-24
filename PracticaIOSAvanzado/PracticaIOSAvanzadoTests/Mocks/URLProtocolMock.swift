




import Foundation

/// Mock de `URLProtocol` para usar en `URLSession` durante pruebas unitarias de la API.
/// Permite simular respuestas de la red, facilitando la prueba de flujos de red de la aplicación sin necesidad de una conexión real a Internet.
/// Referencia al video de WWDC 2018: https://developer.apple.com/videos/play/wwdc2018/417
class URLProtocolMock: URLProtocol {
    // Error específico que queremos simular durante las pruebas.
    static var error: Error?
    // Handler que define cómo responder a una solicitud específica. Debe proporcionar los datos y la respuesta HTTP que se deben devolver.
    static var handler: ((URLRequest) throws -> (Data, HTTPURLResponse))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        // Todos los requests deben ser interceptados por este mock.
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Retorna la solicitud tal cual fue recibida.
        return request
    }
    
    override func startLoading() {
        // Intenta simular un error si está presente.
        if let error = Self.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        // Lanza un error fatal si no se ha proporcionado un handler, ya que es necesario para responder a las peticiones.
        guard let handler = Self.handler else {
            fatalError("Handler is required when error is not set.")
        }
        
        do {
            // Intenta obtener los datos y la respuesta desde el handler y los envía al cliente.
            let (data, response) = try handler(self.request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            // Si ocurre un error al obtener la respuesta, informa al cliente del error.
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // Método necesario para cumplir con el protocolo, pero no se necesita implementación específica para pruebas.
    }
}
