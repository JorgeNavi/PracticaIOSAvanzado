
import UIKit
import MapKit

class DetailHeroViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    private var viewModel: DetailHeroViewModel
    private var locationManager: CLLocationManager = CLLocationManager()
    
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
        configureMap()
        setBiding()
        viewModel.loadData()
        checkLocationAuthorizationStatus()
    }
    
    func setBiding() {
        viewModel.status.bind {[weak self] status in
            switch status {
            case .locationUpdated:
                self?.updateMapAnnotations() //se muestran las anotaciones en el mapa
            case .error(reason: let reason):
                //informamos error
                //Si creamos un alert en el viewController se muestra una alerta de error:
                let alert = UIAlertController(title: "Detail View Error", message: reason, preferredStyle: .alert)
                //añadimos al alert un botón "OK" para salir
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                //Se necesita el present para mostrar vistas modales
                self?.present(alert, animated: true)
            case .none:
                break
            }
        }
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

extension DetailHeroViewController: MKMapViewDelegate {
    
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
}
