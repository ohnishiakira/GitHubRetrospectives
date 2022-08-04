//
//  SummaryViewController.swift
//  GitHubRetrospectives
//
//  Created by Akira Ohnishi on 2022/08/04.
//

import Combine
import UIKit

struct TableRow {
    let reason: String
    let notifications: [Notification]
    let index: Int

    var count: Int {
        notifications.count
    }

    var text: String {
        "\(reason) (\(count))"
    }
}


// reason count
typealias Reasons = TableRow

class SummaryViewController: UIViewController {
    let useCase = FetchNotificationsUseCase()

    let parameters: FetchParameters

    let tableView = UITableView()

    var cancellables = Set<AnyCancellable>()
    var rows: [TableRow] = []

    init(parameters: FetchParameters) {
        self.parameters = parameters

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        configure()
        configureStreams()
    }

    func configureStreams() {
        useCase.delegate = self
        useCase.fetch(parameters: parameters)
    }

    func configure() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc func onRefresh() {
        Task { @MainActor in
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

extension SummaryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "value1")
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = rows[indexPath.row].text

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notifications = rows[indexPath.row].notifications
        let vc = DetailViewController(notifications: notifications)

        navigationController?.pushViewController(vc, animated: true)

        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension SummaryViewController: FetchNotificationsUseCaseDelegate {
    func onFetched(notifications: [Notification]) {
        let reasons = Dictionary(grouping: notifications) { $0.reasonDescription }

        rows = reasons.enumerated().map { index, tuple in
            TableRow(reason: tuple.key, notifications: tuple.value, index: index)
        }

        tableView.reloadData()
    }

    func onAuthenticationRequired() {
        let vc = AddTokenViewController { [self] in
            useCase.fetch(parameters: parameters)
        }

        present(vc, animated: true)
    }

    func onNetworkErrorOccuered() {
        // retry
    }
}
