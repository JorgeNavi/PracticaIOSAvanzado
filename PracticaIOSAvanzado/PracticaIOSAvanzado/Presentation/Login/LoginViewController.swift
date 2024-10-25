
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginBackground: UIImageView!
    
    private let token = "eyJhbGciOiJIUzI1NiIsImtpZCI6InByaXZhdGUiLCJ0eXAiOiJKV1QifQ.eyJleHBpcmF0aW9uIjo2NDA5MjIxMTIwMCwiaWRlbnRpZnkiOiIxRTgxNzY1OC02MkMyLTQ1RUItQTY1Mi03QTVCMTk0MUI5QUMiLCJlbWFpbCI6ImpvcmdlLmVzcGxpZWdvQGdtYWlsLmNvbSJ9.qSQDP5ha2aaLGDTPZcb1FfILwWpo7wCdHJ0iKmhvKN0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func goToHeroes(_ sender: Any) {
        SecureDataStore.shared.saveToken(token) //guardamos el token en el keychain y pasamos a la vista de heroes
        
        let heroesViewController = HeroesViewController()
        navigationController?.pushViewController(heroesViewController, animated: true)
    }
}
   




