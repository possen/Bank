//
//  MockHTTPRequest.swift
//
//  Created by Paul Ossenbruggen on 5/11/17.
//
//

import Foundation
import BrightFutures
import Result

// Because the token expired, this is always used rather than a network request.
//
// Might use a mocking library here, but the dependency injection works pretty well with the
// protocol interface. 

//@testable import Bank

class MockHTTPClient : HTTPClient {
    let json : JSON
    
    init(filename: String) {
        let testBundle = Bundle(for: type(of:self))
        guard let resourceURL = testBundle.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: resourceURL),
              let j = try? JSONSerialization.jsonObject(with: data, options: []) else { json = [] ; return }

        json = j
    }
    
    fileprivate func validateNetRequest() -> Future<JSON, NSError> {
        return Future<JSON, NSError> { completion in
            guard let json = self.json as? [String: Any],
                json["error"] as! String == "no-error" else {
                    completion(.failure(NSError(domain: "failed", code: 20, userInfo: nil)))
                    return
            }
            completion(.success(self.json))
        }
    }
    
    public func post(query: String, parameters:[String: String]?) -> Future<JSON, NSError> {
        return validateNetRequest()
    }
    
    public func get(query: String, parameters:[String: String]?) -> Future<JSON, NSError> {
        return validateNetRequest()
    }
}
