//
//  SearchResultsController.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit
import NewsAPI

final class SearchResultsController: UITableViewController {
    private let cellId = "cellId"
    private let informingCellId = "informingCellId"
    private let footerCellId = "footerCellId"
    
    private let viewModel: SearchResultsViewModel
    
    init() {
        viewModel = SearchResultsViewModel()
        
        super.init(style: .grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        
        view.backgroundColor = Color.backgroundDefault.value
        tableView.backgroundColor = Color.backgroundDefault.value
        
        tableView.register(NewsCell.self, forCellReuseIdentifier: cellId)
        tableView.register(InformingCell.self, forCellReuseIdentifier: informingCellId)
        tableView.register(FooterCell.self, forHeaderFooterViewReuseIdentifier: footerCellId)
        
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .interactive
        
        viewModel.delegate = self
        
        tableView.separatorStyle = .none
        
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchResultsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.state {
        case .data:
            return viewModel.data?.items.count ?? 0
            
        case .emptyOrError,
             .loading:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.state {
        case .data:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsCell
            
            if let item = viewModel.data?.items[safe: indexPath.item] {
                cell.setData(
                    imageUrl: item.urlToImage,
                    titleText: item.title ?? "No title",
                    descriptionText: item.description,
                    sourceAndDateText: "\(item.source?.name ?? "") • \(DateUtility.stringFormat(convertType: .monthAndDayAndYearAndDayNameAndTime, dateString: item.publishedAt) ?? "")"
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
        guard let data = viewModel.data?.items[safe: indexPath.item] else {
            return
        }
        
        presentingViewController?.hidesBottomBarWhenPushed = true
        
        presentingViewController?.navigationController?.pushViewController(
            NewsDetailController(data: data),
            animated: true
        )
        
        presentingViewController?.hidesBottomBarWhenPushed = false
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
}

// MARK: - Pagination

extension SearchResultsController {
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerCellId) as! FooterCell
        
        footer.setData(animating: !(viewModel.data?.isDonePaginating ?? true))
        
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard viewModel.state == .data,
              viewModel.data?.items.isNotEmpty ?? false,
              !(viewModel.data?.isDonePaginating ?? true) else {
            return .zero
        }
        
        return 200
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = viewModel.data?.items.count ?? 0
        
        guard viewModel.state == .data,
              count > 0,
              !(viewModel.data?.isPaginating ?? true),
              !(viewModel.data?.isDonePaginating ?? true),
              indexPath.item >= count - 1 else {
            return
        }
        
        viewModel.fetchDataForPagination()
    }
}

// MARK: - NewsViewModelDelegate

extension SearchResultsController: SearchResultsViewModelDelegate {
    func getData(error: ErrorModel?) {
        guard error == nil else {
            print(error?.message ?? "")
            
            AlertUtility.present(
                title: error?.title ?? "API Error",
                message: error?.message ?? "An error has occurred.",
                delegate: self
            )
            
            tableView.reloadData()
            
            return
        }
        
        if viewModel.state == .data {
            tableView.separatorStyle = .singleLine
        }
        
        tableView.reloadData()
    }
}

// MARK: - Search Results

extension SearchResultsController {
    func searchButtonTapped(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
        viewModel.fetchData(query: text)
        
        tableView.reloadData()
    }
    
    func cancelButtonTapped(_ searchBar: UISearchBar) {
        viewModel.reset()
        
        tableView.reloadData()
    }
}
