//
//  HomeViewModel.swift
//  MVVMExample
//
//  Created by Jean-Pierre Alary on 08/04/2017.
//  Copyright © 2017 Jp. All rights reserved.
//

import RxSwift
import RxCocoa

final class HomeViewModel {
    private let repository: AnyRepository<User>
    private let translator: Translator
    private let stateDispatcher: Variable<ViewState>

    // MARK: Initializer

    init(repository: AnyRepository<User>, translator: Translator) {
        self.repository = repository
        self.translator = translator

        rx_userName = Driver.never()
        rx_userSurname = Driver.never()
        rx_userAge = Driver.never()
        stateDispatcher = Variable(.success)
        rx_state = stateDispatcher.asDriver()
    }

    // MARK: Public

    private(set) var rx_userName: Driver<String>
    private(set) var rx_userSurname: Driver<String>
    private(set) var rx_userAge: Driver<String>

    let rx_state: Driver<ViewState>

    func set(viewWillAppear: Observable<Void>) -> Void {
        let repository = self.repository
        let translator = self.translator

        let rx_user = viewWillAppear
            .do(onNext: { [weak self] () in
                self?.stateDispatcher.value = .loading
            })
            .flatMap { () -> Observable<User> in
                return repository
                    .get(with: GetUserParameter(name: "John", surname: "Doe", age: 12))
                    .map { (result) -> User in
                        switch result {
                        case .noContent:
                            throw ExpectsContentAppError(developerMessage: "no user from api")
                        case .value(let user):
                            return user
                        }
                }
            }
            .asDriver { [weak self] (error) -> SharedSequence<DriverSharingStrategy, User> in
                if let appError = error as? AppError {
                    self?.stateDispatcher.value = .error(message: translator.translation(for: appError.messageKey))
                }

                return Driver.never()
            }
            .do(onNext: { [weak self] (_) in
                self?.stateDispatcher.value = .success
            })

        rx_userName = rx_user.map { $0.name }
        rx_userSurname = rx_user.map { $0.surname }
        rx_userAge = rx_user.map { $0.age }
    }
}
