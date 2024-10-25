//
//  HeroesViewController.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//

import UIKit

enum SectionHeroes {
    case main
}

class HeroesViewController: UIViewController {
    
    //le pasamos el viewModel
    private var viewModel: HeroesViewModel
    
    //Al DiffableDataSource hay que pasarle una seccion, que preparamos arriba en el enum, como solo vamos a usar una pues la llamamos main y ya, y el modelo que se va a usar
    private var dataSource: UICollectionViewDiffableDataSource<SectionHeroes, Hero>?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //inicializador con viewModel
    init(viewModel: HeroesViewModel = HeroesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HeroesViewController.self), bundle: nil) //iniciamos informando del nibName que es el viewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setBinding()//Hay que implementar el binding antes de recibir porque sin el binding no nos llega la notificación de que se ha ca,biado el estado del viewModel
        viewModel.loadData(filter: nil)
        
        
    }
    
    //establecemos el Binding con el viewModel para ser notificados de los cambios de estado.
    func setBinding() {
        viewModel.statusHeroes.bind { [weak self] status in
            switch status { //En función del status del viewModel:
            case .dataUpdated: //si ha actualizado los datos:
                var snapshot = NSDiffableDataSourceSnapshot<SectionHeroes, Hero>()
                snapshot.appendSections([.main])
                snapshot.appendItems(self?.viewModel.heroes ?? [], toSection: .main)
                self?.dataSource?.apply(snapshot)
                //actualizamos el listado de heroes
            case .error(reason: let reason):
                //informamos error
                //Si creamos un alert en el viewController se muestra una alerta de error:
                let alert = UIAlertController(title: "Heroes Table", message: reason, preferredStyle: .alert)
                //añadimos al alert un botón "OK" para salir
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                //Se necesita el present para mostrar vistas modales
                self?.present(alert, animated: true)
            case .none:
                break
            }
        }
    }
    
    //establecemos un método para configurar la celda en la que se verán los heroes:
    func configureCollectionView() {
        //le informamos de que nuestro delegado que es quien en la extensión va a ser llamado para la configuración de la celda
        collectionView.delegate = self
        
        //establecemos un cellRegister que nos va a hacer falta para dequeueConfiguredReusableCell
        //A UICollectionView.CellRegistration hay que pasarle una celda y el item que la trabaja/ocupa: <HeroCell, Hero>
        //se le pasa el identificador de la celda cellNib: UINib(nibName: HeroCell.identifier
        //y devuelve una celda, un indexPath y un item(hero):
        let cellRegister = UICollectionView.CellRegistration<HeroCell, Hero>(cellNib: UINib(nibName:        HeroCell.identifier, bundle: nil)) { cell, indexPath, hero in
            cell.configurewith(hero: hero) //le pasamos el metodo de configracion de la celda
            }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, IndexPath, hero in //Aquí se está inicializando el dataSource para un UICollectionView específico. El cellProvider es un bloque de código (closure) que especifica cómo se debería crear y configurar cada celda de la colección cuando es necesario.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegister, for: IndexPath, item: hero) /*
            collectionView.dequeueConfiguredReusableCell(using: for: item:) es una función que obtiene una celda reutilizable del collectionView. Utiliza tres argumentos:
            •    using: cellRegister: Un registro de configuración de celda (UICollectionView.CellRegistration) que define cómo se debe configurar la celda. Este registro normalmente incluye cómo se inicializa la celda y cómo se configura con el modelo de datos, en este caso, hero.
            •    for: IndexPath: El índice de posición en la colección donde se mostrará esta celda. Ayuda a identificar la posición exacta en la vista de colección.
            •    item: hero: El modelo de datos específico (hero) que debe mostrarse en la celda. En este contexto, hero podría ser una instancia de un modelo que contiene datos como el nombre del héroe, descripción, etc.
            */

        })
    }
}


extension HeroesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout { //UICollectionViewDelegateFlowLayout tiene un método en el que le vamos a poder indicar el tamaño de las celdas.
    
    //este es el método que hace que cuando un usuario hace tap en un elemento del collectionView (una celda de heroe), se navegue a la vista del detalle
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hero = viewModel.heroAt(index: indexPath.row) else { //funcion que nos devolvia un heroe para la celda. Es decir, si hay celda_
            return
        }
        let viewModel = DetailHeroViewModel(hero: hero)
        let detailHeroVC = DetailHeroViewController(viewModel: viewModel)
        self.show(detailHeroVC, sender: self) //self.show decide como moestrar la pantalla sin necesidad del navigationController
        //navigationController?.pushViewController(detailHeroVC, animated: true)
    }
    
    //define el tamaño de cada celda en un UICollectionView. Es parte de la implementación del protocolo UICollectionViewDelegateFlowLayout, que se utiliza para personalizar el diseño de un UICollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { /*
        •    collectionView: El UICollectionView para el cual se está definiendo el tamaño de la celda.
        •    collectionViewLayout: El layout que se está usando en el UICollectionView. Aunque en este caso no se utiliza directamente en el cuerpo de la función, es útil para casos donde el tamaño de la celda puede depender del diseño general.
        •    indexPath: La posición de la celda dentro del collectionView. Esto puede ser útil si el tamaño de las celdas varía en diferentes secciones o filas.
        */
        return CGSize(width: collectionView.bounds.size.width, height: 100) /*
        Aquí se especifica el tamaño de cada celda. Esta implementación establece que:
        •    La anchura (width) de la celda será igual al ancho completo del collectionView. Esto significa que cada celda se extenderá de lado a lado dentro de la vista de colección.
        •    La altura (height) de la celda será de 80 puntos. Este es un valor fijo que aplicará a todas las celdas, haciendo que todas tengan la misma altura.
        */
    }
}
