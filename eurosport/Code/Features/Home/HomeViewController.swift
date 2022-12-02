//
//  HomeViewController.swift
//  eurosport
//
//  Created by Thanh on 02/12/2022.
//

import UIKit
import Combine

final class HomeViewController: ViewController {
    
    private var viewModel: HomeViewModel
    private(set) lazy var tableView: UITableView = createTableView()
    private(set) lazy var loader: UIActivityIndicatorView = createActivityIndicator()
    private lazy var refreshControl = createRefreshControl()

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    @available(*, unavailable)
    init() {
        fatalError()
    }
    
    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    required init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = L10n.featured
        
        buildViewHierarchy()
        setConstraints()
        subscribeToPublishers()
        
        viewModel.fetchHome()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(tableView)
        view.addSubview(loader)
    }
    
    private func setConstraints() {
        let tableViewConstraints = tableView.constraintsForAnchoringTo(boundsOf: view)
        NSLayoutConstraint.activate(tableViewConstraints)
        loader.center = view.center
    }
    
    private func subscribeToPublishers() {
        viewModel.currentState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.refreshControl.endRefreshing()
                switch state {
                case .idle:
                    break
                case .error(let error):
                    self?.showError(error)
                case .loading(let previousState):
                    self?.showLoaderIfNeeded(previousState: previousState)
                case .loaded:
                    self?.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(
            title: L10n.error,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: L10n.retry, style: .default) { [weak self] _ in
            self?.reloadViewModel()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func showLoaderIfNeeded(previousState: HomeState?) {
        guard let previousState = previousState else {
            loader.startAnimating()
            return
        }
        if previousState.values.isEmpty {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }
    }
    
    @objc
    private func reloadViewModel() {
        viewModel.fetchHome()
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.tableView(tableView, cellForRowAt: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableView(tableView, didSelectRowAt: indexPath)
    }
}

extension HomeViewController {
    
    private func createTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 350
        tableView.allowsSelection = true
        tableView.refreshControl = refreshControl
        tableView.registerCell(for: HomeTableViewCell.self)
        return tableView
    }
    
    private func createRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadViewModel), for: .valueChanged)
        return refreshControl
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }
}

