
import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Establecemos este método en el Splash en el que le instanciamos el LoginViewController() y llamammos al navigationController para que haga una transición push al LoginViewController() (la pantalla del Login)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
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
