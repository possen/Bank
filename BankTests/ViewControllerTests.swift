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
        let vc = TransactionsViewController()
        vc.store.httpClient = MockHTTPClient(filename:"allData")
        vc.loadView()
    }
    
}
