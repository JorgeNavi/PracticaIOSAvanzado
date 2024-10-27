//
//  DetailTransformationViewController.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 27/10/24.
//

import UIKit
import Kingfisher

class DetailTransformationViewController: UIViewController {
    
    @IBOutlet weak var transformationInfo: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var transformationName: UILabel!
    @IBOutlet weak var transformationImage: UIImageView!
    @IBOutlet weak var viewContain: UIStackView!
    private var viewModel: DetailTransformationViewModel
    
    init(viewModel: DetailTransformationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DetailTransformationViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBiding()
    
    }
    
    func setBiding() {
        viewModel.onStateChanged.bind {[weak self] state in
            switch state {
            case .loading:
                self?.spinner.startAnimating()
            case .success:
                self?.spinner.stopAnimating()
                self?.transformationName.text = self?.viewModel.getTransformationName()
                self?.transformationInfo.text = self?.viewModel.getTransformationInfo()
                self?.transformationImage.image = self?.viewModel.getTransformationImage()
            case .failure(reason: let reason):
                let alert = UIAlertController(title: "Detail Transformatio View Error", reason: reason, preferredStyle: .alert)
                //añadimos al alert un botón "OK" para salir
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            case .none:
                break
                
            }
        }
    }



}
