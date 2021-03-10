//
//  ShootViewModel.swift
//  PenaltyShooter
//
//  Created by Branislav on 21/02/2021.
//
import RxSwift
import UIKit

final class ShootViewModel: ShootViewModelProtocol {
    internal var shootResult: Observable<ShootResult>
    private let getShootHandler: GetShootHandlerProtocol
    private let disposeBag = DisposeBag()
    private let shootResultSubject = PublishSubject<ShootResult>()

    init(withGetShoot getShootHandler: GetShootHandlerProtocol = GetShootHandler()) {
        self.getShootHandler = getShootHandler
        self.shootResult = shootResultSubject.asObserver()
    }
    
    func getShootInfo(by shootDetailsModel: ShootDetails) {
        getShootHandler.getShootResult(by: shootDetailsModel)
            .retry(3)
            .catch({ error -> Observable<ShootResult?> in
                print(error.localizedDescription)
                return Observable.just(ShootResult.empty)
            })
            .subscribe(onNext: { [weak self] result in
                if let result = result {
                    self?.shootResultSubject.onNext(result)
                }
            }, onError: { error in
                print("getShootInfo onError: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
