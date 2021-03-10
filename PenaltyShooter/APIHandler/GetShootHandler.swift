//
//  GetShootHandler.swift
//  PenaltyShooter
//
//  Created by Branislav on 21/02/2021.
//

import RxSwift
import UIKit

protocol GetShootHandlerProtocol {
    func getShootResult(by shootDetails: ShootDetails) -> Observable<ShootResult?>
}

class GetShootHandler: GetShootHandlerProtocol {

    private let networkingManager: NetworkingManager

    init(_ networkingManager: NetworkingManager = NetworkManager()) {
        self.networkingManager = networkingManager
    }

    func getShootResult(by shootDetails: ShootDetails) -> Observable<ShootResult?> {
        guard let url = URL.shootResult else {
            return Observable.error(NetworkError.badURL)
        }
        guard let x = shootDetails.xPos?.description, let y = shootDetails.yPos?.description, let radius = shootDetails.radius?.description else {
            return Observable.error(NetworkError.unknown)
        }
        
            let payLoad: [String: String] = ["x": x,
                                             "y": y,
                                             "radius": radius]
       
            let resource = Resource<ShootResult>(url: url, parameter: payLoad)
    
        return networkingManager.load(resource: resource)
            .map { article -> ShootResult? in
                article
            }
            .asObservable()
            .retry(2)
    }
}
