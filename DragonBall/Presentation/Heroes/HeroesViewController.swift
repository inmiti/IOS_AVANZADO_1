//
//  HeroesViewController.swift
//  DragonBall
//
//  Created by ibautista on 16/10/23.
//

import UIKit

protocol HeroesViewControllerDelegate {
    var viewState: (() -> Void) {get set}
    func onViewAppear()

}

// MARK: - View State -
enum HeroesViewState {
    case loading(_ isLoading: Bool)
    case updateData
}

class HeroesViewController: UIViewController {
    // MARK: - Outlets -
    @IBOutlet weak var tableview: UITableView!

    // MARK: - Public Properties -
    var viewModel: HeroesViewControllerDelegate?
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        viewModel?.onViewAppear()
    }

    // MARK: - Private functions -
    private func initViews() {
        tableview.delegate = self
        tableview.dataSource = self
    }

    private func setObserver() {
//        viewModel?.viewState = { [weak self] state in
//            DispatchQueue.main.async {
//                switch state {
//                case: .loading(let isLoading)
//                }
//            }
//        }

    }
}

// MARK: - DataSource & Delegate
extension HeroesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
