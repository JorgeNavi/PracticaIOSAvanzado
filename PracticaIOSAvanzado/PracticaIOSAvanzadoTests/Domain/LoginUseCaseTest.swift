//
//  LoginUseCaseTest.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 27/10/24.
//

import XCTest
@testable import PracticaIOSAvanzado

final class LoginUseCaseTest: XCTestCase {
    
    var sut: LoginUseCase!
    var apiProvider: PIAApiProviderProtocol!
    var secureDataStore: SecureDataStoreProtocol!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        apiProvider = PIAApiProviderMock()
        secureDataStore = SecureDataStorageMock()
        sut = LoginUseCase(apiProvider: apiProvider as! PIAApiProvider)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        apiProvider = nil
        secureDataStore = nil
        try super.tearDownWithError()
    }
    
    func test_Login_Success() {
        //Given
        let username = "admin"
        let password = "admin"
        let expectated = expectation(description: "Login")
        
        //When
        sut.login(username: username, password: password) { result in
            switch result {
            case .success:
                expectated.fulfill()
            case .failure:
                XCTFail("Login failed")
            }
        }
        
        //Then
        wait(for: [expectated], timeout: 1)
    }

}
