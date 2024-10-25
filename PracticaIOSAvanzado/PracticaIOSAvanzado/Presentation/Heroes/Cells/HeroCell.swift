//
//  HeroCell.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//

import UIKit
import Kingfisher


class HeroCell: UICollectionViewCell {

    @IBOutlet weak var lbHeroName: UILabel!
    
    @IBOutlet weak var heroImage: UIImageView!
    
    //identificador para registrar la celda
    static var identifier: String {
        return String(describing: HeroCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //configuramos la celda con el heroe
    func configurewith(hero: Hero) {
        lbHeroName.text = hero.name //al valor del txt de la etiqueta de HeroName se le da el valor del nombre del heroe
        let options = KingfisherOptionsInfo([.transition(.fade(0.3)), .forceTransition])
        heroImage.kf.setImage(with: URL(string: hero.photo), options: options) //Con kingFisher a raves de la url del atributo photo del heroe se establece una imagen y se configuran unas opciones de animación
        
    }

}
