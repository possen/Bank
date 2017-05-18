//
//  Utils.swift
//
//  Created by Paul Ossenbruggen on 5/11/17.
//
//

import Foundation

enum AppNetErrors : Int {
    case badJSON = 1
    case noData
    case parse
    case badRecord
}

let AppErrorDomain = "NetAppDomain"

func createError(code: AppNetErrors) -> NSError {
    return NSError(domain: AppErrorDomain, code: code.rawValue, userInfo: nil)
}
