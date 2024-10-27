import XCTest

@testable import PracticaIOSAvanzado

final class DetailHeroUseCaseTests: XCTestCase {
    
    var sut: DetailHeroUseCase!
    var apiProvider: PIAApiProviderProtocol!
    var storeDataProvider: StoreDataProvider!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        apiProvider = PIAApiProviderMock()
        storeDataProvider = StoreDataProvider(persistency: .memory)
        sut = DetailHeroUseCase(apiProvider: PIAApiProviderMock(), storeDataProvider: storeDataProvider)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        apiProvider = nil
        storeDataProvider = nil
        try super.tearDownWithError()
    }
    
    func test_LoadLocations_ShouldReturnLocations_forHero() {
        //Given
        let apiHero = try? DataMock.mockHeroes().first
        let apiLocation = try? DataMock.mockLocations().first
    }

}
