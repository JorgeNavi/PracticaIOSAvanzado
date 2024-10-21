
import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Establecemos este método en el Splash en el que le instanciamos el LoginViewController() y llamammos al navigationController para que haga una transición push al LoginViewController() (la pantalla del Login)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SecureDataStore.shared.getToken() != nil { //si tenemos token (el valor de getToken es distinto de nil):
            let heroesVC = HeroesViewController() //instanciamos nuestra vista de heroes y
            navigationController?.pushViewController(heroesVC, animated: true) //Pasamos directamente a la vista de heroes
        } else { //Si no tenemos token (el valor de getToken es igual que nil):
            let loginViewController = LoginViewController() //Instanciamos nuestra vista de login
            navigationController?.pushViewController(loginViewController, animated: true) //pasamos a la vista de login
        }

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
