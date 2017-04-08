//
//  HomeContainer.swift
//  MVVMExample
//
//  Created by Jean-Pierre Alary on 08/04/2017.
//  Copyright © 2017 Jp. All rights reserved.
//

import Swinject

final class HomeContainer {
    private let container: Container

    // MARK: Initializer

    init(container: Container) {
        self.container = container

        register()
    }

    // MARK: Public

    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }

    // MARK: Private

    private func register() -> Void {
        container.register(AnyRepository<User>.self) { (r) -> AnyRepository<User> in
            AnyRepository(base: UserRepository(httpClient: r.resolve(HTTPClientType.self)!))
        }

        container.register(HomeViewModel.self) { (r) -> HomeViewModel in
            HomeViewModel(
                repository: r.resolve(AnyRepository<User>.self)!,
                translator: r.resolve(Translator.self)!
            )
        }

        container.register(HomeViewController.self) { (r) -> HomeViewController in
            HomeViewController(viewModel: r.resolve(HomeViewModel.self)!)
        }

        container.register(UIWindow.self) { (r) -> UIWindow in
            let window = UIWindow()
            window.rootViewController = r.resolve(HomeViewController.self)!
            
            return window
        }
    }
}
