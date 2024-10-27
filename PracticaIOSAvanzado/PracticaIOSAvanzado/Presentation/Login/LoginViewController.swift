
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginContainer: UIStackView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    
    private var viewModel = LoginViewModel()
   
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: "LoginViewController", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //escondemos el botón de back
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //lo volvemos a mostrar pues nos hará falta en el listado de heroes
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()

    }
    
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                self.statusLoading()
            case .success:
                self.statusSuccess()
            case .error(let reason):
                self.loginContainer.isHidden = true
                self.spinner.stopAnimating()
                self.loginButton.isHidden = true
                let alert = UIAlertController(title: "Login Error", message: reason, preferredStyle: .alert)
                //añadimos al alert un botón "OK" para salir
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                //Se necesita el present para mostrar vistas modales
                self.present(alert, animated: true)
                viewModel.onStateChanged.value = .none
            case .none:
                self.spinner.stopAnimating()
                self.loginContainer.isHidden = false
                self.loginButton.isHidden = false
            }
        }
    }
    
    private func statusLoading() {
        self.spinner.startAnimating()
        self.loginContainer.isHidden = true
        self.loginButton.isHidden = true
    }
    
    private func statusSuccess() {
        self.spinner.stopAnimating()
        self.loginContainer.isHidden = true
        self.loginButton.isHidden = true
        let heroesViewController = HeroesViewController()
        navigationController?.pushViewController(heroesViewController, animated: true)
    }
    
    
    @IBAction func onTappedLoginButton(_ sender: Any) {
        guard let username = emailField.text, let password = passwordField.text else { return }
        viewModel.login(username: username, password: password)
    }
}
   




