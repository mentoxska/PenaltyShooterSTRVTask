//
//  NetworkManager.swift
//  PenaltyShooter
//
//  Created by Branislav on 21/02/2021.
//

import RxSwift

protocol NetworkingManager {
    func load<T: Decodable>(resource: Resource<T>) -> Observable<T>
}

final class NetworkManager: NetworkingManager {
    func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        if resource.parameter != nil {
            return URLRequest.loadWithPayLoad(resource: resource)
        } else {
            return URLRequest.load(resource: resource)
        }
    }
}
