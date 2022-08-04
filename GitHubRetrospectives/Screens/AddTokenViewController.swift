//
//  AddTokenViewController.swift
//  GitHubRetrospectives
//
//  Created by Akira Ohnishi on 2022/08/04.
//

import Combine
import UIKit

class AddTokenViewController: UIViewController {
    private let textField = UITextField()
    private let button = UIButton()

    private let useCase = AddTokenUseCase()

    var cancellable = Set<AnyCancellable>()

    let completion: (() -> Void)?

    init(completion: @escaping (() -> Void) = {}) {
        self.completion = completion

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        configure()
        configureNavigationItems()
    }

    func configureNavigationItems() {
        navigationItem.leftBarButtonItem = .init(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(onNavItemTapped))
    }

    func configure() {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "pat.form.title".t
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0

        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .preferredFont(forTextStyle: .caption1)
        descriptionLabel.text = "pat.form.description".t
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        textField.keyboardType = .asciiCapable
        textField.borderStyle = .roundedRect

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("pat.form.button".t, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, textField, button])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 32

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    @objc func onButtonTap() {
        if let text = textField.text {
            useCase.add(personalAccessToken: text)

            dismiss(animated: true)

            completion?()
        }
    }

    @objc func onNavItemTapped() {
        dismiss(animated: true)
    }
}
