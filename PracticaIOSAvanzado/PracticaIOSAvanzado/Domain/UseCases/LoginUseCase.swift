import Foundation


protocol LoginUseCaseProtocol {
    func login(username: String, password: String, completion: @escaping (Result<Void, PIAApiError>) -> Void)
}

class LoginUseCase: LoginUseCaseProtocol {
    private let requestBuilder: PIARequestBuilder
    private let secureStorage: SecureDataStoreProtocol
    
    init(requestBuilder: PIARequestBuilder, secureStorage: SecureDataStoreProtocol) {
        self.requestBuilder = requestBuilder
        self.secureStorage = secureStorage
    }
    
    func login(username: String, password: String, completion: @escaping (Result<Void, PIAApiError>) -> Void) {
        do {
            let request = try requestBuilder.buildLoginRequest(username: username, password: password)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    completion(.failure(PIAApiError.serverError(error: error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(PIAApiError.URLMalFormed))
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    if let data = data, let token = self.parseToken(responseData: data) {
                        self.secureStorage.saveToken(token)
                        completion(.success(()))
                    } else {
                        completion(.failure(PIAApiError.sessionTokenMissing))
                    }
                case 401:
                    completion(.failure(PIAApiError.invalidCredentials))
                default:
                    completion(.failure(PIAApiError.genericError))
                }
            }
            task.resume()
        } catch {
            completion(.failure(PIAApiError.URLMalFormed))
        }
    }
    
    private func parseToken(responseData data: Data) -> String? {
        do {
            // Intenta deserializar el JSON
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // Intenta recuperar el token del JSON
                if let token = json["token"] as? String {
                    return token
                } else {
                    debugPrint("Token not found")
                }
            }
        } catch {
            debugPrint("Error parsing JSON")
        }
        return nil
    }
}
