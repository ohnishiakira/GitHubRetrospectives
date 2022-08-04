//
//  ViewController.swift
//  GitHubRetrospectives
//
//  Created by Akira Ohnishi on 2022/08/04.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.overrideUserInterfaceStyle = .light
        view.backgroundColor = .white

        configure()
    }

    func configure() {
        let vc = IntroViewController()

        let nav = UINavigationController(rootViewController: vc)

        addChild(nav)
        nav.view.frame = view.bounds
        view.addSubview(nav.view)
        nav.didMove(toParent: self)
    }
}
