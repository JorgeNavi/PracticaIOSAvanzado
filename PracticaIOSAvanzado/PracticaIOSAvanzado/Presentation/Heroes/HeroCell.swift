//
//  HeroCell.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//

import UIKit

class HeroCell: UICollectionViewCell {

    
    //identificador para registrar la celda
    static var identifier: String {
        return String(describing: HeroCell.self)
    }
    
    @IBOutlet weak var lbHeroName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
