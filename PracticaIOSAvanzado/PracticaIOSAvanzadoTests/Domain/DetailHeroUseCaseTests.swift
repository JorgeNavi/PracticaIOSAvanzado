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
    
    func test_LoadLocations_ShouldReturn_HeroLocation() {
        let apiHero = try? DataMock.mockHeroes().first
        let apiLocations = try? DataMock.mockLocations()
        storeDataProvider.add(heroes: [apiHero!])
        storeDataProvider.add(locations: [apiLocations!])
        let expectated = expectation(description: "Load locations")
        
        sut.loadLocationsForHeroWith(id: apiHero?.id ?? "") { result in
            switch result {
            case .success(let locations):
                XCTAssertEqual(locations.count, 1)
                XCTAssertEqual(locations.first?.id, apiLocations?.first?.id)
                XCTAssertEqual(locations.first?.latitude, apiLocations?.first?.latitude)
                expectated.fulfill()
            case .failure:
                XCTFail("Error")
            }
        }
        
        wait(for: [expectated], timeout: 1)
    }
}
