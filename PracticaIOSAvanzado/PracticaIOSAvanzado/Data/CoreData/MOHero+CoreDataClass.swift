//
//  MOHero+CoreDataClass.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 15/10/24.
//
//

import Foundation
import CoreData

@objc(MOHero)
public class MOHero: NSManagedObject {

}

extension MOHero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOHero> {
        return NSFetchRequest<MOHero>(entityName: "CDHero")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var info: String?
    @NSManaged public var photo: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var locations: Set<MOLocation>? //Aqui están creadas las relaciones. establecemos el tipo genéricos de Set<MOLocation> para evitar el NSSet que viene por defecto que es objetiveC y lo sustituimos igual en los métodos que nos ha creado automáticamente
    @NSManaged public var transformations: Set<MOTransformation>? //Aqui están creadas las relaciones. establecemos el tipo genéricos de Set<MOTransformation> para evitar el NSSet que viene por defecto que es objetiveC y lo sustituimos igual en los métodos que nos ha creado automáticamente

}

// MARK: Generated accessors for locations
//Nos crea los métodos automáticamente de añadir localizaciones, eliminar etc.
extension MOHero {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: MOLocation)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: MOLocation)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: Set<MOLocation>)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: Set<MOLocation>)

}

// MARK: Generated accessors for transformations
//Nos crea los métodos automáticamente de añadir transformaciones, eliminar etc.
extension MOHero {

    @objc(addTransformationsObject:)
    @NSManaged public func addToTransformations(_ value: MOTransformation)

    @objc(removeTransformationsObject:)
    @NSManaged public func removeFromTransformations(_ value: MOTransformation)

    @objc(addTransformations:)
    @NSManaged public func addToTransformations(_ values: Set<MOTransformation>?)

    @objc(removeTransformations:)
    @NSManaged public func removeFromTransformations(_ values: Set<MOTransformation>?)

}

extension MOHero : Identifiable {

}

