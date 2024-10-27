import XCTest
@testable import PracticaIOSAvanzado

final class DetailHeroUseCaseTests: XCTestCase {
    
    var sut: DetailHeroUseCase!
    var apiProvider: PIAApiProviderMock!
    var storeDataProvider: StoreDataProvider!

    override func setUpWithError() throws {
        try super.setUpWithError()
        apiProvider = PIAApiProviderMock()
        storeDataProvider = StoreDataProvider(persistency: .memory)
        sut = DetailHeroUseCase(apiProvider: apiProvider, storeDataProvider: storeDataProvider)
    }

    override func tearDownWithError() throws {
        sut = nil
        apiProvider = nil
        storeDataProvider = nil
        try super.tearDownWithError()
    }


}
