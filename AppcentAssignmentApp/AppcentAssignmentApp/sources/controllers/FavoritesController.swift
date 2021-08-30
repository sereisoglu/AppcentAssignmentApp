//
//  FavoritesController.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit
import NewsAPI

final class FavoritesController: UITableViewController {
    private let cellId = "cellId"
    private let informingCellId = "informingCellId"
    
    private let viewModel: FavoritesViewModel
    
    init() {
        viewModel = FavoritesViewModel()
        
        super.init(style: .grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = Color.backgroundDefault.value
        tableView.backgroundColor = Color.backgroundDefault.value
        
        tableView.register(NewsCell.self, forCellReuseIdentifier: cellId)
        tableView.register(InformingCell.self, forCellReuseIdentifier: informingCellId)
        
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        
        viewModel.delegate = self
        
        viewModel.fetchData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FavoritesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.state {
        case .data:
            return viewModel.data.count
            
        case .emptyOrError,
             .loading:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.state {
        case .data:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsCell
            
            if let item = viewModel.data[safe: indexPath.item] {
                cell.setData(
                    imageUrl: item.imageUrl,
                    titleText: item.title ?? "No title",
                    descriptionText: item.description,
                    sourceAndDateText: "\(item.sourceName ?? "") • \(DateUtility.stringFormat(convertType: .monthAndDayAndYearAndDayNameAndTime, dateString: item.publishedAt) ?? "")"
                )
            }
            
            return cell
            
        case .emptyOrError,
             .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: informingCellId, for: indexPath) as! InformingCell
            
            cell.setState(viewModel.state)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModel.data[safe: indexPath.item] else {
            return
        }
        
        navigationController?.hidesBottomBarPushViewController(
            NewsDetailController(data: data),
            animated: true
        )
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.state {
        case .data:
            return UITableView.automaticDimension
            
        case .emptyOrError,
             .loading:
            return 300
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(
            style: .destructive,
            title: "Delete"
        ) { _, indexPath in
            self.viewModel.delete(index: indexPath.row)
        }
        
        return [
            deleteAction
        ]
    }
}

// MARK: - FavoritesViewModelDelegate

extension FavoritesController: FavoritesViewModelDelegate {
    func getDataForFavoritesViewModel() {
        if viewModel.state == .data {
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none
        }
        
        tableView.reloadData()
    }
}
