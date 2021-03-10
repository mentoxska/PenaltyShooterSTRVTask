//
//  ShootViewModelProtocol.swift
//  PenaltyShooter
//
//  Created by Branislav on 21/02/2021.
//

import RxSwift

protocol ShootViewModelProtocol {
    var shootResult: Observable<ShootResult> { get }
    func getShootInfo(by shootDetailsModel: ShootDetails) 
}
