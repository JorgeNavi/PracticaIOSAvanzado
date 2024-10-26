//
//  StoreDataProvider.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 15/10/24.
//

import CoreData

//vamos a implementar un enum con los casos según donde se realice la persistencia de datos para realizar en condiciones el testing de CoreData
enum typePersistency {
    case disk
    case memory
}

//creamos nuestro StoreDataProvider que recordemos que es quien nos permite realizar las acciones con la BBDD
class StoreDataProvider {
    
    static var shared: StoreDataProvider = .init()
    
    static var managedModel: NSManagedObjectModel = {
        let bundle = Bundle(for: StoreDataProvider.self)
        guard let url = bundle.url(forResource: "Model", withExtension: "momd"), let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Error loading model from bundle")
        }
        return model
    }()
    
    private let persistentContainer: NSPersistentContainer//donde guardamos toda la información de nuestra aplicación.
    private let persistency: typePersistency //instanciamos nuestra persistencia del tipo de nuestro enum typePersistency y lo pasamos al init como parámetro
    
    private var context: NSManagedObjectContext { //Lo usamos para realizar acciones con la información, como añadir o cambiar datos.
        let viewContext = persistentContainer.viewContext //Utilizar viewContext asegura que todas las operaciones de datos que impactan directamente en la interfaz de usuario se realicen de manera segura y eficiente
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump //Aplicamos una politica de mergeado, es decir, que ocurre cuando hay datos superpuestos en la BBDD. En este caso mergeByPropertyObjectTrump lo que hace es actualizar el registro existente si entra otro con las mismas propiedades. Si no existe, lo que crea de nuevas.
        return viewContext
        
    }
    
    
    init(persistency: typePersistency = .disk) { //le damos por defecto el valor de .disk
        self.persistency = persistency //instanciamos nuestra persistencia
        self.persistentContainer = NSPersistentContainer(name: "Model", managedObjectModel: Self.managedModel) //Aqui se le informa del modelo de datos que tiene que trabajar la BBDD.
        if self.persistency == .memory { //Si el tipo de persistencia es .memory:
            let persistenStore = persistentContainer.persistentStoreDescriptions.first
            persistenStore?.url = URL(filePath: "/dev/null")
            /*
             •    if self.persistency == .memory: Este bloque condicional se ejecuta solo si la persistencia está configurada para ser en memoria.
             •    let persistenStore = persistentContainer.persistentStoreDescriptions.first: Obtiene la primera descripción de la tienda de persistencia disponible para este contenedor, que es lo que se configurará en el siguiente paso.
             •    persistenStore?.url = URL(filePath: "/dev/null"): Establece la URL del almacén persistente a /dev/null, un dispositivo especial que descarta toda la información escrita en él, simulando un almacenaje que no guarda los datos de forma permanente. Este esquema es útil para pruebas o situaciones donde no quieres que los datos persistan entre sesiones de la aplicación.
             */
        }
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
            newHero.info = hero.info
            newHero.favorite = hero.favorite ?? false
            newHero.photo = hero.photo
        }
        save() //Hay que guardar el contexto después del for
    }
    
    //sortAscendig (hacer un sort) sirve para darle un orden predefinido a los datos, en este caso se le otorga un valor por defecto true para indicar que el orden que le demos se va a ejecutar por defecto
    func fetchHeroes(filter: NSPredicate?, sortAscendig: Bool = true) -> [MOHero] { //modificamos la función con el predicado como parámetro
        let request = MOHero.fetchRequest()//se instancia una request que va a ser el metodo fetchRequest de MOHero proporcionado por el StoreProvider
        request.predicate = filter //le añadimos aquí el predicado
        let sort = NSSortDescriptor(keyPath: \MOHero.name, ascending: sortAscendig) //Añadimos el orden que queremos dar a los datos: keyPath: \MOHero.name indica el dato se quiere ordenar por nombre y ascending: sortAscendig indica que se haga de forma ascendente
        request.sortDescriptors = [sort] //Y aqui le pasamos nuestro sort a la request
        do {
            return try context.fetch(request) //Si hay registros los recuperas
        } catch {
            debugPrint("Error loading heroes request \(error.localizedDescription)") //si no, lanza mensaje de error y devuelve un array vacío
            return []
        }
    }
    
    //añadimos Location
    func add(locations: [ApiLocation]) {
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
        save()
    }
    
    //añadimos transformación
    func add(transformations: [ApiTransformation]) {
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
        save()
    }
    
    func clearDDBB() {
        
        //Solo es necesario establecer un borrado de heroes porque la relación que tiene con locations y transformatios es en cascada y si se eliminan los heroes se eliminan las otras dos entidades de la BBDD
        let deleteHeroes = NSBatchDeleteRequest(fetchRequest: MOHero.fetchRequest())
        
        do {
            try context.execute(deleteHeroes) //el NSBatchDeleteRequest se ejecuta directamente en el store por el metodo .execute
            context.reset() //esto deja el context como si se acabara de crear
        } catch {
            debugPrint("Error cleaning DataBase: \(error.localizedDescription)")
        }
    }
}
