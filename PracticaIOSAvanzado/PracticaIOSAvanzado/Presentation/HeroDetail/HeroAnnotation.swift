

import MapKit

class HeroAnnotation: NSObject, MKAnnotation { //MKAnnotation es un protocolo obligatorio para establecer anotaciones en los mapas. Tiene una propiedad obligatoria (coordenadas) y una opcional (titulo)
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
}
