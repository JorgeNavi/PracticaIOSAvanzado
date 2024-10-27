
import UIKit
import MapKit
import Kingfisher

enum SectionTransformation {
    case main
}

class DetailHeroViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var infoHerotext: UITextView!
    @IBOutlet weak var transformationsContainer: UICollectionView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    private var viewModel: DetailHeroViewModel
    private var locationManager: CLLocationManager = CLLocationManager()
    private var dataSource: UICollectionViewDiffableDataSource<SectionTransformation, Transformation>?
    
    init(viewModel: DetailHeroViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DetailHeroViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView() //celdas a usar en el collectionView
        configureMap()
        setBiding() //columna vertebral con los estados de la pantalla
        viewModel.loadData() //carga los datos
        checkLocationAuthorizationStatus()
    }

    
    func setBiding() {
        viewModel.status.bind {[weak self] status in
            switch status {
            case .locationsUpdated:
                self?.updateMapAnnotations() //se muestran las anotaciones en el mapa
                self?.spinner.isHidden = true
                self?.heroNameLabel.text = self?.viewModel.getHeroname()
                self?.infoHerotext.text = self?.viewModel.getHeroInfo()
                //actualizamos el listado de heroes
            case .transformationsUpdated:
                var snapshot = NSDiffableDataSourceSnapshot<SectionTransformation, Transformation>()
                snapshot.appendSections([.main])
                snapshot.appendItems(self?.viewModel.getheroTransformations() ?? [], toSection: .main)
                self?.dataSource?.apply(snapshot)
            case .error(reason: let reason):
                //informamos error
                //Si creamos un alert en el viewController se muestra una alerta de error:
                let alert = UIAlertController(title: "Detail View Error", message: reason, preferredStyle: .alert)
                //añadimos al alert un botón "OK" para salir
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                //Se necesita el present para mostrar vistas modales
                self?.present(alert, animated: true)
            case .loading:
                self?.spinner.isHidden = false
            case .none:
                break
            }
        }
    }
    
    private func configureCollectionView() {
        //delegado que vamos a establecer en el extension
        transformationsContainer.delegate = self
        
        //registramos la celda que le vamos a meter al collectionView
        let cellRegister = UICollectionView.CellRegistration<HeroCell, Transformation>(cellNib: UINib(nibName: HeroCell.identifier, bundle: nil)) { cell, indexPath, transformation in
            cell.lbHeroName.text = transformation.name
            let options = KingfisherOptionsInfo([.transition(.fade(0.3)), .forceTransition])
            cell.heroImage.kf.setImage(with: URL(string: transformation.photo), options: options) //Con kingFisher atraves de la url del atributo photo del heroe se establece una imagen y se configuran unas opciones de animación
            
        }
        //el UICollectionViewDiffableDataSource añade la celda de arriba en el collectionView y la celda que quiere usar
        dataSource = UICollectionViewDiffableDataSource<SectionTransformation, Transformation>(collectionView: transformationsContainer, cellProvider: { collectionView, indexPath, transformation in //el indexpath sirve para diferenciar los elementos del array que te llegan
            collectionView.dequeueConfiguredReusableCell(using: cellRegister, for: indexPath, item: transformation) //metodo que configura una celda reusable con ese cellregister, para ese elemento de la lista con X item
        })
            
    }
                
    //funcion para añadir las anotaciones al mapa
    private func updateMapAnnotations() {
        
        let oldAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(oldAnnotations)
        self.mapView.addAnnotations(viewModel.annotations)
        
        if let annotation = viewModel.annotations.first {
            mapView.region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000) //muestra donde se situa el mapa (el centro es la coordicnada y los metros el zoom)
        }
    }
    
    //Vamos a establecer un método para pedirle la localización al usuario o para trackearle o no dependiendo del estado
    private func checkLocationAuthorizationStatus() {
        
        let authorizationStatus = locationManager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            mapView.showsUserLocation = false
            mapView.showsUserTrackingButton = false
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}

extension DetailHeroViewController: MKMapViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    //vamos a establecer una vista para la anotacion con este metodo del delgado MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        
        //comporbamos el tipo de anotacion
        guard let annotation = annotation as? HeroAnnotation else {
            return nil
        }
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: HeroAnnotationView.identifier) {
            return annotationView
        }
        let annotationView = HeroAnnotationView(annotation: annotation, reuseIdentifier: HeroAnnotationView.identifier)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        debugPrint("calloutAccessoryControlTapped")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: 200)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedTransformation = viewModel.getTransfromationAt(index: indexPath.row) else { //funcion que nos devolvia un heroe para la celda. Es decir, si hay celda_
            return
        }
        let viewModel = DetailTransformationViewModel(transformation: selectedTransformation)
        let detailTransVC = DetailTransformationViewController(viewModel: viewModel)
        present(detailTransVC, animated: true, completion: nil) //self.show decide como moestrar la pantalla sin necesidad del navigationController
        //navigationController?.pushViewController(detailHeroVC, animated: true)
    }
     
    
    
}
