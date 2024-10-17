//
//  HeroesViewController.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//

import UIKit


class HeroesViewController: UIViewController {
    
    //le pasamos el viewModel
    private var viewModel: HeroesViewModel
    
    //inicializador con viewModel
    init(viewModel: HeroesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HeroesViewController.self), bundle: nil) //iniciamos informando del nibName que es el viewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
