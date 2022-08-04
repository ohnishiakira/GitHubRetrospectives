//
//  IntroViewController.swift
//  GitHubRetrospectives
//
//  Created by Akira Ohnishi on 2022/08/04.
//

import Foundation
import UIKit

class IntroViewController: UIViewController {
    let sinceDatePicker = UIDatePicker()
    let beforeDatePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        configureNavigationItems()
    }

    func configureNavigationItems() {
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(onNavItemTapped))
    }

    func configure() {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.text = "app.title".t

        let sinceLabel = UILabel()
        sinceLabel.translatesAutoresizingMaskIntoConstraints = false
        sinceLabel.textColor = .black
        sinceLabel.text = "form.sinceLabel".t

        sinceDatePicker.translatesAutoresizingMaskIntoConstraints = false
        sinceDatePicker.datePickerMode = .date
        sinceDatePicker.date = Calendar.current.date(byAdding: .day, value: -120, to: Date())!

        let sinceStack = UIStackView(arrangedSubviews: [sinceLabel, sinceDatePicker])
        sinceStack.translatesAutoresizingMaskIntoConstraints = false
        sinceStack.axis = .horizontal

        let beforeLabel = UILabel()
        beforeLabel.translatesAutoresizingMaskIntoConstraints = false
        beforeLabel.textColor = .black
        beforeLabel.text = "form.beforeLabel".t

        beforeDatePicker.translatesAutoresizingMaskIntoConstraints = false
        beforeDatePicker.datePickerMode = .date
        beforeDatePicker.date = Date()

        let beforeStack = UIStackView(arrangedSubviews: [beforeLabel, beforeDatePicker])
        beforeStack.translatesAutoresizingMaskIntoConstraints = false
        beforeStack.axis = .horizontal

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.setTitle("form.button".t, for: .normal)
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleLabel, sinceStack, beforeStack, button])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 32
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    @objc func onButtonTap() {
        print("since", sinceDatePicker.date.iso8601String)
        print("before", beforeDatePicker.date.iso8601String)

        let parameters = FetchParameters(since: sinceDatePicker.date, before: beforeDatePicker.date)
        let vc = SummaryViewController(parameters: parameters)

        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func onNavItemTapped() {
        let nav = UINavigationController(rootViewController: AddTokenViewController())

        present(nav, animated: true)
    }
}
