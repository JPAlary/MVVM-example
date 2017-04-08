//
//  HomeViewController.swift
//  MVVMExample
//
//  Created by Jean-Pierre Alary on 08/04/2017.
//  Copyright © 2017 Jp. All rights reserved.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    private let homeView: HomeView
    private let disposeBag = DisposeBag()

    // MARK: Initializer

    init(viewModel: HomeViewModel) {
        homeView = HomeView(viewModel: viewModel)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View life cycle

    override func loadView() {
        super.loadView()

        view = homeView
        homeView.set(rx_viewWillAppear: self.rx.viewWillAppear)
    }
}
