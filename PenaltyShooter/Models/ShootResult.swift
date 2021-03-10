//
//  ShootModel.swift
//  PenaltyShooter
//
//  Created by Branislav on 21/02/2021.
//

import Foundation

struct ShootResult: Codable {
    let scored: Bool
}

extension ShootResult {
    static var empty: ShootResult {
        return ShootResult(scored: false)
    }
}
