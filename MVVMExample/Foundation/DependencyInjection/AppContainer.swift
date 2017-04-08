//
//  AppContainer.swift
//  MVVMExample
//
//  Created by Jean-Pierre Alary on 08/04/2017.
//  Copyright © 2017 Jp. All rights reserved.
//

import Swinject

final class AppContainer {
    private let container: Container

    // MARK: Initializer

    convenience init() {
        self.init(container: Container())
    }

    init(container: Container) {
        self.container = container

        register()
    }

    // MARK: Public

    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }

    func childContainer() -> Container {
        return Container(parent: container)
    }

    // MARK: Private

    private func register() -> Void {
        container
            .register(NetworkActivity.self) { (_) -> NetworkActivity in
                UIApplicationNetworkActivity(application: UIApplication.shared)
            }
            .inObjectScope(.container)

        container
            .register(Translator.self) { (_) -> Translator in
                NSLocalizedStringTranslator()
            }
            .inObjectScope(.container)

        container
            .register(NetworkAdapter.self) { (r) -> NetworkAdapter in
                URLSessionNetworkAdapter(
                    networkActivity: r.resolve(NetworkActivity.self)!,
                    session: URLSession(configuration: .ephemeral)
                )
            }
            .inObjectScope(.container)

        container
            .register(HTTPClientType.self) { (r) -> HTTPClientType in
                AppHTTPClientType(
                    transformer: AnyTransformer(base: EndpointToURLRequestTransformer()),
                    networkAdapter: r.resolve(NetworkAdapter.self)!,
                    requestChain: InterceptorChain<URLRequest>(),
                    responseChain: InterceptorChain<Response>(),
                    httpErrorHandler: AppHTTPErrorHandler()
                )
            }
            .inObjectScope(.container)
    }
}
