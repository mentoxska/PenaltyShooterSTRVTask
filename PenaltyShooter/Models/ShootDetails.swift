//
//  ShootDetailsModel.swift
//  PenaltyShooter
//
//  Created by Branislav on 21/02/2021.
//

import Foundation

struct ShootDetails {
    var xPos: Float?
    let yPos: Float?
    let radius: Float?
    
    init(xPos: Float, yPos: Float, radius: Float) {
        self.xPos = xPos
        self.yPos = yPos
        self.radius = radius
    }
}
