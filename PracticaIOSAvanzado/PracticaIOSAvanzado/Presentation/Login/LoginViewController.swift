
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        /*let apiProvider = PIAApiProvider()
         
         apiProvider.loadHeroes { result in
         switch result {
         case .success(let apiHeroes):
         //StoreDataProvider.shared.add(heroes: apiHeroes) //llamamos al StoreDataProvider y le añadimos los heroes de la API a la BBDD
         //let DBheores = StoreDataProvider.shared.fetchHeroes(filter: nil) //empleamos una contante de nombre databaseheroes en la que introducimos la petición de recuperar heroes de la BBDD
         debugPrint(apiHeroes) //DBheores) //y debugPrint
         case .failure(let error):
         debugPrint(error.description)
         */
    }
    
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                self.spinner.startAnimating()
                self.loginContainer.isHidden = true
                self.loginButton.isHidden = true
            case .success:
                self.spinner.stopAnimating()
                self.loginContainer.isHidden = true
                self.loginButton.isHidden = true
                let heroesViewController = HeroesViewController()
                navigationController?.pushViewController(heroesViewController, animated: true)
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
    
    @IBAction func onTappedLoginButton(_ sender: Any) {
        guard let username = emailField.text, let password = passwordField.text else { return }
        viewModel.login(username: username, password: password)
    }
}
   




