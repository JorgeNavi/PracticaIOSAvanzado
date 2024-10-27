
import XCTest
@testable import PracticaIOSAvanzado

final class StoreProviderTests: XCTestCase {
    
    //Para los siguientes test no necesitamos realizar un mock ya que vamos a testear el stack de CoreData que está en memoria y cuyos datos se los vamos a dar nosotros
    
    //sut quiere decir "Subject Under Test" y el nombre es una convención para determinar lo que se está testando
    var sut: StoreDataProvider! //poner ! en los test para que el compilador no chille no es una mala práctica

    
    //esta funcion viene por defecto
    //cada vez que se ejecuta un test de los que vamos a ir implementando más abajo, se van a crear las instancias que vamos a utilizar (el sut por ejemplo)
    //antes de que se ejecuten los test, se va a lanzar este método.
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StoreDataProvider(persistency: .memory) //instanciamos nuestro StoreDataProvider en memoria para los test
    }
    
    //esta funcion viene por defecto
    //una vez que el test acaba, se ejecuta este método que es donde se limpia lo que tengamos que limpiar
    //De esta forma siempre se va a trabajar en un entorno limpio
    override func tearDownWithError() throws {
        sut = nil //limpiamos el StoreDataProvider antes de que se ejecute este método
        try super.tearDownWithError()
    }
    
    //Todas las funciones tienen que empezar por test para que el editor realice el test, si no, no lo realiza. Given, When y Then son otra convención de estructura de test (Dado X, Cuando Y, entonces Z).
    
    //MARK: - test_addHeroes_ShouldReturn_ItemsInserted
    
    func test_addHeroes_ShouldReturn_ItemsInserted() throws {
        //Given
        let initialCount = sut.fetchHeroes(filter: nil).count //Contamos el número de registros haciendo fetch que va a ser 0
        let apiHero = ApiHero(id: "123", name: "Coco", info: "coco es un coco", photo: "Foto", favorite: false) //le otorgamos nuestros datos para hacer pruebas
        
        //When
        sut.add(heroes: [apiHero]) //se llama al método de añadir heroes que añade el apiHero proporcionado arriba
        let heroes = sut.fetchHeroes(filter: nil) //metemos en una constante la request de heroes tras haber hecho la inserción
        let finalCount = heroes.count //la cuenta final tiene que ser igual al tamaño total de registros de la request (1, que es el registro introducidos arriba)
        
        //Then (Aqui se hacen las comprobaciones, validaciones y asserts)
        //XCTAssertEqual compara las dos expresiones que se le pasan
        //estamos probando que realmente se hace una inserción en la BBDD
        XCTAssertEqual(finalCount, initialCount + 1) //(el tamaño de finalCount tiene que ser igual al tamaño de initialCount + 1 porque se ha añadido un registro
        let hero = try XCTUnwrap(heroes.first) //esta funcionalidad tiene esta expresion para cuando lo que se esta testando puede ser opcional para desempaquetar los opcionales para poder hacer comparativas como las siguientes:
        //Estamos probando que lo que se inserta en la BBDD es lo que le llega de la API
        XCTAssertEqual(hero.id, apiHero.id)
        XCTAssertEqual(hero.name, apiHero.name)
        XCTAssertEqual(hero.info, apiHero.info)
        XCTAssertEqual(hero.photo, apiHero.photo)
        XCTAssertEqual(hero.favorite, apiHero.favorite)
    }
    
    //MARK: - test_fetchHeroes_ShouldBeSortedAs
    
    //En este test vamos a probar que los datos de la request se ordenan correctamente como les habiamos establecido:
    func test_fetchHeroes_ShouldBeSortedAs() throws {
        //Given
        let initialCount = sut.fetchHeroes(filter: nil).count //Nos volvemos a asegurar de que la cuenta incial es 0
        let apiHero = ApiHero(id: "123", name: "Piña", info: "piña no es un coco", photo: "Foto", favorite: false)
        let apiHero2 = ApiHero(id: "124", name: "Coco", info: "coco es un coco", photo: "Foto", favorite: false)
        
        //When
        sut.add(heroes: [apiHero, apiHero2]) //Le pasamos primero apiHero cuyo nombre empieza por P, iria detrás de apiHero2
        let heroes = sut.fetchHeroes(filter: nil) //hacemos la request
        
        //Then
        XCTAssertEqual(initialCount, 0)
        let hero = try XCTUnwrap(heroes.first) //Como desempaqueta el primer registro que le llega, los atributos deben ser igual a los de apiHero2 porque por el orden que le establecimos, los registros se orden por nombre de manera ascendente.
        
        XCTAssertEqual(hero.id, apiHero2.id)
        XCTAssertEqual(hero.name, apiHero2.name)
        XCTAssertEqual(hero.info, apiHero2.info)
        XCTAssertEqual(hero.photo, apiHero2.photo)
        XCTAssertEqual(hero.favorite, apiHero2.favorite)
    }
    
    //MARK: - test_addLoactions_ShouldInsertLocations_andAssociateHero
    
    //vamos a comprobar que se introduce correctamente una localización y que se asocia a un heroe
    func test_addLoactions_ShouldInsertLocations_andAssociateHero() throws {
        //Given
        let apiHero = ApiHero(id: "123", name: "Piña", info: "piña no es un coco", photo: "Foto", favorite: false)
        let apiLocation = ApiLocation(id: "1234", date: "date", latitude: "X", longitude: "Y", hero: apiHero)
        
        //When
        sut.add(heroes:[apiHero]) //se añade un heroe a la BBDD
        sut.add(locations: [apiLocation]) //se añade una localización a la BBDD
        let heroes = sut.fetchHeroes(filter: nil) //se hace una request de heroes
        let heroe = try XCTUnwrap(heroes.first) //se desempaqueta el primer heroe
        
        //Then
        XCTAssertEqual(heroe.locations?.count, 1) //el contador de localizaciones de heroe debe ser 1
        let location = try XCTUnwrap(heroe.locations?.first) //se desempaqueta la localización
        //se comprueba que los atributos de la localizacion de la BBDD correspondan con los recibidos de la API
        XCTAssertEqual(location.id, apiLocation.id)
        XCTAssertEqual(location.date, apiLocation.date)
        XCTAssertEqual(location.latitude, apiLocation.latitude)
        XCTAssertEqual(location.longitude, apiLocation.longitude)
        XCTAssertEqual(location.hero?.id, apiHero.id) //se comprueba aquí la relación entre heroe y location
    }
    
    func test_addTransformation_ShouldInsertTransformation_andAssociateHero() throws {
        //Given
        let apiHero = ApiHero(id: "123", name: "Piña", info: "piña no es un coco", photo: "Foto", favorite: false)
        let apiTransformation = ApiTransformation(id: "1", name: "transformation", photo: "foto", info: "info", hero: apiHero)
        
        //When
        sut.add(heroes:[apiHero]) //se añade un heroe a la BBDD
        sut.add(transformations: [apiTransformation]) //se añade una transformación a la BBDD
        let heroes = sut.fetchHeroes(filter: nil) //se hace una request de heroes
        let heroe = try XCTUnwrap(heroes.first) //se desempaqueta el primer heroe
        
        //Then
        XCTAssertEqual(heroe.transformations?.count, 1) //el contador de transformaciones de heroe debe ser 1
        let transformation = try XCTUnwrap(heroe.transformations?.first) //se desempaqueta la transformación
        //se comprueba que los atributos de la transformación de la BBDD correspondan con los recibidos de la API
        XCTAssertEqual(transformation.id, apiTransformation.id)
        XCTAssertEqual(transformation.name, apiTransformation.name)
        XCTAssertEqual(transformation.photo, apiTransformation.photo)
        XCTAssertEqual(transformation.info, apiTransformation.info)
        XCTAssertEqual(transformation.hero?.id, apiHero.id) //se comprueba aquí la relación entre heroe y transformation
    }
}
