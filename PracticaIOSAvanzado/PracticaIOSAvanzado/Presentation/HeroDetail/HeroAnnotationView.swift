import MapKit




class HeroAnnotationView: MKAnnotationView {
    
    static var identifier: String {
        return String(describing: HeroAnnotationView.self)
    }
    
    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        self.canShowCallout = true
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        backgroundColor = .clear
        let view = UIImageView(image: UIImage(resource: .bolaDragon))
        addSubview(view)
        view.frame = self.frame
        //Botón de detalle a la derecha del callout
        //rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    
}
