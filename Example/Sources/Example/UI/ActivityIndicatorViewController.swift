//
//  ActivityIndicatorViewController.swift
//  Example
//
//  Created by june chen on 5/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import UIKit

final class ActivityIndicatorViewController: UIViewController {
    var activityIndicator: UIActivityIndicatorView?
    private let loadingText: String

    init(loadingText: String) {
        self.loadingText = loadingText
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.overlayGrey
        view.isOpaque = false
        let activityIndicator = UIActivityIndicatorView(style: .large)
        self.activityIndicator = activityIndicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        let loadingLabel = UILabel.exampleHeadline
        loadingLabel.textColor = .systemGray
        loadingLabel.text = loadingText

        let stackView = UIStackView(arrangedSubviews: [loadingLabel, activityIndicator])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.distribution = .fillEqually

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator?.startAnimating()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activityIndicator?.stopAnimating()
    }

    class func present(fromViewController: UIViewController, loadingText: String = "", actionBlock: @escaping (ActivityIndicatorViewController) -> Void) {
        let activityVC = ActivityIndicatorViewController(loadingText: loadingText)
        activityVC.modalPresentationStyle = .overFullScreen
        fromViewController.present(activityVC, animated: false) {
            DispatchQueue.global().async {
                actionBlock(activityVC)
            }
        }
    }

    func dismiss() {
        dismiss(animated: false, completion: nil)
    }
}
