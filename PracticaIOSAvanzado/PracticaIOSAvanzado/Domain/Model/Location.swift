

import MapKit

struct Location {
    
    let id: String
    let date: String
    let latitude: String
    let longitude: String
    
    init(moLocation: MOLocation) {
        
        self.id = moLocation.id ?? ""
        self.date = moLocation.date ?? ""
        self.latitude = moLocation.latitude ?? ""
        self.longitude = moLocation.longitude ?? ""
        
    }
}

//vamos a establecer las coordenadas de las localizaciones. Lo gestionamos aqui para poder llevarnoslo a nuestro viewModel
extension Location {
    
    var coordinate: CLLocationCoordinate2D? { //creamos un variable calculada de tipo CLLocationCoordinate2D donde nos aseguramos de tener los datos para crear la coordenada:
        guard let latitude = Double(self.latitude), let longitude = Double(self.longitude), abs(latitude) <= 90, abs(longitude) <= 180 else { return nil } //Como hay localizaciones con atributos erróneos en la API, se establece un valor absoluto (que devuelve el valor absoluto de un número, es decir sin decimales, e ignorando si es positivo o negativo con el abs que usamos) para asegurarnos que los valores dados sean correctos.
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude) //creamos nuestro CLLocation con nuestra latitud y nuestra longitud
    }
}
