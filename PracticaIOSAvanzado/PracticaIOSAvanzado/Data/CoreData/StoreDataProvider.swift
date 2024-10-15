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
            let newHero = MOHero(context: context) //instanciamos un nuevo heroe que es del tipo de la entidad de la BBDD y le asignamos valor a sus atributos:
            newHero.id = hero.id
            newHero.name = hero.name
            newHero.favorite = hero.favorite ?? false //el compilador avisa de que esto es opcional, asi que mediante el operador ?? establecemos que, si no tenemos valor de favorito, su valor por defecto sea false
            newHero.photo = hero.photo
        }
        save() //Hay que guardar el contexto después del for
    }
    
    func fetchHeroes(filter: NSPredicate?) -> [MOHero] { //modificamos la función con el predicado como parámetro
        let request = MOHero.fetchRequest()//se instancia una request que va a ser el metodo fetchRequest de MOHero proporcionado por el StoreProvider
        request.predicate = filter //le añadimos aquí el predicado
        do {
            return try context.fetch(request) //Si hay registros los recuperas
        } catch {
            debugPrint("Error loading heroes request \(error.localizedDescription)") //si no, lanza mensaje de error y devuelve un array vacío
            return []
        }
    }
    
    //añadimos Location
    func ad(locations: [ApiLocation]) {
        for location in locations {
            let newLocation = MOLocation(context: context) //instanciamos una nueva localzación que es del tipo de la entidad de la BBDD y le asignamos valor a sus atributos:
            newLocation.id = location.id
            newLocation.latitude = location.latitude
            newLocation.longitude = location.longitude
            newLocation.date = location.date
            
            if let heroId = location.hero?.id { //creamos una constante heroId a la que introducimos el id del heroe que tiene relacion con la location. Si hay un heroe con id asignado a la localización:
                //creamos un predicado para filtrar los heroes según nos interesa
                let predicate = NSPredicate(format: "id == %@", heroId) //se sustituye lo que hay detrás de la coma con %@, asi que esta comparando IDs. Este predicado se lo tenemos que pasar a nuestra función de fetchHeroes. Con esto estamos buscando el heroe que corresponde a location.
                let hero = fetchHeroes(filter: predicate).first //llamamos al método fetchHeroes con el predicado y cogemos el primer registro (cuyo id ha sido filtrado en el predicado)
                newLocation.hero = hero //nuestro newLocation.hero tiene el valor de ese registro
            }
        }
    }
    
    //añadimos transformación
    func add(transformations: [MOTransformation]) {
        for transformation in transformations {
            let newTransformation = MOTransformation(context: context) //instanciamos una nueva transformación que es del tipo de la entidad de la BBDD y le asignamos valor a sus atributos:
            newTransformation.id = transformation.id
            newTransformation.name = transformation.name
            newTransformation.info = transformation.info
            newTransformation.photo = transformation.photo
            
            if let heroId = transformation.hero?.id { //creamos una constante heroId a la que introducimos el id del heroe que tiene relacion con la transformation. Si hay un heroe con id asignado a la transformación:
                //creamos un predicado para filtrar los heroes según nos interesa
                let predicate = NSPredicate(format: "id == %@", heroId) //se sustituye lo que hay detrás de la coma con %@, asi que esta comparando IDs. Este predicado se lo tenemos que pasar a nuestra función de fetchHeroes. Con esto estamos buscando el heroe que corresponde a transformation.
                let hero = fetchHeroes(filter: predicate).first //llamamos al método fetchHeroes con el predicado y cogemos el primer registro (cuyo id ha sido filtrado en el predicado)
                newTransformation.hero = hero //nuestro newTransformation.hero tiene el valor de ese registro
            }
        }
    }
}
