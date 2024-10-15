//
//  StoreDataProvider.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 15/10/24.
//

import CoreData

//creamos nuestro StoreDataProvider que recordemos que es quien nos permite realizar las acciones con la BBDD
class StoreDataProvider {
    
    private let persistentContainer: NSPersistentContainer//donde guardamos toda la información de nuestra aplicación.
    private var context: NSManagedObjectContext { //Lo usamos para realizar acciones con la información, como añadir o cambiar datos.
        persistentContainer.viewContext //Utilizar viewContext asegura que todas las operaciones de datos que impactan directamente en la interfaz de usuario se realicen de manera segura y eficiente
    }
    
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: "Model") //Aqui se le informa del modelo de datos que tiene que trabajar la BBDD.
        self.persistentContainer.loadPersistentStores { _, error in //Aqui nos aseguramos de que la BBDD pueda cargar
            if let error { //si hay un error:
                fatalError("Error loading persistent store: \(error.localizedDescription)") // Cierra la app tanto en desarrollo como en producción.
            }
        }
    }
    
    
    //establecemos la función de guardado de nuestro contexto:
    func save() {
        if context.hasChanges { //Si el contexto tiene cambios
            do {
                try context.save() //prueba a guardar
            } catch { //capturamos posibles errores:
                debugPrint("Error saving context: \(error.localizedDescription)") //fallo al guardar el contexto
            }
        }
    }
}

extension StoreDataProvider {
    
    func add(heroes: [ApiHero]) {
        
        for hero in heroes {
            let newHero
        }
    }
}
