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
        configureUI()
    
    }
    
    //metodo que va a mostrar la informacion que se va a visualizar en el didLoad
    func configureUI() {
        self.spinner.stopAnimating()
        self.transformationName.text = self.viewModel.getTransformationName()
        self.transformationInfo.text = self.viewModel.getTransformationInfo()
        let options = KingfisherOptionsInfo([.transition(.fade(0.3)), .forceTransition])
        self.transformationImage.kf.setImage(with: URL(string: self.viewModel.getTransformationImage()), options: options)

    }
}
