//
//  UserView.swift
//  MVVMExample
//
//  Created by Jean-Pierre Alary on 08/04/2017.
//  Copyright © 2017 Jp. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

final class HomeView: UIView {
    private let disposeBag = DisposeBag()
    private let viewModel: HomeViewModel
    private let nameLabel: UILabel
    private let surnameLabel: UILabel
    private let ageLabel: UILabel
    private let activityIndicator: UIActivityIndicatorView

    // MARK: Initializer

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        nameLabel = UILabel()
        surnameLabel = UILabel()
        ageLabel = UILabel()
        activityIndicator = UIActivityIndicatorView()

        super.init(frame: CGRect.zero)

        backgroundColor = .white

        setUpSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public

    func set(rx_viewWillAppear: Observable<Void>) -> Void {
        viewModel.set(viewWillAppear: rx_viewWillAppear)

        viewModel
            .rx_state
            .map { (state) -> Bool in
                if case .loading = state {
                    return true
                }

                return false
            }
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel
            .rx_state
            .drive(onNext: { (state) in
                switch state {
                case .error(let message):
                    print("You should display a nice view and put \(message)")
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        viewModel
            .rx_userName
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel
            .rx_userSurname
            .drive(surnameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel
            .rx_userAge
            .drive(ageLabel.rx.text)
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private func setUpSubviews() -> Void {
        [nameLabel, surnameLabel, ageLabel].forEach { (label) in
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20.0)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping

            addSubview(label)
        }
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)

        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(60.0)
            make.left.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-20.0)
        }

        surnameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(20.0)
            make.left.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-20.0)
        }

        ageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(surnameLabel.snp.bottom).offset(20.0)
            make.left.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-20.0)
        }
    }
}
