

import Foundation



final class DetailTransformationViewModel {
    
    private var transformation: Transformation
    
    init(transformation: Transformation) {
        self.transformation = transformation
    }
    
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
