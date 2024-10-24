
import UIKit

class DetailHeroViewController: UIViewController {

    private var viewModel: DetailHeroViewModel
    
    init(viewModel: DetailHeroViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DetailHeroViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    
}
