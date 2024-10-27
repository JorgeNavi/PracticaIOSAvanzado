

import Foundation



final class DetailTransformationViewModel {
    
    private var transformation: Transformation
    
    init(transformation: Transformation) {
        self.transformation = transformation
    }
    
    //establecemos los métodos para extraer la informacion de la transfromación
    
    func getTransformationName() -> String {
        return transformation.name
    }
    
    func getTransformationInfo() -> String {
        return transformation.info
    }
    
    func getTransformationImage() -> String {
            return transformation.photo
    }
}
