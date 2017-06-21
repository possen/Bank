//
//  ViewControllerTests.swift
//
//  Created by Paul Ossenbruggen on 5/13/17.
//
//

import XCTest

@testable import Bank

class ViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testViewControllerLoad() {
        let expectation = self.expectation(description: "testViewControllerLoad")
        
        let client = MockHTTPClient(filename: "allData")
        let vc = TransactionsViewController()
        vc.store.httpClient = client
        _ = vc.view
        
        vc.store.dataLoaded = {
            // make sure the table view is fully loaded before fullfilling. 
            DispatchQueue.main.async {
                vc.tableView.reloadData()
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 120)
        
        XCTAssertGreaterThan(vc.store.transactions.count, 10)
        XCTAssertGreaterThanOrEqual(vc.tableView.numberOfSections,  1)
        XCTAssertGreaterThan(vc.tableView.numberOfRows(inSection: 0), 10)
    }
    
}
