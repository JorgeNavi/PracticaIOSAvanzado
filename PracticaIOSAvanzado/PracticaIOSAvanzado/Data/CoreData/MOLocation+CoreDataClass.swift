//
//  MOLocation+CoreDataClass.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 15/10/24.
//
//

import Foundation
import CoreData

@objc(MOLocation)
public class MOLocation: NSManagedObject {

}

extension MOLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOLocation> {
        return NSFetchRequest<MOLocation>(entityName: "CDLocation")
    }

    @NSManaged public var id: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var date: String?
    @NSManaged public var hero: MOHero? //al ser la relación 1-1 en este caso, el tipo de relación es directamente MOHero, más propia de swift que de ObjectiveC

}

extension MOLocation : Identifiable {

}

