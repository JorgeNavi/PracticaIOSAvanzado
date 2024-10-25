
import Foundation

enum StatusLogin {
    case success
    case error
    case loading
}


final class LoginViewModel {

    private let useCase: LoginUseCaseProtocol
    let onStateChanged: PIAObservable<StatusLogin> = PIAObservable(.loading)
    
    init(useCase: LoginUseCaseProtocol) {
        self.useCase = useCase
    }

    func login(username: String, password: String) {
        useCase.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.onStateChanged.value = .success
                case .failure(let error):
                    self?.onStateChanged.value = .error
                    let message = self?.message(for: error)
                    
                }
            }
        }
    }

    private func message(for error: PIAApiError) -> String {
            switch error {
            case .invalidCredentials:
                return "Invalid credentials. Please try again."
            case .serverError(let error):
                return "Connection error: \(error.localizedDescription)"
            case .URLMalFormed:
                return "URL Mal Formed"
            case .sessionTokenMissing:
                return "Token session not found"
            case .genericError:
                return "Unknown error"
            default:
                return "Unexpected error"
            }
    }
}
