//
//  RESTHTTPRequest.swift
//  Bank
//
//  Created by Paul Ossenbruggen on 5/9/17.
//
//

import Foundation
import BrightFutures

typealias JSON = Any

private let userId = 1110590645
private let authToken = "CC6D55A0854EA83DF114E6FF986E29B3"
private let apiToken = "AppTokenForInterview"

private let token = "GetAllTransactions"
private let baseURLString = "https://2016.api.levelmoney.com/"
 

// MARK: - Protocol HTTPClient -

protocol HTTPClient {
    func get(query: String, parameters:[String: String]?) -> Future<JSON, NSError>
    func post(query: String, parameters:[String: String]?) -> Future<JSON, NSError>
}

// MARK: - HTTPClientInstance -

struct HTTPClientInstance : HTTPClient {
    let base : URL
    let session = URLSession.shared
    
    init(baseURL: URL) {
        self.base = baseURL
    }
    
    init() {
        self.init(baseURL: URL(string: baseURLString)!)
    }
    
    // MARK: - HTTPClient -
    
    public func get(query: String, parameters:[String: String]?) -> Future<JSON, NSError> {
        let dict = commonAttributesDictionary()
        let paramString = dict.reduce("") { "&\($0)=\($1)" }
        let escaped = paramString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var request = createRequest(string: query + "?" + (escaped ?? ""), parameters: parameters)
        request?.httpMethod = "GET"
        return send(request: request)
    }

    public func post(query: String, parameters:[String: String]?) -> Future<JSON, NSError> {
        var request = createRequest(string: query, parameters: parameters)
        let dict = commonAttributesDictionary()
        let json = try? JSONSerialization.data(withJSONObject: dict, options: [])
        request?.httpBody = json    
        request?.httpMethod = "POST"
        return send(request: request)
    }
    
    // MARK: - Utils -
    
    private func send(request: URLRequest?) -> Future<JSON, NSError> {
        return Future { complete in
            guard let request = request else {
                return
            }
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error as NSError? {
                    complete(.failure(error))
                } else if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let json = json {
                        complete(.success(json))
                    } else {
                        complete(.failure(createError(code: .badJSON)))
                    }
                } else {
                    complete(.failure(createError(code: .noData)))
                }
            }
            task.resume()
        }
    }
    
    private func createRequest(string: String, parameters:[String: String]?) -> URLRequest? {
        guard let url = URL(string: string, relativeTo: self.base) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    private func commonAttributesDictionary() -> [String : Any] {
        return
            [ "args" :
                ["uid" : userId,
                 "token": authToken,
                 "api-token": apiToken,
                 "json-strict-mode": false,
                 "json-verbose-response": false]
        ]
    }
}



