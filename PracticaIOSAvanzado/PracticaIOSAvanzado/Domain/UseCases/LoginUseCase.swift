import Foundation


protocol LoginUseCaseProtocol {
    func login(username: String, password: String, completion: @escaping (Result<Void, PIAApiError>) -> Void)
}

class LoginUseCase: LoginUseCaseProtocol {
    private let apiProvider: PIAApiProvider
    private let secureStorage: SecureDataStoreProtocol
    
    init(apiProvider: PIAApiProvider = PIAApiProvider(), secureStorage: SecureDataStoreProtocol = SecureDataStore.shared) {
        self.apiProvider = apiProvider
        self.secureStorage = secureStorage
    }
    
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
           
