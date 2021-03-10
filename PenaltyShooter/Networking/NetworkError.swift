//
//  NetworkError.swift
//  PenaltyShooter
//
//  Created by Branislav on 21/02/2021.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case unknown
    case timeout
}
