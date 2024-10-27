
import Foundation

enum StatusLogin: Equatable {
    case success
    case error(reason: String)
    case loading
    case none
}

enum LoginError: String {
    case emptyCredentials = "please be sure to enter username and password"
    case unknownError = "unknown error"
    case invalidCredentials = "invalid username or password"
}


final class LoginViewModel {
    
    private let useCase: LoginUseCaseProtocol
    var onStateChanged: PIAObservable<StatusLogin> = PIAObservable(.none)
    
    init(useCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.useCase = useCase
    }
    
    //Función de Login en el que se maneja el valor de los estados dependiendo de si se hace de manera existosa o no
    func login(username: String, password: String) {
        if username.isEmpty, password.isEmpty {
            onStateChanged.value = .error(reason: LoginError.emptyCredentials.rawValue)
        } else {
            
        }
        onStateChanged.value = .loading
        useCase.login(username: username, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.onStateChanged.value = .success
            case .failure:
                self?.onStateChanged.value = .error(reason: LoginError.invalidCredentials.rawValue)
            }
        }
    }
}
    
    
