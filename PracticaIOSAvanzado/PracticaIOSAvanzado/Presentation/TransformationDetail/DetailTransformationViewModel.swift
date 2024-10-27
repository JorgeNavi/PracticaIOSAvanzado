

import Foundation

enum StatusTranformations {
    case loading
    case none
    case success
    case failure(reason: String)
}


final class DetailTransformationViewModel {
    
    private var transformation: Transformation
    var onStateChanged: PIAObservable<StatusTranformations> = PIAObservable(.none)
    
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
