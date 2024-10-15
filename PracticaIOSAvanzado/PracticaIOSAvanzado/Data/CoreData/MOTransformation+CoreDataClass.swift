//
//  MOTransformation+CoreDataClass.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 15/10/24.
//
//

import Foundation
import CoreData

@objc(MOTransformation)
public class MOTransformation: NSManagedObject {

}

extension MOTransformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOTransformation> {
        return NSFetchRequest<MOTransformation>(entityName: "CDTransformation")
    }

    @NSManaged public var id: String?
    @NSManaged public var info: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var hero: MOHero? //al ser la relación 1-1 en este caso, el tipo de relación es directamente MOHero, más propia de swift que de ObjectiveC

}

extension MOTransformation : Identifiable {

}

