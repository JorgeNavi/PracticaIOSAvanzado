
import Foundation


struct Transformation {
    
    let id: String
    let name: String
    let photo: String
    let info: String
    
    
    init(moTransformation: MOTransformation) {
        self.id = moTransformation.id ?? ""
        self.name = moTransformation.name ?? ""
        self.photo = moTransformation.photo ?? ""
        self.info = moTransformation.info ?? ""
    }

}













