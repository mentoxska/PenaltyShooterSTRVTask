//
//  URL+Extensions.swift
//  PenaltyShooter
//
//  Created by Branislav on 21/02/2021.
//

import Foundation

extension URL {
    static var shootResult: URL? { return URL(string: APIInfo.baseURL + "shoot") }
}

struct APIInfo {
    static let baseURL = "https://94e554b0-553b-4040-9e9b-a6cfc3d20450.mock.pstmn.io/"
}
