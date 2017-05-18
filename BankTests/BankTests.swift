//
//
//  Created by Paul Ossenbruggen on 5/9/17.
//
//

import XCTest
import BrightFutures
import Result

let getAll = "api/v2/core/get-all-transactions"

@testable import Bank

class BankTests: XCTestCase {
    
    override func setUp() {
        super.setUp()        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllPost() {
        let client = MockHTTPClient(filename: "allData")
        let expectation = self.expectation(description: "testAllPost")
        
        client.post(query: getAll, parameters: nil)
            .onSuccess { data in
                expectation.fulfill()
                
                let json = data as! [String: Any]
                XCTAssertTrue( json.count == 2)
                XCTAssertTrue( json["error"] as! String == "no-error" )
            }.onFailure { error in
                XCTFail("\(error)")
            }
        
        self.wait(for: [expectation], timeout: 120)
    }
    
    func testDataStoreFetch() {
        let client = MockHTTPClient(filename: "allData")
        let expectation = self.expectation(description: "testDataStoreFetch")
        let store = DataStore()
        store.httpClient = client
        
        store.fetch()
            .onSuccess {tranactions in
                expectation.fulfill()
                XCTAssertTrue(tranactions.count > 100)
            }.onFailure { error in
                XCTFail("\(error)")
            }
        
        self.wait(for: [expectation], timeout: 120)
    }
    
    func testDataStoreBadRequestFetch() {
        let client = MockHTTPClient(filename: "BadRequest")
        let expectation = self.expectation(description: "testDataStoreBadRequestFetch")
        let store = DataStore()
        store.httpClient = client
        
        store.fetch()
            .onSuccess {tranactions in
                XCTFail("Should not end up here")
            }.onFailure { error in
                expectation.fulfill()
                XCTAssertNotNil(error)
        }
        
        self.wait(for: [expectation], timeout: 120)
    }

}
