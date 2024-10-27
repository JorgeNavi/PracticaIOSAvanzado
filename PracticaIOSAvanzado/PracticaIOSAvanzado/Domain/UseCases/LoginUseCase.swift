import Foundation


protocol LoginUseCaseProtocol {
    func login(username: String, password: String, completion: @escaping (Result<Void, PIAApiError>) -> Void)
}

class LoginUseCase: LoginUseCaseProtocol {
    private let apiProvider: PIAApiProviderProtocol
    private let secureStorage: SecureDataStoreProtocol
    
    init(apiProvider: PIAApiProviderProtocol = PIAApiProvider(), secureStorage: SecureDataStoreProtocol = SecureDataStore.shared) {
        self.apiProvider = apiProvider
        self.secureStorage = secureStorage
    }
    
    //se establece el metodo de hacer login llamando al loginRequest
    func login(username: String, password: String, completion: @escaping (Result<Void, PIAApiError>) -> Void) {
        guard !username.isEmpty, !password.isEmpty else {
            completion(.failure(.invalidCredentials))
            return
        }
        apiProvider.loginRequest(username: username, password: password) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let token):
                self?.secureStorage.saveToken(token)
                completion(.success(()))
            }
        }
    }
}
           
